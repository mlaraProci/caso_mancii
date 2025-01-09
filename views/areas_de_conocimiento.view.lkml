view: areas_de_conocimiento {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id,
       MAX(`participants`.`name`) AS name, -- Agregamos una función de agregación
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind,
       MAX(`construct_metrics_decimal`.`value`) AS value
FROM `constructs`
JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
WHERE LOWER(TRIM(`projects`.`title`)) LIKE 'previous-test'
  AND LOWER(TRIM(`constructs`.`name`)) LIKE '%areas de conocimiento%'
  AND `construct_metrics_decimal`.`value` > 0
GROUP BY HEX(`participants`.`name`), LOWER(TRIM(`construct_metrics`.`kind`));

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
    description: "Área de conocimiento como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al área de conocimiento como dimensión"
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name  ;;
    description: "Nombre"
  }


  # Medidas para cada área de conocimiento basadas en `kind` sin agregar, mostrando el valor máximo
  measure: agronomia {
    type: max
    sql: CASE WHEN ${kind} = 'agronomia' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento agronomía"
  }

  measure: bellas_artes {
    type: max
    sql: CASE WHEN ${kind} = 'bellas_artes' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento bellas artes"
  }

  measure: economia {
    type: max
    sql: CASE WHEN ${kind} = 'economia' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento economía"
  }

  measure: educacion {
    type: max
    sql: CASE WHEN ${kind} = 'educacion' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento educación"
  }

  measure: ingenieria {
    type: max
    sql: CASE WHEN ${kind} = 'ingenieria' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento ingeniería"
  }

  measure: matematicas {
    type: max
    sql: CASE WHEN ${kind} = 'matematicas' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento matemáticas"
  }

  measure: salud {
    type: max
    sql: CASE WHEN ${kind} = 'salud' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento salud"
  }

  measure: sociales {
    type: max
    sql: CASE WHEN ${kind} = 'sociales' THEN ${value} ELSE 0 END ;;
    description: "Valor máximo del área de conocimiento sociales"
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      agronomia,
      bellas_artes,
      economia,
      educacion,
      ingenieria,
      matematicas,
      salud,
      sociales
    ]
  }
}
