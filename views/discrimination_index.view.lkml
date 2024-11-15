view: discrimination_index {
  sql_table_name: MANCII_RESULTS.discrimination_index ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
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
  dimension: discrimination_value {
    type: number
    sql: ${TABLE}.discrimination_value ;;
  }
  dimension: questions_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.questions_id ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, questions.construct_name, questions.id]
  }
}
