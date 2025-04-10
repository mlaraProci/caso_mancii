view: areas_de_conocimiento {
  derived_table: {
    sql:SELECT
    HEX(p.`id`) AS `id`,
    MAX(p.`name`) AS `name`, -- Selecciona el nombre máximo en caso de duplicados
    LOWER(TRIM(cm.`kind`)) AS `kind`,
    MAX(cmd.`value`) AS `value`
FROM `constructs` c
JOIN `projects` pr ON pr.`id` = c.`project_id`
JOIN `project_clients` prc ON prc.project_id = pr.id
JOIN `construct_metrics` cm ON cm.`construct_id` = c.`id`
JOIN `participants` p ON p.`id` = cm.`participant_id`
JOIN `construct_metrics_decimal` cmd ON cm.`id` = cmd.`metric_id`
JOIN `clients` cl ON prc.`client_id` = cl.`id`
JOIN `socio_demographics` sd ON p.`id` = sd.`participant_id`
WHERE LOWER(TRIM(c.`name`)) LIKE '%areas de conocimiento%'
  AND cmd.`value` > 0
  AND TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
    {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
          {% assign cities = _user_attributes['city'] | split: ',' %}
          AND (
            {% for c in cities %}
              TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ c | strip | escape }}', '%'))
              {% unless forloop.last %} OR {% endunless %}
            {% endfor %}
          )
    {% endif %}
  AND (
      '{{ _user_attributes['school'] }}' IS NULL
      OR '{{ _user_attributes['school'] }}' = ''
      OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
  )
GROUP BY HEX(p.`id`), LOWER(TRIM(cm.`kind`))
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
