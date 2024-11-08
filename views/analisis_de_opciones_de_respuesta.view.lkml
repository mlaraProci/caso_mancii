
view: analisis_de_opciones_de_respuesta {
  derived_table: {
    sql: SELECT
      qo.option_text,
      COUNT(*) AS selection_count
      FROM
      answer_integer ai
      JOIN
      answers a ON ai.answer_id = a.id
      JOIN
      question_options qo ON ai.value = qo.option_order AND a.question_id = qo.question_id
      WHERE
      a.question_id = 'ID_DE_LA_PREGUNTA_ESPECÍFICA'
      GROUP BY
      qo.option_text
      ORDER BY
      selection_count DESC ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: option_text {
    type: string
    sql: ${TABLE}.option_text ;;
  }

  dimension: selection_count {
    type: number
    sql: ${TABLE}.selection_count ;;
  }

  set: detail {
    fields: [
        option_text,
	selection_count
    ]
  }
}
