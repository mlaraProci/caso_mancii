view: numerical_question_options {
  sql_table_name: MANCII_RESULTS.numerical_question_options ;;

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
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: numerical_stats_id {
    type: string
    sql: ${TABLE}.numerical_stats_id ;;
  }
  dimension: question_option_id {
    type: string
    sql: ${TABLE}.question_option_id ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
  }
}
