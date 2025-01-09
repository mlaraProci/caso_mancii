view: tipos_de_aprendizaje {
  derived_table: {
    sql: SELECT
    HEX(p.id) AS id, -- Convertimos el ID de los participantes a formato hexadecimal
    p.name AS name, -- Incluimos el nombre del participante
    LOWER(TRIM(cm.kind)) AS kind, -- Normalizamos el campo kind y lo incluimos
    cmd.value AS value -- Incluimos el valor de construct_metrics_decimal
FROM constructs c
JOIN projects pr ON pr.id = c.project_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN participants p ON p.id = cm.participant_id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
WHERE LOWER(TRIM(pr.title)) LIKE 'previous-test' -- Filtramos el título del proyecto
  AND LOWER(TRIM(c.name)) LIKE '%tipos de aprendizaje%' -- Filtramos el nombre del constructo
  AND cmd.value > 0 -- Filtramos valores mayores a 0
GROUP BY HEX(p.id), p.name, kind, value; -- Agrupamos por los campos seleccionados

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
    description: "Tipo de aprendizaje como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de aprendizaje como dimensión"
  }
# Dimensión para `name`
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Valor asociado al tipo de aprendizaje como dimensión"
  }

  # Medidas para cada tipo de aprendizaje basadas en `kind` usando MAX
  measure: auditiva {
    type: max
    sql: CASE WHEN ${kind} = 'auditiva' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de aprendizaje auditivo"
  }

  measure: kinestesica {
    type: max
    sql: CASE WHEN ${kind} = 'kinestesica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de aprendizaje kinestésico"
  }

  measure: lectura_escritura {
    type: max
    sql: CASE WHEN ${kind} = 'lectura/escritura' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de aprendizaje lectura/escritura"
  }

  measure: visual {
    type: max
    sql: CASE WHEN ${kind} = 'visual' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de aprendizaje visual"
  }

  measure: social {
    type: max
    sql: CASE WHEN ${kind} = 'social' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de aprendizaje social"
  }

  set: detail {
    fields: [
      id,
      kind,
      name,
      value,
      auditiva,
      kinestesica,
      lectura_escritura,
      visual,
      social
    ]
  }
}
