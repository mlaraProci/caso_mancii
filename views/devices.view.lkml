view: devices {
  sql_table_name: MANCII_RESULTS.devices ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
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
  dimension: device_category {
    type: string
    sql: ${TABLE}.device_category ;;
  }
  dimension: device_model {
    type: string
    sql: ${TABLE}.device_model ;;
  }
  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: interaction_metrics_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.interaction_metrics_id ;;
  }
  dimension: ip {
    type: string
    sql: ${TABLE}.ip ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, interaction_metrics.id, interaction_metrics.segment_name, locations.count, utm_parameters.count]
  }
}
