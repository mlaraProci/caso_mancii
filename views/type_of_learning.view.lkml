view: type_of_learning {
  derived_table: {
    sql: SELECT
      HEX(p.id) AS id, -- ID en formato hexadecimal
      p.name AS name, -- Nombre del participante
      LOWER(TRIM(cm.kind)) AS kind, -- Tipo de aprendizaje normalizado
      cmd.value AS value -- Valor asociado al aprendizaje
FROM constructs c
JOIN projects pr ON pr.id = c.project_id
JOIN project_clients pc ON pc.project_id = pr.id
JOIN clients cl ON cl.id = pc.client_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN participants p ON p.id = cm.participant_id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
LEFT JOIN socio_demographics sd ON sd.participant_id = p.id -- Cambio de student_data a socio_demographics
WHERE LOWER(TRIM(c.name)) LIKE '%estilos de aprendizaje%'
  AND cmd.value > 0
  AND LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["client_acronym"] }}', '%'))
  AND (
    '{{ _user_attributes["city"] }}' IS NULL
    OR '{{ _user_attributes["city"] }}' = ''
    OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["city"] }}', '%'))
  )
  AND (
    '{{ _user_attributes["school"] }}' IS NULL
    OR '{{ _user_attributes["school"] }}' = ''
    OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["school"] }}', '%'))
  )
GROUP BY HEX(p.id), p.name, cm.kind, cmd.value;

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
