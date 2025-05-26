view: Types {
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
        sd.city AS city,
        sd.country AS country,
        sd.school AS school,
        sd.grade AS grade
      FROM `constructs` c
      JOIN `projects` pr ON pr.id = c.project_id
      JOIN `project_clients` pc ON pr.id = pc.project_id
      JOIN `clients` cl ON pc.client_id = cl.id
      JOIN `construct_metrics` cm ON cm.construct_id = c.id
      JOIN `participants` p ON p.id = cm.participant_id
      JOIN `construct_metrics_decimal` cmd ON cm.id = cmd.metric_id
      LEFT JOIN `socio_demographics` sd ON p.id = sd.participant_id
      WHERE LOWER(TRIM(c.name)) LIKE '%tipos de inteligencias%'
      AND (
        '{{ _user_attributes['client_acronym'] }}' IS NULL
        OR '{{ _user_attributes['client_acronym'] }}' = ''
        OR TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
      )
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
      GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;;
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

  dimension: project_title {
    type: string
    sql: ${TABLE}.project_title ;;
    description: "Título del proyecto"
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
    description: "ID del cliente"
  }

  dimension: client_acronym {
    type: string
    sql: ${TABLE}.client_acronym ;;
    description: "Acrónimo del cliente"
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    description: "Ciudad del participante"
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
    description: "País del participante"
  }

  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
    description: "Colegio del participante"
  }

  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
    description: "Grado escolar del participante"
  }

  measure: count {
    type: count
    description: "Total de registros"
  }

  measure: count_low {
    type: count
    filters: [value_category: "Bajo"]
    description: "Conteo de valores clasificados como Bajo"
  }

  measure: count_medium {
    type: count
    filters: [value_category: "Medio"]
    description: "Conteo de valores clasificados como Medio"
  }

  measure: count_high {
    type: count
    filters: [value_category: "Alto"]
    description: "Conteo de valores clasificados como Alto"
  }

  measure: avg_value {
    type: average
    sql: ${value} ;;
    description: "Valor promedio de inteligencia"
  }

  measure: total_value {
    type: sum
    sql: ${value} ;;
    description: "Suma total de los valores de inteligencia"
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  set: detail {
    fields: [
      id,
      name,
      kind,
      value,
      value_category,
      city,
      country,
      school,
      grade,
      count_low,
      count_medium,
      count_high,
      total_value
    ]
  }
}
