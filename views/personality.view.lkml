view: personality {
  derived_table: {
    sql: WITH base_query AS (
      SELECT
          construct_metrics.kind,
          construct_metrics_decimal.value,
          participants.id AS participant_id, -- ID del participante
          participants.name AS participant_name -- Nombre del participante
      FROM constructs
      JOIN projects ON projects.id = constructs.project_id
      JOIN project_clients ON project_clients.project_id = projects.id
      JOIN clients ON clients.id = project_clients.client_id
      JOIN construct_metrics ON construct_metrics.construct_id = constructs.id
      JOIN participants ON participants.id = construct_metrics.participant_id
      JOIN socio_demographics ON socio_demographics.participant_id = participants.id
      JOIN construct_metrics_decimal ON construct_metrics.id = construct_metrics_decimal.metric_id
      WHERE
          LOWER(TRIM(constructs.name)) LIKE '%personalidad%'
          AND TRIM(LOWER(clients.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
          AND (
            '{{ _user_attributes['city'] }}' IS NULL
            OR '{{ _user_attributes['city'] }}' = ''
            OR TRIM(LOWER(socio_demographics.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
          )
          OR (
            '{{ _user_attributes['city'] }}' IS NULL
            OR '{{ _user_attributes['city'] }}' = ''
            OR TRIM(LOWER(socio_demographics.country)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
          )
          AND (
            '{{ _user_attributes['school'] }}' IS NULL
            OR '{{ _user_attributes['school'] }}' = ''
            OR TRIM(LOWER(socio_demographics.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
          )
          AND construct_metrics_decimal.value > 0
    )
    SELECT

      participant_id AS id, -- Incluye el ID del participante
      participant_name AS name, -- Incluye el nombre del participante
      CASE
          WHEN kind LIKE '%Amabilidad%' THEN 'amabilidad'
          WHEN kind LIKE '%experiencia%' THEN 'apertura_a_la_experiencia'
          WHEN kind LIKE '%Conciencia%' THEN 'conciencia'
          WHEN kind LIKE '%Estabilidad emocional%' THEN 'estabilidad_emocional'
          WHEN kind LIKE '%Extraversion%' THEN 'extraversion'
          ELSE 'otros'
      END AS type,
      AVG(value) AS value -- Promedio del valor
    FROM base_query
    GROUP BY participant_id, participant_name, type;
    ;;


  }

  # Dimensiones y medidas alineadas con la consulta SQL
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

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    description: "Tipo de personalidad"
  }

  measure: value {
    type: average
    sql: ${TABLE}.value ;;
    description: "Promedio del valor para el tipo de personalidad"
  }

  set: detail {
    fields: [
      id,
      name,
      type,
      value
    ]
  }
}
