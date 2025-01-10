view: Types {
  derived_table: {
    sql:
      SELECT
        HEX(`participants`.`id`) AS id, -- Convertimos el ID a formato hexadecimal
        `participants`.`name` AS name, -- Incluimos el campo name de la tabla participants
        LOWER(TRIM(`construct_metrics`.`kind`)) AS kind, -- Incluimos kind como una columna directa, normalizando el valor
        `construct_metrics_decimal`.`value` AS value, -- Incluimos el valor original de la métrica
        CASE
          WHEN `construct_metrics_decimal`.`value` <= 0.33 THEN 'Bajo' -- Valores entre 0 y 0.33
          WHEN `construct_metrics_decimal`.`value` > 0.33 AND `construct_metrics_decimal`.`value` <= 0.66 THEN 'Medio' -- Valores entre 0.34 y 0.66
          ELSE 'Alto' -- Valores mayores a 0.66
        END AS value_category -- Clasificamos el valor como Bajo, Medio o Alto
      FROM `constructs`
      JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
      JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
      JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
      JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
      WHERE LOWER(TRIM(`constructs`.`name`)) LIKE '%inteligencias%'
      AND `construct_metrics_decimal`.`value` > 0
      GROUP BY HEX(`participants`.`id`), name, kind, value, value_category ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre del participante"
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de inteligencia (kind)"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor original asociado al tipo de inteligencia"
  }

  dimension: value_category {
    type: string
    sql: ${TABLE}.value_category ;;
    description: "Clasificación del valor como Bajo, Medio o Alto"
  }

  measure: count_low {
    type: sum
    sql: CASE WHEN ${value_category} = 'Bajo' THEN 1 ELSE NULL END ;;
    description: "Conteo de valores clasificados como Bajo"
  }

  measure: count_medium {
    type: sum
    sql: CASE WHEN ${value_category} = 'Medio' THEN 1 ELSE NULL END ;;
    description: "Conteo de valores clasificados como Medio"
  }

  measure: count_high {
    type: sum
    sql: CASE WHEN ${value_category} = 'Alto' THEN 1 ELSE NULL END ;;
    description: "Conteo de valores clasificados como Alto"
  }

  measure: total_value {
    type: sum
    sql: ${value} ;;
    description: "Suma total de los valores de inteligencia"
  }

  set: detail {
    fields: [
      id,
      name,
      kind,
      value,
      value_category,
      count_low,
      count_medium,
      count_high,
      total_value
    ]
  }
  }
