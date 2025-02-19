view: personalidad2{
  derived_table: {
    sql:
      SELECT
         HEX(p.id) AS id,
         p.name AS name,
         cm.kind,
         cmd.value,
         MAX(CASE WHEN cm.kind = 'amabilidad' THEN cmd.value END) AS amabilidad,
         MAX(CASE WHEN cm.kind = 'apertura_a_la_experiencia' THEN cmd.value END) AS apertura_a_la_experiencia,
         MAX(CASE WHEN cm.kind = 'conciencia' THEN cmd.value END) AS conciencia,
         MAX(CASE WHEN cm.kind = 'estabilidad_emocional' THEN cmd.value END) AS estabilidad_emocional,
         MAX(CASE WHEN cm.kind = 'extraversion' THEN cmd.value END) AS extraversion
      FROM constructs c
      JOIN construct_metrics cm ON cm.construct_id = c.id
      JOIN participants p ON p.id = cm.participant_id
      JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      WHERE cmd.value > 0
        AND LOWER(TRIM(c.name)) LIKE '%personalidad%'  -- Filtro ajustado
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
