# Documentación del Módulo de Recolección - R3Foresta

Este documento describe el flujo funcional y técnico para el registro de material vegetal, asegurando la trazabilidad mediante tecnología Blockchain.

## Descripción del Proceso
1. **Captura de Datos**: El usuario inicia el flujo en la PWA ingresando datos técnicos, ubicación GPS automática y hasta 5 evidencias fotográficas.
2. **Validación de Seguridad**: El backend (NestJS) verifica la identidad mediante el header `x-auth-id` y asegura que el usuario tenga rol de ADMIN o TECNICO.
3. **Persistencia Multicapa**: Los datos se distribuyen entre Supabase Database (información tabular), Supabase Storage (archivos binarios) e IPFS/Pinata (metadata NFT).
4. **Inmutabilidad**: El proceso finaliza con el acuñado (mint) de un NFT en la Blockchain, guardando el hash de transacción y el token ID para garantizar la transparencia.

## Observaciones y Mejoras Identificadas
* **Feedback de Procesos Largos**: Se recomienda implementar una barra de progreso por etapas (DB, IPFS, Blockchain) para evitar la incertidumbre del usuario durante el registro.
* **Resiliencia en Blockchain**: Implementar un sistema de reintentos para el minteo de NFT en caso de fallos de red, evitando que registros de Supabase queden sin su respaldo on-chain.
* **Pre-validación en Frontend**: Validar el tamaño (<5MB) y formato de las imágenes en la PWA antes del envío para mejorar la experiencia del usuario y optimizar recursos del servidor.