view: numerical_stats {
  sql_table_name: MANCII_RESULTS.numerical_stats ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }
  dimension: average {
    type: number
    sql: ${TABLE}.average ;;
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
  dimension: max {
    type: number
    sql: ${TABLE}.max ;;
  }
  dimension: min {
    type: number
    sql: ${TABLE}.min ;;
  }
  dimension: sum {
    type: number
    sql: ${TABLE}.sum ;;
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
