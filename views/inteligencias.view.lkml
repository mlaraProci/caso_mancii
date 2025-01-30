view: inteligencias {
  derived_table: {
    sql:SELECT
       HEX(p.id) AS id,  -- Convertimos el ID a formato hexadecimal
       p.name AS name,  -- Incluimos el campo name de la tabla participants
       LOWER(TRIM(cm.kind)) AS kind,  -- Normalizamos el valor de kind
       cmd.value AS value,  -- Incluimos value de construct_metrics_decimal
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
LEFT JOIN student_data sd ON sd.participant_id = p.id  -- Asumiendo que la tabla `student_data` contiene la información de ciudad y escuela
WHERE LOWER(TRIM(c.name)) LIKE '%inteligencias%'  -- Filtramos por el nombre del constructo
  AND cmd.value > 0  -- Filtramos valores mayores a 0
  AND LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))  -- Filtro dinámico para el acrónimo del cliente
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
GROUP BY HEX(p.id), p.name, cm.kind, cmd.value;
;

 ;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensión para `kind`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de inteligencia como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de inteligencia como dimensión"
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Medidas para cada tipo de inteligencia basadas en `kind`
  measure: Inteligencia_corporalkinestesica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_corporalkinestesica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia corporal-kinestésica"
  }

  measure: Inteligencia_espacial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_espacial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia espacial"
  }

  measure: Inteligencia_existencial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_existencial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia existencial"
  }

  measure: Inteligencia_interpersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_interpersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia interpersonal"
  }

  measure: Inteligencia_intrapersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_intrapersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia intrapersonal"
  }

  measure: Inteligencia_linguistica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_linguistica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lingüística"
  }

  measure: Inteligencia_logicomatematica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_logicomatematica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lógico-matemática"
  }

  measure: Inteligencia_musical {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_musical' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia musical"
  }

  measure: Inteligencia_naturalista {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia_naturalista' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia naturalista"
  }
  measure: count {
    type: count
    drill_fields: [id, kind, value]
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      Inteligencia_corporalkinestesica,
      Inteligencia_espacial,
      Inteligencia_existencial,
      Inteligencia_interpersonal,
      Inteligencia_intrapersonal,
      Inteligencia_linguistica,
      Inteligencia_logicomatematica,
      Inteligencia_musical,
      Inteligencia_naturalista
    ]
  }
}
