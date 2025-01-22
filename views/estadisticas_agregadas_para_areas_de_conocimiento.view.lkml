view: estadisticas_agregadas_para_areas_de_conocimiento {
  derived_table: {
    sql: SELECT
       cm.kind,
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
JOIN project_clients pc ON pc.project_id = pr.id
JOIN clients cl ON cl.id = pc.client_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
WHERE TRIM(LOWER(pr.title)) LIKE 'previous-test'  -- Filtrado por el título del proyecto
  AND TRIM(LOWER(c.name)) LIKE '%areas de conocimiento%'  -- Filtrado por el nombre del constructo
  AND cmd.value > 0  -- Filtrado de valores mayores a 0
  AND LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))  -- Filtro dinámico para el acrónimo del cliente
GROUP BY cm.kind;  -- Agrupación por el tipo de constructo
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

  measure: average {
    type: number
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
    type: number
    sql: ${TABLE}.min_value ;;
  }

  measure: max_value {
    type: number
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
