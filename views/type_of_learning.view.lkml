view: type_of_learning {
  derived_table: {
    sql:    SELECT
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
WHERE LOWER(TRIM(c.name)) LIKE  '%personalidad%'
AND cmd.value > 0
GROUP BY HEX(p.id), p.name, kind, value, value_category, pr.title, cl.id, cl.acronym




    ;;
  }

  # Dimensiones
  dimension: id {
    type: string
    primary_key: yes
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
    description: "Tipo de aprendizaje"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de aprendizaje"
  }

  # Medidas
  measure: max_value {
    type: max
    sql: ${value} ;;
    description: "Valor máximo para cualquier tipo de aprendizaje"
  }

  measure: total_value {
    type: sum
    sql: ${value} ;;
    description: "Suma total de valores asociados al aprendizaje"
  }

  # Set de detalles
  set: detail {
    fields: [id, name, kind, value]
  }
}
