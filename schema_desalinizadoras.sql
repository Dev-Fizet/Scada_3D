-- ============================================================================
-- Modelo de Datos: Sistema de Monitoreo y Trazabilidad Operativa (RO)
-- Motor: SQL Server (T-SQL)
-- ============================================================================

CREATE TABLE dim_unidades_ro (
    unidad_id VARCHAR(10) PRIMARY KEY,
    nombre_unidad VARCHAR(50) NOT NULL,
    capacidad_nominal_gpm DECIMAL(8,2) NOT NULL,
    modelo_membrana VARCHAR(50) NOT NULL,
    cantidad_membranas INT NOT NULL,
    recuperacion_diseno_pct DECIMAL(5,2) NOT NULL,
    fecha_puesta_marcha DATE NOT NULL,
    estado_actual VARCHAR(20) DEFAULT 'Operativa'
);

CREATE TABLE fact_operacion_diaria (
    registro_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    unidad_id VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES dim_unidades_ro(unidad_id),
    horas_operacion DECIMAL(5,2) NOT NULL,
    caudal_alimentacion_gpm DECIMAL(8,2) NOT NULL,
    caudal_permeado_gpm DECIMAL(8,2) NOT NULL,
    caudal_rechazo_gpm DECIMAL(8,2) NOT NULL,
    presion_entrada_ro_bar DECIMAL(6,2) NOT NULL,
    presion_salida_rechazo_bar DECIMAL(6,2) NOT NULL,
    dp_prefiltracion_bar DECIMAL(5,2) NOT NULL,
    tds_alimentacion_ppm DECIMAL(10,2) NOT NULL,
    tds_permeado_ppm DECIMAL(8,2) NOT NULL,
    temperatura_agua_c DECIMAL(5,2) NOT NULL,
    energia_consumida_kwh DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(255) NULL
);

CREATE TABLE fact_eventos_cip (
    evento_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_evento DATE NOT NULL,
    unidad_id VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES dim_unidades_ro(unidad_id),
    tipo_intervencion VARCHAR(50) NOT NULL, -- 'CIP Alcalino', 'CIP Acido', 'Cambio Cartuchos', 'Retrolavado'
    producto_quimico VARCHAR(80) NULL,
    cantidad_consumida_kg DECIMAL(8,2) NULL,
    dp_antes_bar DECIMAL(5,2) NULL,
    dp_despues_bar DECIMAL(5,2) NULL,
    responsable VARCHAR(80) NULL
);
GO

CREATE VIEW vw_indicadores_normalizados_ro AS
SELECT
    f.fecha,
    f.unidad_id,
    u.nombre_unidad,
    u.capacidad_nominal_gpm,
    f.horas_operacion,
    f.caudal_permeado_gpm,
    CAST(f.caudal_permeado_gpm * 0.227125 * f.horas_operacion AS DECIMAL(10,2)) AS produccion_diaria_m3,
    CAST((f.caudal_permeado_gpm / NULLIF(f.caudal_alimentacion_gpm, 0)) * 100 AS DECIMAL(5,2)) AS recuperacion_real_pct,
    CAST((f.presion_entrada_ro_bar - f.presion_salida_rechazo_bar) AS DECIMAL(5,2)) AS dp_ro_bar,
    f.dp_prefiltracion_bar,
    CAST((1.0 - (f.tds_permeado_ppm / NULLIF(f.tds_alimentacion_ppm, 0))) * 100 AS DECIMAL(6,3)) AS rechazo_sales_pct,
    CAST(f.energia_consumida_kwh / NULLIF((f.caudal_permeado_gpm * 0.227125 * f.horas_operacion), 0) AS DECIMAL(6,2)) AS consumo_especifico_kwh_m3,
    CASE
        WHEN (f.presion_entrada_ro_bar - f.presion_salida_rechazo_bar) >= 2.2 THEN 'Alerta CIP'
        WHEN (1.0 - (f.tds_permeado_ppm / NULLIF(f.tds_alimentacion_ppm, 0))) * 100 < 98.5 THEN 'Revisar Membranas'
        ELSE 'Optimo'
    END AS estado_operativo
FROM fact_operacion_diaria f
INNER JOIN dim_unidades_ro u ON f.unidad_id = u.unidad_id;
GO
