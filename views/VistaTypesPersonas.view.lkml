view: VistaTypesPersonas {
  derived_table: {
    sql:
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
      cl.acronym AS client_acronym
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
      AND (
        '{{ _user_attributes['city'] }}' IS NULL
        OR '{{ _user_attributes['city'] }}' = ''
        OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
        OR TRIM(LOWER(sd.country)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
      )
      AND (
        '{{ _user_attributes['school'] }}' IS NULL
        OR '{{ _user_attributes['school'] }}' = ''
        OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
      )
      AND cmd.value > 0
    GROUP BY HEX(p.id), p.name, kind, value, development_status, is_developed, pr.title, cl.id, cl.acronym;;
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
      is_developed
    ]
  }

  set: person_summary {
    fields: [
      id,
      name,
      developed_count,
      total_intelligences,
      development_percentage
    ]
  }
}
