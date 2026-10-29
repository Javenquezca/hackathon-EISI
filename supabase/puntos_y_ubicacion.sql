-- Esquina Viva · ubicación GPS de los reportes y puntos (cuadras/esquinas) editables
-- Cómo usarlo: Supabase > SQL Editor > New query, pega todo y presiona Run.
-- Se puede correr más de una vez sin dañar nada. No borra ni modifica reportes existentes.

-- 1) Cada reporte guarda la ubicación real del celular (si la persona da permiso)
alter table public.reportes add column if not exists lat double precision;
alter table public.reportes add column if not exists lng double precision;

-- 2) Catálogo de puntos que aparecen en el selector de cuadra y en el mapa
create table if not exists public.puntos (
  id text primary key,                 -- c1, c2, c3, c4...
  nombre text not null,                -- texto del selector
  corto text not null,                 -- etiqueta en el mapa
  lat double precision not null,
  lng double precision not null,
  orden int not null default 0,
  activo boolean not null default true
);

alter table public.puntos enable row level security;
drop policy if exists "leer puntos" on public.puntos;
create policy "leer puntos" on public.puntos for select to anon using (true);
grant select on public.puntos to anon;

-- Los 3 puntos que ya usaba la app (mismas coordenadas del código)
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c1', 'Cuadra 1 · Separador de la avenida', 'Separador avenida', 6.2745, -75.5998, 1),
  ('c2', 'Cuadra 2 · Curazao (Cra. 90D)',      'Curazao',           6.2768, -75.6045, 2),
  ('c3', 'Cuadra 3 · Entorno universitario',   'Universidad',       6.2710, -75.5975, 3)
on conflict (id) do nothing;

-- 3) Para agregar más puntos de Robledo:
--    en Google Maps, clic derecho sobre la esquina > copia las coordenadas (ej. 6.27812, -75.59634)
--    y agrega una fila como esta (quita los dos guiones del inicio):
-- insert into public.puntos (id, nombre, corto, lat, lng, orden) values
--   ('c4', 'Cuadra 4 · <barrio y dirección>', '<etiqueta corta>', 6.27812, -75.59634, 4);

-- Para ocultar un punto sin borrarlo:
-- update public.puntos set activo = false where id = 'c3';

-- Comprobación
select id, corto, lat, lng from public.puntos order by orden;
