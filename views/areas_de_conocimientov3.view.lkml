view: areas_de_conocimientov3 {

  derived_table: {
    sql:
      SELECT
        HEX(p.id) AS id,
        p.name AS name,
        SUM(CASE WHEN cm.kind = 'agronomia' THEN cmd.value ELSE 0 END) AS agronomia,
        SUM(CASE WHEN cm.kind = 'bellas_artes' THEN cmd.value ELSE 0 END) AS bellas_artes,
        SUM(CASE WHEN cm.kind = 'economia' THEN cmd.value ELSE 0 END) AS economia,
        SUM(CASE WHEN cm.kind = 'educacion' THEN cmd.value ELSE 0 END) AS educacion,
        SUM(CASE WHEN cm.kind = 'ingenieria' THEN cmd.value ELSE 0 END) AS ingenieria,
        SUM(CASE WHEN cm.kind = 'matematicas' THEN cmd.value ELSE 0 END) AS matematicas,
        SUM(CASE WHEN cm.kind = 'salud' THEN cmd.value ELSE 0 END) AS salud,
        SUM(CASE WHEN cm.kind = 'sociales' THEN cmd.value ELSE 0 END) AS sociales
      FROM constructs c
      JOIN projects pr ON pr.id = c.project_id
      JOIN project_clients pc ON pc.project_id = pr.id
      JOIN clients cl ON cl.id = pc.client_id
      JOIN construct_metrics cm ON cm.construct_id = c.id
      JOIN participants p ON p.id = cm.participant_id
      JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      LEFT JOIN socio_demographics sd ON sd.participant_id = p.id
      WHERE cmd.value > 0
        AND LOWER(TRIM(c.name)) LIKE '%conocimiento%'  -- Filtro ajustado
        AND (LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["client_acronym"] }}', '%')))
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
      GROUP BY HEX(p.id), p.name
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
    description: "Nombre"
  }

  measure: agronomia {
    type: sum
    sql: ${TABLE}.agronomia ;;
    description: "Valor del área de conocimiento agronomía"
  }

  measure: bellas_artes {
    type: sum
    sql: ${TABLE}.bellas_artes ;;
    description: "Valor del área de conocimiento bellas artes"
  }

  measure: economia {
    type: sum
    sql: ${TABLE}.economia ;;
    description: "Valor del área de conocimiento economía"
  }

  measure: educacion {
    type: sum
    sql: ${TABLE}.educacion ;;
    description: "Valor del área de conocimiento educación"
  }

  measure: ingenieria {
    type: sum
    sql: ${TABLE}.ingenieria ;;
    description: "Valor del área de conocimiento ingeniería"
  }

  measure: matematicas {
    type: sum
    sql: ${TABLE}.matematicas ;;
    description: "Valor del área de conocimiento matemáticas"
  }

  measure: salud {
    type: sum
    sql: ${TABLE}.salud ;;
    description: "Valor del área de conocimiento salud"
  }

  measure: sociales {
    type: sum
    sql: ${TABLE}.sociales ;;
    description: "Valor del área de conocimiento sociales"
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }

  set: detail {
    fields: [
      id,
      name,
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
