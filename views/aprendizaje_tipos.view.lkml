view: aprendizaje_tipos {
  derived_table: {
    sql:
      SELECT
        HEX(p.id) AS id,
        p.name AS name,
        LOWER(TRIM(cm.kind)) AS kind,
        cmd.value AS value,
        CASE
            WHEN cmd.value = 0 THEN 'Bajo'
            WHEN cmd.value = 5 THEN 'Medio'
            ELSE 'Alto'
        END AS value_category,
        pr.title AS project_title,
        cl.id AS client_id,
        cl.acronym AS client_acronym,
        sd.school AS school,
        sd.grade AS grade
      FROM `clients` cl
      JOIN `project_clients` pc ON cl.id = pc.client_id
      JOIN `projects` pr ON pc.project_id = pr.id
      JOIN `constructs` c ON pr.id = c.project_id
      JOIN `construct_metrics` cm ON cm.construct_id = c.id
      JOIN `participants` p ON p.id = cm.participant_id
      JOIN `construct_metrics_decimal` cmd ON cm.id = cmd.metric_id
      LEFT JOIN `socio_demographics` sd ON p.id = sd.participant_id
      WHERE LOWER(TRIM(c.name)) LIKE '%personalidad%'
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
        AND cmd.value > 0
      GROUP BY HEX(p.id), p.name, kind, value, value_category, pr.title, cl.id, cl.acronym, sd.school, sd.grade
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

  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
    description: "Colegio del participante"
  }

  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
    description: "Grado del participante"
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
      school,
      grade,
      count_low,
      count_medium,
      count_high,
      total_value
    ]
  }
}
