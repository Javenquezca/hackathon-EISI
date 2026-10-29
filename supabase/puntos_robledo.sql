-- Esquina Viva · nuevos puntos (esquinas/tramos) de Robledo, comuna 7, Medellín
-- Cómo usarlo: Supabase > SQL Editor > New query, pega todo y presiona Run.
-- Se puede correr más de una vez sin dañar nada (on conflict do nothing).
-- Coordenadas obtenidas de OpenStreetMap Nominatim (https://nominatim.openstreetmap.org/search),
-- máx. 1 consulta/segundo, con User-Agent "EsquinaViva-Hackaton/1.0". Solo se incluyen puntos
-- cuya respuesta confirma suburb/city_district de "Comuna 7 - Robledo" y postcode 050034 o vacío,
-- y que quedan a menos de 3 km de (6.275, -75.598).

-- c4: q=Carrera 80, Robledo, Medellin, Colombia
-- display_name: "Avenida 80, Comuna 7 - Robledo, Perímetro Urbano Medellín, Medellín, Valle de
-- Aburrá, Antioquia, RAP del Agua y la Montaña, 050034, Colombia"
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c4', 'Cuadra 4 · Robledo (Avenida 80)', 'Avenida 80', 6.274215, -75.590518, 4)
on conflict (id) do nothing;

-- c5: q=Carrera 83, Robledo, Medellin, Colombia
-- display_name: "Carrera 83, Robledo, Comuna 7 - Robledo, Perímetro Urbano Medellín, Medellín,
-- Valle de Aburrá, Antioquia, RAP del Agua y la Montaña, 050034, Colombia"
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c5', 'Cuadra 5 · Robledo (Carrera 83)', 'Carrera 83', 6.275032, -75.594565, 5)
on conflict (id) do nothing;

-- c6: q=San German, Robledo, Medellin, Colombia
-- display_name: "San Germán, Comuna 7 - Robledo, Perímetro Urbano Medellín, Medellín, Valle de
-- Aburrá, Antioquia, RAP del Agua y la Montaña, 050034, Colombia"
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c6', 'Cuadra 6 · San Germán (barrio)', 'San Germán', 6.268687, -75.588573, 6)
on conflict (id) do nothing;

-- c7: q=Calle 65, Robledo, Medellin, Colombia
-- display_name: "Calle 65, Nueva Villa de La Iguaná, Comuna 7 - Robledo, Perímetro Urbano
-- Medellín, Medellín, Valle de Aburrá, Antioquia, RAP del Agua y la Montaña, 050034, Colombia"
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c7', 'Cuadra 7 · Nva. Villa La Iguaná (Calle 65)', 'La Iguaná', 6.263478, -75.585306, 7)
on conflict (id) do nothing;

-- c8: q=Aures, Medellin, Colombia
-- display_name: "Parque El Buen Paso y áreas arboladas de la quebrada Malpaso en Aures, Comuna 7
-- - Robledo, Perímetro Urbano Medellín, Medellín, Valle de Aburrá, Antioquia, RAP del Agua y la
-- Montaña, Colombia" (sin postcode en la respuesta; se admite por regla)
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c8', 'Cuadra 8 · Aures (Parque El Buen Paso)', 'Aures', 6.287492, -75.590421, 8)
on conflict (id) do nothing;

-- c9: q=Institucion Educativa Robledo, Medellin, Colombia
-- display_name: "Institución Educativa Mariscal Robledo, Carrera 85, Robledo, Comuna 7 - Robledo,
-- Perímetro Urbano Medellín, Medellín, Valle de Aburrá, Antioquia, RAP del Agua y la Montaña,
-- 050034, Colombia"
insert into public.puntos (id, nombre, corto, lat, lng, orden) values
  ('c9', 'Cuadra 9 · Robledo (Cra. 85, colegio)', 'Mariscal Robledo', 6.275191, -75.595902, 9)
on conflict (id) do nothing;

-- Comprobación
select id, corto, lat, lng from public.puntos order by orden;
