view: out_answers {
  sql_table_name: MANCII_RESULTS.out_answers ;;

  dimension: answer {
    type: string
    sql: ${TABLE}.answer ;;
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
  dimension: dimension {
    type: string
    sql: ${TABLE}.dimension ;;
  }
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: out_question {
    type: number
    sql: ${TABLE}.out_question ;;
  }
  dimension: question {
    type: string
    sql: ${TABLE}.question ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: uuid {
    type: string
    sql: ${TABLE}.uuid ;;
  }
  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
  measure: count {
    type: count
  }
}
