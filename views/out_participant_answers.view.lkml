view: out_participant_answers {
  sql_table_name: MANCII_RESULTS.out_participant_answers ;;

  dimension: answer {
    type: number
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
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: participant_email {
    type: string
    sql: ${TABLE}.participant_email ;;
  }
  dimension: participant_id {
    type: number
    sql: ${TABLE}.participant_id ;;
  }
  dimension: question {
    type: number
    sql: ${TABLE}.question ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
  measure: count {
    type: count
  }
}
