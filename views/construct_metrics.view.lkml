view: construct_metrics {
  sql_table_name: MANCII_RESULTS.construct_metrics ;;
  drill_fields: [id]

  dimension: id {
    #primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: construct_id {
    type: string
    primary_key: yes
    # hidden: yes
    sql: ${TABLE}.construct_id ;;
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
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }
  dimension: participant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.participant_id ;;
  }
  dimension_group: response {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.response_time ;;
  }
  dimension: response_type {
    type: string
    sql: ${TABLE}.response_type ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  construct_id,
  participant_id,
  ]
  }

}
