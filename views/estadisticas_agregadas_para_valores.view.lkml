view: estadisticas_agregadas_para_valores {
  derived_table: {
    sql: SELECT
       `construct_metrics`.`kind`,
       AVG(`construct_metrics_decimal`.`value`) as `average`,
        STDDEV(`construct_metrics_decimal`.`value`) AS `std_deviation`,
        VARIANCE(`construct_metrics_decimal`.`value`) AS `variance`,
       MIN(`construct_metrics_decimal`.`value`) AS `min_value`,
       MAX(`construct_metrics_decimal`.`value`) AS `max_value`,
       SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(`construct_metrics_decimal`.`value` ORDER BY `construct_metrics_decimal`.`value`),
            ',',
            ROUND(0.5 * COUNT(`construct_metrics_decimal`.`value`))
          ),
          ',',
          -1
        ) AS `median_value`,
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(`construct_metrics_decimal`.`value` ORDER BY `construct_metrics_decimal`.`value`),
            ',',
            ROUND(0.25 * COUNT(`construct_metrics_decimal`.`value`))
          ),
          ',',
          -1
        ) AS `first_quartile`,
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            GROUP_CONCAT(`construct_metrics_decimal`.`value` ORDER BY `construct_metrics_decimal`.`value`),
            ',',
            ROUND(0.75 * COUNT(`construct_metrics_decimal`.`value`))
          ),
          ',',
          -1
        ) AS `third_quartile`
      FROM `constructs`
      JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
      JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
      JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
      WHERE TRIM(LOWER(`projects`.`title`)) LIKE 'previous-test'
      AND TRIM(LOWER(`constructs`.`name`)) LIKE '%valores%'
      AND `construct_metrics_decimal`.`value` > 0
      GROUP BY `construct_metrics`.`kind` ;;
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
