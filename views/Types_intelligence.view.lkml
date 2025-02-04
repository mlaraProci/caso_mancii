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
    cl.acronym AS client_acronym
FROM `constructs` c
JOIN `projects` pr ON pr.id = c.project_id
JOIN `project_clients` pc ON pr.id = pc.project_id  -- Relación entre projects y clients
JOIN `clients` cl ON pc.client_id = cl.id           -- Relación final con clients
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
  )
  AND (
    '{{ _user_attributes['school'] }}' IS NULL
    OR '{{ _user_attributes['school'] }}' = ''
    OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
  )
  AND cmd.value > 0
GROUP BY HEX(p.id), p.name, kind, value, value_category, pr.title, cl.id, cl.acronym






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
    type: sum
    sql: ${value} ;;
    description: "Suma total de los valores de inteligencia"
  }

  set: detail {
    fields: [
      id,
      name,
      kind,
      value,
      value_category,
      count_low,
      count_medium,
      count_high,
      total_value
    ]
  }
  }
