
view: sql_runner_query {
  derived_table: {
    sql: SELECT 
       `construct_metrics`.`kind`,
       `construct_metrics_decimal`.`value`
      FROM `constructs` 
      JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
      JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
      JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
      JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
      WHERE TRIM(LOWER(`projects`.`title`)) LIKE 'previous-test'
      AND TRIM(LOWER(`constructs`.`name`)) LIKE '%tipos de aprendizaje%'
      AND `construct_metrics_decimal`.`value` > 0
      AND HEX(`participants`.`id`) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  set: detail {
    fields: [
        kind,
	value
    ]
  }
}
