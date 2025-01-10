view: personality {
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
    AND LOWER(TRIM(`constructs`.`name`)) LIKE '%personalidad%'
    AND `construct_metrics_decimal`.`value` > 0
    ;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensiones adicionales para `kind` y `value`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de personalidad"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor de la personalidad"
  }

  measure: kind_value {
    type: sum
    sql: CASE WHEN ${kind} = ${kind} THEN ${value} ELSE NULL END ;;
    description: "Valor máximo de amabilidad"
  }


  set: detail {
    fields: [
      id,
      kind,
      kind_value
    ]
  }
}
