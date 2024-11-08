view: answer_boolean {
  sql_table_name: MANCII_RESULTS.answer_boolean ;;
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
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: value {
    type: yesno
    sql: ${TABLE}.value ;;
  }
  measure: count {
    type: count
    drill_fields: [id, answers.id]
  }
}
