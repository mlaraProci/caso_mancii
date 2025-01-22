view: estadisticas_agregadas_para_inteligencias {
  derived_table: {
    sql:SELECT
       cm.kind,  -- Tipo de métrica
       AVG(cmd.value) AS average,  -- Promedio de los valores
       STDDEV(cmd.value) AS std_deviation,  -- Desviación estándar
       VARIANCE(cmd.value) AS variance,  -- Varianza
       MIN(cmd.value) AS min_value,  -- Valor mínimo
       MAX(cmd.value) AS max_value,  -- Valor máximo
       SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.value ORDER BY cmd.value),
            ',',
            ROUND(0.5 * COUNT(cmd.value))
          ),
          ',',
          -1
        ) AS median_value,  -- Mediana
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.value ORDER BY cmd.value),
            ',',
            ROUND(0.25 * COUNT(cmd.value))
          ),
          ',',
          -1
        ) AS first_quartile,  -- Primer cuartil
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.value ORDER BY cmd.value),
            ',',
            ROUND(0.75 * COUNT(cmd.value))
          ),
          ',',
          -1
        ) AS third_quartile  -- Tercer cuartil
FROM constructs c
JOIN projects pr ON pr.id = c.project_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
WHERE TRIM(LOWER(pr.title)) LIKE 'previous-test'  -- Filtrar por el proyecto "previous-test"
  AND TRIM(LOWER(c.name)) LIKE '%inteligencias%'  -- Filtrar constructos relacionados con "inteligencias"
  AND cmd.value > 0  -- Considerar solo valores positivos
GROUP BY cm.kind;  -- Agrupación por tipo de métrica
;
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  #dimension: name {
  #  type: string
  #  sql: ${TABLE}.name ;;
  #}

  measure: average {
    type: average
    sql: ${TABLE}.average ;;
  }

  measure: std_deviation {
    type: number
    sql: ${TABLE}.std_deviation ;;
  }

  measure: variance {
    type: number
    sql: ${TABLE}.variance ;;
  }

  measure: min_value {
    type: min
    sql: ${TABLE}.min_value ;;
  }

  measure: max_value {
    type: max
    sql: ${TABLE}.max_value ;;
  }

  measure: median_value {
    type: number
    sql: ${TABLE}.median_value ;;
  }

  measure: first_quartile {
    type: number
    sql: ${TABLE}.first_quartile ;;
  }

  measure: third_quartile {
    type: number
    sql: ${TABLE}.third_quartile ;;
  }

  set: detail {
    fields: [
      kind,
      average,
      std_deviation,
      variance,
      min_value,
      max_value,
      median_value,
      first_quartile,
      third_quartile
    ]
  }
}
