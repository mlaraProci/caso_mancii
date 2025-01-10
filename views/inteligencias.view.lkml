view: inteligencias {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id, -- Convertimos el ID a formato hexadecimal
       `participants`.`name` AS name, -- Incluimos el campo name de la tabla participants
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind, -- Incluimos kind como una columna directa, normalizando el valor
       `construct_metrics_decimal`.`value` AS value -- Incluimos value como una columna directa
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`

    where LOWER(TRIM(`constructs`.`name`)) LIKE '%inteligencias%'
    AND `construct_metrics_decimal`.`value` > 0
    GROUP BY HEX(`participants`.`id`), name, kind, value;
 ;;
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
    description: "Tipo de inteligencia como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de inteligencia como dimensión"
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Medidas para cada tipo de inteligencia basadas en `kind`
  measure: Inteligencia_corporalkinestesica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_corporalkinestesica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia corporal-kinestésica"
  }

  measure: Inteligencia_espacial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_espacial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia espacial"
  }

  measure: Inteligencia_existencial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_existencial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia existencial"
  }

  measure: Inteligencia_interpersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_interpersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia interpersonal"
  }

  measure: Inteligencia_intrapersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_intrapersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia intrapersonal"
  }

  measure: Inteligencia_linguistica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_linguistica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lingüística"
  }

  measure: Inteligencia_logicomatematica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_logicomatematica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lógico-matemática"
  }

  measure: Inteligencia_musical {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_musical' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia musical"
  }

  measure: Inteligencia_naturalista {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_naturalista' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia naturalista"
  }
  measure: count {
    type: count
    drill_fields: [id, kind, value]
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      Inteligencia_corporalkinestesica,
      Inteligencia_espacial,
      Inteligencia_existencial,
      Inteligencia_interpersonal,
      Inteligencia_intrapersonal,
      Inteligencia_linguistica,
      Inteligencia_logicomatematica,
      Inteligencia_musical,
      Inteligencia_naturalista
    ]
  }
}
