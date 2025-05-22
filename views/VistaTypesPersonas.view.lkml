view: VistaTypesPersonas {

  derived_table: {
    sql:

      SELECT
        participants.id AS id,
        participants.name AS name,
        socio_demographics.school AS school,
        socio_demographics.grade AS grade,
        construct_metrics.kind AS kind,
        CASE
          WHEN construct_metrics.kind LIKE '%Amabilidad%' THEN 'amabilidad'
          WHEN construct_metrics.kind LIKE '%experiencia%' THEN 'apertura a la experiencia'
          WHEN construct_metrics.kind LIKE '%Conciencia%' THEN 'conciencia'
          WHEN construct_metrics.kind LIKE '%Estabilidad emocional%' THEN 'estabilidad emocional'
          WHEN construct_metrics.kind LIKE '%Extraversion%' THEN 'extraversion'
          ELSE 'otros'
        END AS type,
        AVG(construct_metrics_decimal.value) AS value,
        CASE
          WHEN AVG(construct_metrics_decimal.value) >= 0.7 THEN 'Alto'
          WHEN AVG(construct_metrics_decimal.value) >= 0.5 THEN 'Medio'
          ELSE 'Bajo'
        END AS development_status,
        CASE
          WHEN AVG(construct_metrics_decimal.value) >= 0.5 THEN 1
          ELSE 0
        END AS is_developed
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
        AND TRIM(LOWER(clients.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))

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
      participants.id,
      participants.name,
      socio_demographics.school,
      socio_demographics.grade,
      construct_metrics.kind,
      type
      ;;

  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
  }

  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Nombre del constructo original de la métrica"
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    description: "Tipo general de personalidad basado en el constructo"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    value_format_name: "decimal_2"
    description: "Valor promedio del constructo"
  }

  dimension: development_status {
    type: string
    sql: ${TABLE}.development_status ;;
    description: "Bajo, Medio o Alto según el valor promedio"
  }

  dimension: is_developed {
    type: number
    sql: ${TABLE}.is_developed ;;
    description: "1 si la inteligencia está desarrollada (Medio o Alto), 0 si no"
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
