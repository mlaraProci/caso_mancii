view: personalidades {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id,  -- Convertimos el ID a hexadecimal y lo nombramos como `id`
       `participants`.`name` AS name,  -- Agregamos el nombre del participante
       `construct_metrics`.`kind`,
       `construct_metrics_decimal`.`value`,
       MAX(CASE WHEN `construct_metrics`.`kind` = 'amabilidad' THEN `construct_metrics_decimal`.`value` END) AS amabilidad,
       MAX(CASE WHEN `construct_metrics`.`kind` = 'apertura_a_la_experiencia' THEN `construct_metrics_decimal`.`value` END) AS apertura_a_la_experiencia,
       MAX(CASE WHEN `construct_metrics`.`kind` = 'conciencia' THEN `construct_metrics_decimal`.`value` END) AS conciencia,
       MAX(CASE WHEN `construct_metrics`.`kind` = 'estabilidad_emocional' THEN `construct_metrics_decimal`.`value` END) AS estabilidad_emocional,
       MAX(CASE WHEN `construct_metrics`.`kind` = 'extraversion' THEN `construct_metrics_decimal`.`value` END) AS extraversion
FROM `constructs`
JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`

where TRIM(LOWER(`constructs`.`name`)) LIKE '%personalidades%'
  AND `construct_metrics_decimal`.`value` > 0
GROUP BY HEX(`participants`.`id`), `participants`.`name`, `construct_metrics`.`kind`, `construct_metrics_decimal`.`value`;
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Medidas para cada tipo de personalidad
  measure: amabilidad {
    type: max
    sql: ${TABLE}.amabilidad ;;
    description: "Valor máximo de amabilidad"
  }

  measure: apertura_a_la_experiencia {
    type: max
    sql: ${TABLE}.apertura_a_la_experiencia ;;
    description: "Valor máximo de apertura a la experiencia"
  }

  measure: conciencia {
    type: max
    sql: ${TABLE}.conciencia ;;
    description: "Valor máximo de conciencia"
  }

  measure: estabilidad_emocional {
    type: max
    sql: ${TABLE}.estabilidad_emocional ;;
    description: "Valor máximo de estabilidad emocional"
  }

  measure: extraversion {
    type: max
    sql: ${TABLE}.extraversion ;;
    description: "Valor máximo de extraversión"
  }

  measure: count {
    type: count
    drill_fields: [kind]
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      amabilidad,
      apertura_a_la_experiencia,
      conciencia,
      estabilidad_emocional,
      extraversion
    ]
  }
}
