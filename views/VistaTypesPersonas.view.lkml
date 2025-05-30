view: VistaTypesPersonas {

  derived_table: {
    sql:
      WITH personas_data AS (
        SELECT
          HEX(p.id) AS id,
          p.name AS name,
          LOWER(TRIM(cm.kind)) AS kind,
          cmd.value AS value,
          CASE
              WHEN cmd.value = 0 THEN 'No desarrollada'
              WHEN cmd.value = 5 THEN 'Desarrollada (Medio)'
              ELSE 'Desarrollada (Alto)'
          END AS development_status,
          CASE
              WHEN cmd.value = 0 THEN 0
              ELSE 1
          END AS is_developed,
          pr.title AS project_title,
          cl.id AS client_id,
          cl.acronym AS client_acronym,
          sd.school AS school,
          sd.grade AS grade,
          sd.city AS city,
          sd.country AS country,
          sd.preferred_careers AS preferred_careers
        FROM `constructs` c
        JOIN `projects` pr ON pr.id = c.project_id
        JOIN `project_clients` pc ON pr.id = pc.project_id
        JOIN `clients` cl ON pc.client_id = cl.id
        JOIN `construct_metrics` cm ON cm.construct_id = c.id
        JOIN `participants` p ON p.id = cm.participant_id
        JOIN `construct_metrics_decimal` cmd ON cm.id = cmd.metric_id
        LEFT JOIN `socio_demographics` sd ON p.id = sd.participant_id
        WHERE LOWER(TRIM(c.name)) LIKE '%tipos de inteligencias%'
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
      ),

      career_info AS (
      SELECT
      participant_id,
      GROUP_CONCAT(
      DISTINCT
      TRIM(
      REGEXP_REPLACE(
      REGEXP_REPLACE(
      REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n),
      '[\\[\\]"]', ''
      ),
      '[()\\.]', ''
      )
      )
      SEPARATOR ', '
      ) AS careers_list,
      COUNT(
      DISTINCT
      TRIM(
      REGEXP_REPLACE(
      REGEXP_REPLACE(
      REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n),
      '[\\[\\]"]', ''
      ),
      '[()\\.]', ''
      )
      )
      ) AS career_count
      FROM socio_demographics
      CROSS JOIN (
      SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
      ) numbers
      WHERE preferred_careers NOT IN ('Not Applicable', 'Not Answered', 'No sé', 'no se', 'no se que estudiar todavía', 'nose aun', 'aun no se')
      AND REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n) IS NOT NULL
      GROUP BY participant_id
      )

      SELECT
      pd.*,
      ci.careers_list,
      ci.career_count
      FROM personas_data pd
      LEFT JOIN career_info ci ON pd.id = HEX(ci.participant_id) ;;
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
    description: "Tipo de inteligencia"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor original asociado al tipo de inteligencia"
  }

  dimension: development_status {
    type: string
    sql: ${TABLE}.development_status ;;
    description: "Estado de desarrollo de la inteligencia: No desarrollada, Desarrollada (Medio) o Desarrollada (Alto)"
    html:
      CASE
        WHEN {{ value }} = 'No desarrollada' THEN
          '<span style="color: #ff4d4d; font-weight: bold;">{{value}}</span>'
        WHEN {{ value }} = 'Desarrollada (Medio)' THEN
          '<span style="color: #ffcc00; font-weight: bold;">{{value}}</span>'
        ELSE
          '<span style="color: #4dff4d; font-weight: bold;">{{value}}</span>'
      END ;;
  }

  dimension: is_developed {
    type: number
    sql: ${TABLE}.is_developed ;;
    description: "1 si la inteligencia está desarrollada (Medio o Alto), 0 si no"
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


  measure: developed_count {
    type: sum
    sql: ${is_developed} ;;
    description: "Número de inteligencias desarrolladas por persona"
  }

  measure: total_intelligences {
    type: count
    description: "Total de inteligencias evaluadas por persona"
  }

  measure: development_percentage {
    type: number
    sql: 100.0 * ${developed_count} / NULLIF(${total_intelligences}, 0) ;;
    description: "Porcentaje de inteligencias desarrolladas por persona"
    value_format_name: percent_1
  }

  set: intelligence_detail {
    fields: [
      id,
      name,
      kind,
      value,
      development_status,
      is_developed,
      school,
      grade,
      city,
      country,
    ]
  }

  set: person_summary {
    fields: [
      id,
      name,
      developed_count,
      total_intelligences,
      development_percentage,
      school,
      grade,
      city,

    ]
  }
  }
