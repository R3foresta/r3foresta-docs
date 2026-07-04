-- 050_m3_campania_edicion_eliminacion_estricta_mvp.sql
-- Modulo 3 (Plantacion) — regla MVP:
-- - datos generales de campania corregibles sin cascada;
-- - tipo solo editable si no hay subcampanias;
-- - desactivacion logica permitida si no hay subcampanias o si todas estan CANCELADA;
-- - DELETE fisico solo si no hay subcampanias.
--
-- Origen: RN-PLA-38 / ADR-PLA-01.
-- Depende de: 028 (campania), 029 (subcampania), 037 (campania.tipo).
-- Idempotente.

DO $$
BEGIN
  IF to_regclass('public.campania') IS NULL THEN
    RAISE EXCEPTION 'No existe public.campania. Ejecuta la migracion 028 primero.';
  END IF;

  IF to_regclass('public.campania_organizacion') IS NULL THEN
    RAISE EXCEPTION 'No existe public.campania_organizacion. Ejecuta la migracion 028 primero.';
  END IF;

  IF to_regclass('public.subcampania') IS NULL THEN
    RAISE EXCEPTION 'No existe public.subcampania. Ejecuta la migracion 029 primero.';
  END IF;
END $$;

-- El trigger especifico de tipo creado en 037 queda reemplazado por una
-- regla MVP mas precisa: permite correcciones generales, bloquea cambio de
-- tipo si ya hay subcampanias, y regula desactivacion/eliminacion.
DROP TRIGGER IF EXISTS trg_campania_tipo_inmutable ON public.campania;
DROP TRIGGER IF EXISTS trg_campania_edicion_estricta_mvp ON public.campania;
DROP TRIGGER IF EXISTS trg_campania_edicion_eliminacion_estricta_mvp ON public.campania;
DROP TRIGGER IF EXISTS trg_campania_delete_estricto_mvp ON public.campania;
DROP FUNCTION IF EXISTS public.check_campania_edicion_estricta_mvp();
DROP FUNCTION IF EXISTS public.check_campania_edicion_eliminacion_estricta_mvp();

CREATE OR REPLACE FUNCTION public.check_campania_edicion_eliminacion_estricta_mvp()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- DELETE fisico solo para campanias que nunca tuvieron subcampanias.
  IF TG_OP = 'DELETE' THEN
    IF EXISTS (
      SELECT 1
      FROM public.subcampania
      WHERE campania_id = OLD.id
    ) THEN
      RAISE EXCEPTION
        'CAMPANIA % no se puede eliminar: ya tiene subcampanias asociadas',
        OLD.id;
    END IF;

    RETURN OLD;
  END IF;

  -- El tipo define el tipo de las subcampanias hijas; no se cambia si ya
  -- existe alguna hija porque exigiría cascada y revalidacion.
  IF OLD.tipo IS DISTINCT FROM NEW.tipo
     AND EXISTS (
       SELECT 1
       FROM public.subcampania
       WHERE campania_id = OLD.id
     ) THEN
    RAISE EXCEPTION
      'CAMPANIA % no puede cambiar tipo: ya tiene subcampanias asociadas',
      OLD.id;
  END IF;

  -- Soft-delete/inactivacion: permitido sin subcampanias o si todas las
  -- subcampanias asociadas estan CANCELADA.
  IF NEW.deleted_at IS NOT NULL
     AND (
       OLD.deleted_at IS DISTINCT FROM NEW.deleted_at
       OR OLD.deleted_by IS DISTINCT FROM NEW.deleted_by
     )
     AND EXISTS (
       SELECT 1
       FROM public.subcampania
       WHERE campania_id = OLD.id
         AND estado <> 'CANCELADA'
     ) THEN
    RAISE EXCEPTION
      'CAMPANIA % no se puede desactivar: tiene subcampanias no canceladas',
      OLD.id;
  END IF;

  RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS trg_campania_edicion_eliminacion_estricta_mvp
  ON public.campania;

CREATE TRIGGER trg_campania_edicion_eliminacion_estricta_mvp
BEFORE UPDATE OF tipo, deleted_at, deleted_by
ON public.campania
FOR EACH ROW
EXECUTE FUNCTION public.check_campania_edicion_eliminacion_estricta_mvp();

DROP TRIGGER IF EXISTS trg_campania_delete_estricto_mvp
  ON public.campania;

CREATE TRIGGER trg_campania_delete_estricto_mvp
BEFORE DELETE
ON public.campania
FOR EACH ROW
EXECUTE FUNCTION public.check_campania_edicion_eliminacion_estricta_mvp();

COMMENT ON FUNCTION public.check_campania_edicion_eliminacion_estricta_mvp() IS
  'Regla MVP RN-PLA-38: bloquea cambio de tipo con subcampanias; permite soft-delete sin subcampanias o con todas CANCELADA; bloquea DELETE fisico si hay subcampanias.';

-- La relacion CAMPANIA_ORGANIZACION queda editable. Si una version anterior
-- del borrador de esta migracion se aplico, limpiamos el trigger restrictivo.
DROP TRIGGER IF EXISTS trg_campania_organizacion_edicion_estricta_mvp
  ON public.campania_organizacion;
DROP FUNCTION IF EXISTS public.check_campania_organizacion_edicion_estricta_mvp();
