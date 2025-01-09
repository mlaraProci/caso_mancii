view: tokens {
  sql_table_name: MANCII_RESULTS.tokens ;;

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
  dimension: token {
    type: string
    sql: ${TABLE}.token ;;
  }
  dimension: token_type {
    type: string
    sql: ${TABLE}.token_type ;;
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
