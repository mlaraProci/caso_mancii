view: valores {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id, -- Convertimos el ID a formato hexadecimal
       `participants`.`name` AS name, -- Incluimos el campo name de la tabla participants
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind, -- Incluimos kind como una columna directa, normalizando el valor
       `construct_metrics_decimal`.`value` AS value -- Seleccionamos el valor correspondiente al kind e id
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
    WHERE LOWER(TRIM(`projects`.`title`)) LIKE 'previous-test'
    AND LOWER(TRIM(`constructs`.`name`)) LIKE '%valores%'
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
    description: "Valor como dimensión"
  }
# Dimensión para name
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de valor como dimensión"
  }

  # Medidas para cada tipo de valor basado en `kind`, mostrando el valor máximo
  measure: autodireccion {
    type: max
    sql: CASE WHEN ${kind} = 'autodireccion' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor autodirección"
  }

  measure: benevolencia {
    type: max
    sql: CASE WHEN ${kind} = 'benevolencia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor benevolencia"
  }

  measure: conformidad {
    type: max
    sql: CASE WHEN ${kind} = 'conformidad' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor conformidad"
  }

  measure: estimulacion {
    type: max
    sql: CASE WHEN ${kind} = 'estimulacion' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor estimulación"
  }

  measure: logro {
    type: max
    sql: CASE WHEN ${kind} = 'logro' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor logro"
  }

  measure: poder {
    type: max
    sql: CASE WHEN ${kind} = 'poder' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor poder"
  }

  measure: seguridad {
    type: max
    sql: CASE WHEN ${kind} = 'seguridad' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor seguridad"
  }

  measure: tradicion {
    type: max
    sql: CASE WHEN ${kind} = 'tradicion' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor tradición"
  }

  measure: trascendencia {
    type: max
    sql: CASE WHEN ${kind} = 'trascendencia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor trascendencia"
  }

  measure: universalismo {
    type: max
    sql: CASE WHEN ${kind} = 'universalismo' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del valor universalismo"
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      autodireccion,
      benevolencia,
      conformidad,
      estimulacion,
      logro,
      poder,
      seguridad,
      tradicion,
      trascendencia,
      universalismo
    ]
  }
}
