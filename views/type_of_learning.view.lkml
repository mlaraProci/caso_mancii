view: type_of_learning {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id,
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind,
       `construct_metrics_decimal`.`value` AS value
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
    AND LOWER(TRIM(`constructs`.`name`)) LIKE '%tipos de aprendizaje%'
    AND `construct_metrics_decimal`.`value` > 0
    ;;
  }

  # Dimensiones
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }


  measure: kind_value {
    type: sum
    sql: CASE WHEN ${kind} = ${kind} THEN ${value} ELSE NULL END ;;
    description: "Suma del valor según el tipo de aprendizaje seleccionado"
  }


  # Conjunto de campos detallados
  set: detail {
    fields: [id, kind, kind_value]
  }
}
