view: personalidades {
  derived_table: {
    sql:SELECT
       HEX(p.id) AS id,  -- Convertimos el ID a hexadecimal y lo nombramos como `id`
       p.name AS name,  -- Agregamos el nombre del participante
       cm.kind,
       cmd.value,
       MAX(CASE WHEN cm.kind = 'amabilidad' THEN cmd.value END) AS amabilidad,
       MAX(CASE WHEN cm.kind = 'apertura_a_la_experiencia' THEN cmd.value END) AS apertura_a_la_experiencia,
       MAX(CASE WHEN cm.kind = 'conciencia' THEN cmd.value END) AS conciencia,
       MAX(CASE WHEN cm.kind = 'estabilidad_emocional' THEN cmd.value END) AS estabilidad_emocional,
       MAX(CASE WHEN cm.kind = 'extraversion' THEN cmd.value END) AS extraversion
FROM constructs c
JOIN projects pr ON pr.id = c.project_id
JOIN project_clients pc ON pc.project_id = pr.id
JOIN clients cl ON cl.id = pc.client_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN participants p ON p.id = cm.participant_id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
LEFT JOIN socio_demographics sd ON sd.participant_id = p.id  -- Cambio de `student_data` a `socio_demographics`
WHERE TRIM(LOWER(c.name)) LIKE '%personalidades%'  -- Filtramos por el nombre del constructo
  AND cmd.value > 0  -- Filtramos valores mayores a 0
  AND LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["client_acronym"] }}', '%'))  -- Filtro dinámico para el acrónimo del cliente
  AND (
    '{{ _user_attributes["city"] }}' IS NULL
    OR '{{ _user_attributes["city"] }}' = ''
    OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["city"] }}', '%'))
  )
  OR (
    '{{ _user_attributes['city'] }}' IS NULL
    OR '{{ _user_attributes['city'] }}' = ''
    OR TRIM(LOWER(sd.country)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
  )
  AND (
    '{{ _user_attributes["school"] }}' IS NULL
    OR '{{ _user_attributes["school"] }}' = ''
    OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["school"] }}', '%'))
  )
GROUP BY HEX(p.id), p.name, cm.kind, cmd.value;


 ;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensiones adicionales para `kind` y `value`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de personalidad"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor de la personalidad"
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Medidas para cada tipo de personalidad
  measure: amabilidad {
    type: max
    sql: ${TABLE}.amabilidad ;;
    description: "Valor máximo de amabilidad"
  }

  measure: apertura_a_la_experiencia {
    type: max
    sql: ${TABLE}.apertura_a_la_experiencia ;;
    description: "Valor máximo de apertura a la experiencia"
  }

  measure: conciencia {
    type: max
    sql: ${TABLE}.conciencia ;;
    description: "Valor máximo de conciencia"
  }

  measure: estabilidad_emocional {
    type: max
    sql: ${TABLE}.estabilidad_emocional ;;
    description: "Valor máximo de estabilidad emocional"
  }

  measure: extraversion {
    type: max
    sql: ${TABLE}.extraversion ;;
    description: "Valor máximo de extraversión"
  }

  measure: count {
    type: count
    drill_fields: [kind]
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      amabilidad,
      apertura_a_la_experiencia,
      conciencia,
      estabilidad_emocional,
      extraversion
    ]
  }
}
