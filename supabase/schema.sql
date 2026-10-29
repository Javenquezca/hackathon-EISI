-- Esquina Viva · esquema de base de datos para Supabase
-- Cómo usarlo: en Supabase abre SQL Editor > New query, pega todo este archivo y presiona Run.

create extension if not exists pgcrypto;

-- Reportes ciudadanos de puntos críticos
create table if not exists public.reportes (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  cuadra text not null,            -- c1, c2, c3
  tipo text not null,              -- fuera, suelta, escombros, anden
  acc boolean not null default false, -- bloquea el paso de sillas de ruedas / coches
  nota text default '',
  foto text default '',            -- imagen comprimida (data URL JPEG)
  ts bigint not null,              -- marca de tiempo en milisegundos
  estado text not null default 'abierto', -- abierto | resuelto
  resuelto_ts bigint
);

-- Entregas de bolsa blanca al reciclador
create table if not exists public.entregas (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  cuadra text not null,
  dia text not null,               -- 3 = miércoles, 5 = viernes
  franja text not null,            -- am | pm
  casa text default '',            -- casa o apartamento, sin nombres
  ts bigint not null
);

-- Validación diaria del guardián (una por cuadra y día)
create table if not exists public.validaciones (
  id text primary key,             -- <cuadra>_<AAAA-MM-DD>
  created_at timestamptz not null default now(),
  cuadra text not null,
  fecha text not null,
  limpio boolean not null,
  foto text default '',
  ts bigint not null
);

-- Seguridad: prototipo abierto (cualquiera con el enlace puede leer y escribir).
-- Para producción, cambiar estas políticas por usuarios autenticados y roles (vecino, guardián, reciclador).
alter table public.reportes enable row level security;
alter table public.entregas enable row level security;
alter table public.validaciones enable row level security;

drop policy if exists "leer reportes" on public.reportes;
drop policy if exists "crear reportes" on public.reportes;
drop policy if exists "resolver reportes" on public.reportes;
create policy "leer reportes" on public.reportes for select to anon using (true);
create policy "crear reportes" on public.reportes for insert to anon with check (true);
create policy "resolver reportes" on public.reportes for update to anon using (true) with check (true);

drop policy if exists "leer entregas" on public.entregas;
drop policy if exists "crear entregas" on public.entregas;
create policy "leer entregas" on public.entregas for select to anon using (true);
create policy "crear entregas" on public.entregas for insert to anon with check (true);

drop policy if exists "leer validaciones" on public.validaciones;
drop policy if exists "crear validaciones" on public.validaciones;
drop policy if exists "actualizar validaciones" on public.validaciones;
create policy "leer validaciones" on public.validaciones for select to anon using (true);
create policy "crear validaciones" on public.validaciones for insert to anon with check (true);
create policy "actualizar validaciones" on public.validaciones for update to anon using (true) with check (true);

-- Permisos explícitos para la llave pública (anon / publishable). Sin borrar.
grant usage on schema public to anon;
grant select, insert, update on public.reportes to anon;
grant select, insert on public.entregas to anon;
grant select, insert, update on public.validaciones to anon;

-- Consultas útiles para el pitch (resultados de la prueba)
-- select tipo, count(*) from reportes group by tipo;
-- select cuadra, count(*) filter (where acc) as bloquean_paso, count(*) as total from reportes group by cuadra;
-- select count(*) from entregas;

-- Vista resumen de prueba: métricas clave para el pitch
-- Cómo usarla: en Supabase abre SQL Editor > New query, pega y ejecuta.
-- Luego consulta con: select * from public.resumen_prueba;
drop view if exists public.resumen_prueba;
create view public.resumen_prueba with (security_invoker = on) as
select
  -- Reportes
  (select count(*) from public.reportes)                                        as total_reportes,
  (select count(*) from public.reportes where estado = 'abierto')               as reportes_abiertos,
  (select count(*) from public.reportes where estado = 'resuelto')              as reportes_resueltos,
  (select count(*) from public.reportes where acc = true)                       as bloquean_paso,
  (select count(*) from public.reportes where tipo = 'fuera')                   as tipo_fuera_horario,
  (select count(*) from public.reportes where tipo = 'suelta')                  as tipo_basura_suelta,
  (select count(*) from public.reportes where tipo = 'escombros')               as tipo_escombros,
  (select count(*) from public.reportes where tipo = 'anden')                   as tipo_anden_ocupado,

  -- Reciclaje
  (select count(*) from public.entregas)                                        as total_entregas_reciclaje,

  -- Guardianes
  (select count(*) from public.validaciones)                                    as total_validaciones,
  (select count(*) from public.validaciones where limpio = true)                as dias_invictos,
  (select count(*) from public.validaciones where limpio = false)               as dias_con_basura,

  -- Cuadra más activa (menos reportes = mejor)
  (select cuadra from public.reportes
    group by cuadra order by count(*) asc limit 1)                             as cuadra_mejor_desempeno,

  -- Cuadra con más bloqueos de accesibilidad
  (select cuadra from public.reportes where acc = true
    group by cuadra order by count(*) desc limit 1)                            as cuadra_mas_bloqueos;
