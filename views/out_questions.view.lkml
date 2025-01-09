view: out_questions {
  sql_table_name: MANCII_RESULTS.out_questions ;;

  dimension: construct {
    type: string
    sql: ${TABLE}.construct ;;
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
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: intelligence {
    type: number
    sql: ${TABLE}.intelligence ;;
  }
  dimension: question {
    type: string
    sql: ${TABLE}.question ;;
  }
  dimension: test {
    type: number
    sql: ${TABLE}.test ;;
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
