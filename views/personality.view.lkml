view: personality {
  derived_table: {
    sql:
      SELECT
        HEX(participants.id) AS id,
        participants.name AS name,
        socio_demographics.school AS school,
        socio_demographics.grade AS grade,
        CASE
          WHEN construct_metrics.kind LIKE '%Amabilidad%' THEN 'amabilidad'
          WHEN construct_metrics.kind LIKE '%experiencia%' THEN 'apertura a la experiencia'
          WHEN construct_metrics.kind LIKE '%Conciencia%' THEN 'conciencia'
          WHEN construct_metrics.kind LIKE '%Estabilidad emocional%' THEN 'estabilidad emocional'
          WHEN construct_metrics.kind LIKE '%Extraversion%' THEN 'extraversion'
          ELSE 'otros'
        END AS type,
        AVG(construct_metrics_decimal.value) AS value,
        COUNT(*) AS metric_count
      FROM constructs
      JOIN projects ON projects.id = constructs.project_id
      JOIN project_clients ON project_clients.project_id = projects.id
      JOIN clients ON clients.id = project_clients.client_id
      JOIN construct_metrics ON construct_metrics.construct_id = constructs.id
      JOIN participants ON participants.id = construct_metrics.participant_id
      JOIN socio_demographics ON socio_demographics.participant_id = participants.id
      LEFT JOIN sectionals ON socio_demographics.sectional_id = sectionals.id
      JOIN construct_metrics_decimal ON construct_metrics.id = construct_metrics_decimal.metric_id
      WHERE
        LOWER(TRIM(constructs.name)) LIKE '%personalidad%'
        AND (
          '{{ _user_attributes['client_acronym'] }}' IS NULL
          OR '{{ _user_attributes['client_acronym'] }}' = ''
          OR TRIM(LOWER(clients.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
        )
        {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
          {% assign cities = _user_attributes['city'] | split: ',' %}
          AND (
            {% for c in cities %}
              TRIM(LOWER(socio_demographics.city)) LIKE LOWER(CONCAT('%', '{{ c | strip | escape }}', '%'))
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
      GROUP BY
        1, 2, 3, 4, 5
    ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
    hidden: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre del participante"
  }

  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
    description: "Nombre del colegio"
  }

  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
    description: "Grado escolar"
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    description: "Tipo de personalidad"
  }

  dimension: metric_count {
    type: number
    sql: ${TABLE}.metric_count ;;
    description: "Número de métricas que componen el promedio"
    hidden: yes
  }

  measure: value {
    type: average
    sql: ${TABLE}.value ;;
    value_format_name: "decimal_2"
    description: "Promedio del valor para el tipo de personalidad"
  }

  measure: count {
    type: count
    description: "Total de participantes"
  }

  measure: count_metrics {
    type: sum
    sql: ${metric_count} ;;
    description: "Total de métricas evaluadas"
  }

  set: detail {
    fields: [
      id,
      name,
      type,
      value,
      school,
      grade,
      metric_count
    ]
  }
}
