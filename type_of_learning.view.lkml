view: type_of_learning {

  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id, -- Convertimos el ID a formato hexadecimal
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind, -- Incluimos kind como una columna directa, normalizando el valor
       `construct_metrics_decimal`.`value` AS value -- Incluimos value como una columna directa
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
    WHERE LOWER(TRIM(`projects`.`title`)) LIKE 'previous-test'
    AND LOWER(TRIM(`constructs`.`name`)) LIKE '%tipos de aprendizaje%'
    AND `construct_metrics_decimal`.`value` > 0 ;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensión para `kind`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de aprendizaje como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de aprendizaje como dimensión"
  }

  # Medida genérica para el valor total
  measure: total_value {
    type: sum
    sql: ${value} ;;
    description: "Suma total de valores para todos los tipos de aprendizaje"
  }

  # Medidas específicas para cada tipo de aprendizaje
  measure: auditiva {
    type: sum
    sql: CASE WHEN ${kind} = 'auditiva' THEN ${value} ELSE NULL END ;;
    description: "Suma del tipo de aprendizaje auditivo"
  }

  measure: kinestesica {
    type: sum
    sql: CASE WHEN ${kind} = 'kinestesica' THEN ${value} ELSE NULL END ;;
    description: "Suma del tipo de aprendizaje kinestésico"
  }

  measure: lectura_escritura {
    type: sum
    sql: CASE WHEN ${kind} = 'lectura/escritura' THEN ${value} ELSE NULL END ;;
    description: "Suma del tipo de aprendizaje lectura/escritura"
  }

  measure: visual {
    type: sum
    sql: CASE WHEN ${kind} = 'visual' THEN ${value} ELSE NULL END ;;
    description: "Suma del tipo de aprendizaje visual"
  }

  measure: social {
    type: sum
    sql: CASE WHEN ${kind} = 'social' THEN ${value} ELSE NULL END ;;
    description: "Suma del tipo de aprendizaje social"
  }

  # Conjunto de campos detallados
  set: detail {
    fields: [
      id,
      kind,
      value,
      total_value,
      auditiva,
      kinestesica,
      lectura_escritura,
      visual,
      social
    ]
  }
}
