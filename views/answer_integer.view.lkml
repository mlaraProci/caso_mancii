view: answer_integer {
  sql_table_name: MANCII_RESULTS.answer_integer ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: answer_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.answer_id ;;
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
  dimension: text_value {
    type: string
    sql: ${TABLE}.text_value ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }
  measure: count {
    type: count
    drill_fields: [id, answers.id]
  }
}
