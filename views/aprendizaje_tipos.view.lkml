view: aprendizaje_tipos {
  derived_table: {
    sql:
      SELECT
    HEX(`participants`.`id`) AS `id`, -- Convertimos el ID a formato hexadecimal
    `participants`.`name` AS `name`, -- Incluimos el campo name de la tabla participants
    LOWER(TRIM(`construct_metrics`.`kind`)) AS `kind`, -- Incluimos kind como una columna directa, normalizando el valor
    `construct_metrics_decimal`.`value` AS `value`, -- Incluimos el valor original de la métrica
    CASE
        WHEN `construct_metrics_decimal`.`value` <= 0.33 THEN 'Bajo' -- Valores entre 0 y 0.33
        WHEN `construct_metrics_decimal`.`value` > 0.33 AND `construct_metrics_decimal`.`value` <= 0.66 THEN 'Medio' -- Valores entre 0.34 y 0.66
        ELSE 'Alto' -- Valores mayores a 0.66
    END AS `value_category` -- Clasificamos el valor como Bajo, Medio o Alto
FROM `constructs`
JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
JOIN `clients` cl ON `projects`.`client_id` = cl.id  -- Relación con la tabla `clients`
JOIN `socio_demographics` sd ON `participants`.`id` = sd.participant_id  -- Cambio de `schools_data` a `socio_demographics`
WHERE LOWER(TRIM(`constructs`.`name`)) LIKE '%aprendizaje%' -- Filtramos por el nombre del constructo
  AND `construct_metrics_decimal`.`value` > 0 -- Filtramos valores mayores a 0
  AND TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["client_acronym"] }}', '%')) -- Filtro dinámico para el acrónimo del cliente
  AND (
      '{{ _user_attributes["city"] }}' IS NULL
      OR '{{ _user_attributes["city"] }}' = ''
      OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["city"] }}', '%'))
  )
  AND (
      '{{ _user_attributes["school"] }}' IS NULL
      OR '{{ _user_attributes["school"] }}' = ''
      OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["school"] }}', '%'))
  )
GROUP BY HEX(`participants`.`id`), `participants`.`name`, `construct_metrics`.`kind`, `construct_metrics_decimal`.`value`;
;;
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
    description: "Tipo de aprendizaje (kind)"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor original asociado al tipo aprendizaje"
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
    type: count_distinct
    sql: ${value} ;;
    description: "Suma total de los valores de aprendizaje"
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
