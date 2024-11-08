view: analysis_results {
  sql_table_name: MANCII_RESULTS.analysis_results ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: analysis_type {
    type: string
    sql: ${TABLE}.analysis_type ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: deleted {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_at ;;
  }
  dimension: question_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.question_id ;;
  }
  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, questions.construct_name, questions.id, analysis_parameters.count]
  }
}
