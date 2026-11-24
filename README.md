# Sistema de Monitoreo y Trazabilidad Operativa — Plantas Desalinizadoras (RO)

Solución integral de ingeniería de procesos, analítica operativa y visualización web diseñada para centralizar el control diario, el cálculo de indicadores normalizados (KPIs) y la trazabilidad de limpiezas químicas (CIP) en sistemas de desalación por ósmosis inversa (RO).

## Objetivo del proyecto
Transformar bitácoras operativas dispersas en un modelo analítico estructurado y visual que permita evaluar el desempeño real de las unidades desalinizadoras, anticipar el ensuciamiento (*fouling* / *scaling*) de membranas y optimizar el consumo específico de energía y productos químicos.

## Arquitectura y archivos del repositorio
- `index.html`: Ejemplo educativo de monitoreo industrial en tiempo real mediante NATS WebSocket. Recibe el payload del emisor OT (`equipo`, `temperatura_c`, `nivel_pct`, `bomba_activa`) y puede mostrar múltiples equipos.
- `vercel.json`: Configuración mínima para despliegue de la página estática en Vercel.

## Desplegar en Vercel

1. Sube estos archivos a GitHub: `index.html`, `vercel.json` y `README.md`.
2. En Vercel selecciona **Add New > Project**, importa el repositorio y deja `Framework Preset` en **Other**.
3. Usa el directorio raíz como **Root Directory** y despliega sin comando de compilación.
4. Publica el sitio y abre la URL HTTPS.
5. Presiona **Conectar** en el tablero. El servidor predeterminado es `wss://demo.nats.io:443` y el subject predeterminado es `planta.>`.

La página usa el emisor OT público del taller y recibe JSON publicado en el subject `planta.linea1.reactor.telemetria`.
- `Control_Diario_Desalinizadoras_Muestra.xlsx`: Bitácora operativa estructurada en Excel con fórmulas automatizadas, formato condicional, resumen ejecutivo con gráficos y registro de eventos CIP y retrolavados de prefiltración.
- `Dosificacion_Osmosis_Inversa_Muestra.xlsx`: Calculadora técnica de dosificación química en línea (antiincrustante, bisulfito de sodio, hipoclorito) y preparación de soluciones de limpieza química (CIP).
- `schema_desalinizadoras.sql`: Modelo relacional en SQL Server (tablas de dimensiones, tablas de hechos y vistas analíticas de KPIs normalizados).

## Stack tecnológico
- **Frontend / Visualización Web:** HTML5, CSS3, JavaScript, Chart.js.
- **Analítica y Bitácoras:** Microsoft Excel (fórmulas dinámicas, formato condicional), Power BI & Power Query.
- **Base de Datos:** SQL Server (DDL y vistas analíticas).

## Indicadores clave (KPIs) monitoreados
- **Producción y recuperación:** Caudales de alimentación, permeado y rechazo, porcentaje de recuperación hidráulica y producción específica normalizada.
- **Calidad de agua y rechazo de sales:** Seguimiento de conductividad para el cálculo automático de rechazo de sales:
- **Integridad de membranas:** Monitoreo de presión diferencial  en filtros multimedia/cartucho y bastidores de ósmosis inversa, además del índice de envejecimiento de membranas .
- **Eficiencia energética:** Cálculo del consumo específico de energía .
- **Trazabilidad CIP y mantenimiento:** Control histórico de limpiezas químicas ácidas/alcalinas, cambios de filtros cartucho y retrolavados de medios filtrantes.

## Cómo usar este repositorio
1. **Vista previa en línea (GitHub Pages):**
   - Ve a **Settings > Pages** en este repositorio, selecciona la rama `main` y carpeta `/ (root)`, y guarda. En segundos tendrás el tablero `index.html` funcionando en vivo desde el navegador.
2. **Uso local con tus propios datos:**
   - Descarga los archivos del repositorio.
   - Registra tus lecturas diarias en `Control_Diario_Desalinizadoras_Muestra.xlsx` o conéctalo a tu instancia de SQL Server ejecutando `schema_desalinizadoras.sql`.
   - Vincula las tablas de Excel o SQL mediante Power Query para actualizar tus reportes ejecutivos.
