view: numerical_answer_integer {
  sql_table_name: MANCII_RESULTS.numerical_answer_integer ;;

  dimension: answer_integer_id {
    type: string
    sql: ${TABLE}.answer_integer_id ;;
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
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: numerical_stats_id {
    type: string
    sql: ${TABLE}.numerical_stats_id ;;
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
