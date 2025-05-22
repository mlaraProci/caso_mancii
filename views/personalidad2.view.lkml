view: personalidad2 {
  derived_table: {
    sql:
      WITH base_query AS (
        SELECT
            construct_metrics.kind,
            construct_metrics_decimal.value,
            participants.id AS participant_id,
            participants.name AS participant_name
        FROM constructs
        JOIN projects ON projects.id = constructs.project_id
        JOIN project_clients ON project_clients.project_id = projects.id
        JOIN clients ON clients.id = project_clients.client_id
        JOIN construct_metrics ON construct_metrics.construct_id = constructs.id
        JOIN participants ON participants.id = construct_metrics.participant_id
        JOIN socio_demographics ON socio_demographics.participant_id = participants.id
        JOIN construct_metrics_decimal ON construct_metrics.id = construct_metrics_decimal.metric_id
        LEFT JOIN sectionals ON socio_demographics.sectional_id
 = sectionals.id
        WHERE
            LOWER(TRIM(constructs.name)) LIKE '%personalidad%'
            AND TRIM(LOWER(clients.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
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
              OR TRIM(LOWER(socio_demographics.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
            )
            AND (
            '{{ _user_attributes['sectional'] }}' IS NULL
            OR '{{ _user_attributes['sectional'] }}' = ''
            OR TRIM(LOWER(sectionals.name)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['sectional'] }}', '%'))
            )
            AND construct_metrics_decimal.value > 0
      )
      SELECT
        participant_id AS id,
        participant_name AS name,
        CASE
            WHEN kind LIKE '%Amabilidad%' THEN 'amabilidad'
            WHEN kind LIKE '%experiencia%' THEN 'apertura_a_la_experiencia'
            WHEN kind LIKE '%Conciencia%' THEN 'conciencia'
            WHEN kind LIKE '%Estabilidad emocional%' THEN 'estabilidad_emocional'
            WHEN kind LIKE '%Extraversion%' THEN 'extraversion'
            ELSE 'otros'
        END AS type,
        AVG(value) AS value
      FROM base_query
      GROUP BY participant_id, participant_name, type
      ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}."id" ;;
    description: "ID único del participante"
    primary_key: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
    description: "Nombre completo del participante"
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
    description: "Tipo de personalidad"
  }

  measure: average_value {
    type: average
    sql: ${TABLE}."value" ;;
    description: "Valor promedio del rasgo de personalidad"
    value_format_name: decimal_2
  }

  measure: count_participants {
    type: count_distinct
    sql: ${TABLE}."id" ;;
    description: "Número total de participantes únicos"
  }

  set: personality_metrics {
    fields: [id, name, type, average_value, count_participants]
  }

  set: personality_types {
    fields: [type, average_value, count_participants]
  }
}
