# Contexto del Proyecto — Equipo 08 · Hackatón EISI 2026

## Entrega y pitch

- **Fecha:** 29 de octubre de 2026
- **Hora límite de entrega:** 6:00 p.m. (hora Colombia)
- **Pitch en vivo:** 4 minutos + 1 minuto de preguntas

---

## Equipo

| Miembro | Rol |
|---|---|
| Valentina Mejía Consuegra | Coordinación, Brief, fuentes, Lean Canvas, pitch, Declaración de IA |
| Javier Stiven Vásquez | Observación, prototipo, ficha de prototipado, evidencia |
| Andrés Bolívar Osorio | Entrevistas, procesamiento, prueba con usuarios, video de respaldo |

---

## Reto

**ODS 11** — Desplazamientos, espacio público y gestión de residuos en ciudades.

**Enfoque:** residuos + espacio público. Validación en Robledo, comuna 7, Medellín.

**Reto redefinido (Brief):**
> ¿Cómo podríamos lograr que, en una cuadra y un separador de Robledo, los residuos de vecinos y de la población flotante salgan en el horario y lugar correctos y no queden en andenes y separadores, con vecinos, celadores y recicladores avisando y registrando lo que pasa para generar datos de los puntos críticos?

### Requisitos de la solución
- No ser solo una campaña de sensibilización
- No proponer infraestructura grande
- Considerar usuarios vulnerables y personas con discapacidad
- No desplazar el problema a otro sector
- Poder probarse en un sector concreto
- Ser adaptable a México u Honduras
- No depender solo de multas
- Generar datos para decidir

---

## Evidencia de campo

**Observación** (separador arbolado de una avenida de Robledo, 29 oct., 12:30–1:00 p.m.): residuos mezclados en la base de los árboles, el sardinel y la calzada. Sin canecas ni punto de acopio. Actores: peatones, bar en remolque sobre el separador, conductores de bus y taxi.

**Entrevistas:**
- **Residente:** no hay avisos de días/horarios de recolección (miércoles y viernes). Si el carro se pasa, persigue el carro o guarda la bolsa. Cita: «Esta mañana que pasé todavía estaba ahí, pero evité y me pasé de calle».
- **Docente (55–65 años):** la peor hora es cerca de las 6:00 a.m. Cree que la solución es solo de Emvarias. Cita: «Nadie va a recoger la basura de otro, nadie».
- **Celador:** estudiantes y trabajadores (población flotante) también tiran basura, y eso da mala imagen.

**Fuentes:**
- Alcaldía de Medellín: La Iguaná (Robledo) era punto crítico (2025); desde 2024 se han intervenido 146 puntos y solo 7 se han "graduado" (2026).
- Medellín aprovecha el 29 % de sus residuos.
- Minuto30: en Robledo Curazao sacan bolsas después de que pasa el carro y retiraron los contenedores (2025).

---

## Solución: "Esquina Viva"

App web para celular que integra 12 ideas del equipo en 4 módulos:

1. **Reporte y mapa** — QR en la esquina, reporte con foto, opción "bloquea el paso" para sillas de ruedas/escombros con enlace a Emvarias, mapa de puntos críticos de Robledo.
2. **Economía circular y espacio** — franja demarcada abierta/cerrada según horario, código de colores de bolsas (blanca, verde, negra), agenda para entregar la bolsa blanca en mano al reciclador.
3. **Gamificación** — días invictos, puntos (20 por día limpio validado y 10 por entrega), cupón de tienda aliada, reto entre cuadras.
4. **Alertas y guardián** — cuenta regresiva del carro, aviso de 30 min (simulado; versión futura por WhatsApp), validación diaria con foto del celador.

---

## Stack tecnológico

- **Frontend:** HTML + CSS + JavaScript (sin frameworks, sin compilación)
- **Base de datos:** Supabase (Postgres + tiempo real)
- **Hosting:** Vercel
- **QR:** generado desde el enlace de Vercel

### Estructura del repositorio

```
hackathon/
├── index.html          # Marcado principal
├── qr.html
├── config.js           # window.EV_CONFIG (supabaseUrl + supabaseAnonKey)
├── css/
│   └── styles.css      # Variables de color, modo claro y oscuro
├── js/
│   ├── db.js           # window.EVStore: init, add, put, patch (Supabase + localStorage fallback)
│   └── app.js          # Interfaz: estado S, render(), pestañas, constantes CUADRAS y PICKUP
├── vendor/
│   └── supabase.js     # supabase-js 2.45.4 UMD
├── supabase/
│   └── schema.sql
├── vercel.json
└── docs/
```

### Tablas de Supabase (RLS abierta: leer, crear, actualizar; no borrar)

| Tabla | Campos principales |
|---|---|
| `reportes` | id, cuadra, tipo [fuera\|suelta\|escombros\|anden], acc bool, nota, foto (data URL JPEG), ts bigint ms, estado [abierto\|resuelto], resuelto_ts |
| `entregas` | id, cuadra, dia ['3'\|'5'], franja [am\|pm], casa, ts |
| `validaciones` | id `<cuadra>_<AAAA-MM-DD>`, cuadra, fecha, limpio bool, foto, ts |
| Vista `resumen_prueba` | Métricas para el pitch |

---

## Estado GENIA

| Etapa | Estado |
|---|---|
| G — Genera tu reto (Brief + Mosca en la pared) | ✅ Listo |
| E — Explora (entrevistas + fuentes) | ✅ Listo *(falta edad del residente y del celador)* |
| N — Nuevas ideas (12 ideas + matriz Impacto vs. Esfuerzo → plantilla) | ⏳ Pendiente |
| I — Inventa (Lean Canvas, Ficha de prototipado, Prueba con usuarios, Evidencia) | 🔄 En curso |
| A — Aplica (pitch 6 momentos + Declaración de uso de IA) | ⏳ Pendiente |

> El jurado otorga el **40 %** a pertinencia y uso real de GENIA.

---

## Reglas del equipo

- No inventar datos de campo (observación, entrevistas, pruebas): los genera el equipo.
- No incluir nombres ni datos personales de entrevistados (solo rol y edad aproximada).
- Todo uso de IA se anota en la Declaración de uso de IA (herramienta, etapa, para qué, cómo se verificó).
- Al tocar código: conservar la API de `window.EVStore` y los nombres de columnas para evitar conflictos.
