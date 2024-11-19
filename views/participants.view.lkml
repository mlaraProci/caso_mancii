view: participants {
  sql_table_name: MANCII_RESULTS.participants ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: auth_id {
    type: string
    sql: ${TABLE}.auth_id ;;
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
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: identification {
    type: string
    sql: ${TABLE}.identification ;;
  }
  dimension: identification_type {
    type: string
    sql: ${TABLE}.identification_type ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  name,
  answers.count,
  attendent.count,
  construct_metrics.count,
  interaction_metrics.count,
  socio_demographics.count
  ]
  }

}
