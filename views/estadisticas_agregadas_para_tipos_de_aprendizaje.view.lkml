view: estadisticas_agregadas_para_tipos_de_aprendizaje {
  derived_table: {
    sql: SELECT
    cm.`kind`,
    AVG(cmd.`value`) AS `average`,
    STDDEV(cmd.`value`) AS `std_deviation`,
    VARIANCE(cmd.`value`) AS `variance`,
    MIN(cmd.`value`) AS `min_value`,
    MAX(cmd.`value`) AS `max_value`,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.`value` ORDER BY cmd.`value`),
            ',',
            ROUND(0.5 * COUNT(cmd.`value`))
        ),
        ',',
        -1
    ) AS `median_value`,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.`value` ORDER BY cmd.`value`),
            ',',
            ROUND(0.25 * COUNT(cmd.`value`))
        ),
        ',',
        -1
    ) AS `first_quartile`,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(
            GROUP_CONCAT(cmd.`value` ORDER BY cmd.`value`),
            ',',
            ROUND(0.75 * COUNT(cmd.`value`))
        ),
        ',',
        -1
    ) AS `third_quartile`
FROM `constructs` c
JOIN `projects` p ON p.`id` = c.`project_id`
JOIN `construct_metrics` cm ON cm.`construct_id` = c.`id`
JOIN `participants` part ON part.`id` = cm.`participant_id`
JOIN `construct_metrics_decimal` cmd ON cm.`id` = cmd.`metric_id`
WHERE TRIM(LOWER(p.`title`)) LIKE 'previous-test'
  AND TRIM(LOWER(c.`name`)) LIKE '%tipos de aprendizaje%'
  AND cmd.`value` > 0
GROUP BY cm.`kind`;
;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

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

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
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
