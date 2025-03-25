view: areas_de_conocimientov2 {
  derived_table: {
    sql:
      SELECT
        HEX(p.id) AS id,
        p.name AS name,
        LOWER(TRIM(cm.kind)) AS kind,
        cmd.value AS value,
        MAX(CASE WHEN cm.kind like '%agronomia%' THEN cmd.value END) AS agronomia,
        MAX(CASE WHEN cm.kind like '%bellas_artes%' THEN cmd.value END) AS bellas_artes,
        MAX(CASE WHEN cm.kind like '%economia%' THEN cmd.value END) AS economia,
        MAX(CASE WHEN cm.kind like '%educacion%' THEN cmd.value END) AS educacion,
        MAX(CASE WHEN cm.kind like '%ingenieria%' THEN cmd.value END) AS ingenieria,
        MAX(CASE WHEN cm.kind like '%matematicas%' THEN cmd.value END) AS matematicas,
        MAX(CASE WHEN cm.kind like '%salud%' THEN cmd.value END) AS salud,
        MAX(CASE WHEN cm.kind like '%sociales%' THEN cmd.value END) AS sociales
      FROM constructs c
      JOIN construct_metrics cm ON cm.construct_id = c.id
      JOIN participants p ON p.id = cm.participant_id
      JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      WHERE cmd.value > 0
      GROUP BY HEX(p.id), p.name, cm.kind, cmd.value
    ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Área de conocimiento como dimensión"
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al área de conocimiento como dimensión"
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  measure: agronomia {
    type: sum
    sql: CASE WHEN ${kind} = 'agronomia' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento agronomía"
  }

  measure: bellas_artes {
    type: sum
    sql: CASE WHEN ${kind} = 'bellas_artes' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento bellas artes"
  }

  measure: economia {
    type: sum
    sql: CASE WHEN ${kind} = 'economia' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento economía"
  }

  measure: educacion {
    type: sum
    sql: CASE WHEN ${kind} = 'educacion' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento educación"
  }

  measure: ingenieria {
    type: sum
    sql: CASE WHEN ${kind} = 'ingenieria' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento ingeniería"
  }

  measure: matematicas {
    type: sum
    sql: CASE WHEN ${kind} = 'matematicas' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento matemáticas"
  }

  measure: salud {
    type: sum
    sql: CASE WHEN ${kind} = 'salud' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento salud"
  }

  measure: sociales {
    type: sum
    sql: CASE WHEN ${kind} = 'sociales' THEN ${value} ELSE 0 END ;;
    description: "Valor del área de conocimiento sociales"
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
      agronomia,
      bellas_artes,
      economia,
      educacion,
      ingenieria,
      matematicas,
      salud,
      sociales
    ]
  }
}
