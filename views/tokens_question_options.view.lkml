view: tokens_question_options {
  sql_table_name: MANCII_RESULTS.tokens_question_options ;;

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
  dimension: frequency {
    type: number
    sql: ${TABLE}.frequency ;;
  }
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: question_id {
    type: string
    sql: ${TABLE}.question_id ;;
  }
  dimension: token_id {
    type: string
    sql: ${TABLE}.token_id ;;
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
