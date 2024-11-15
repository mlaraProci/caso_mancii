view: utm_parameters {
  sql_table_name: MANCII_RESULTS.utm_parameters ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: ad_group {
    type: string
    sql: ${TABLE}.ad_group ;;
  }
  dimension: ad_position {
    type: string
    sql: ${TABLE}.ad_position ;;
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
  dimension: devices_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.devices_id ;;
  }
  dimension: fbclid {
    type: string
    sql: ${TABLE}.fbclid ;;
  }
  dimension: gclid {
    type: string
    sql: ${TABLE}.gclid ;;
  }
  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }
  dimension: tracking_id {
    type: string
    sql: ${TABLE}.tracking_id ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: utm_campaign {
    type: string
    sql: ${TABLE}.utm_campaign ;;
  }
  dimension: utm_content {
    type: string
    sql: ${TABLE}.utm_content ;;
  }
  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
  }
  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
  }
  dimension: utm_term {
    type: string
    sql: ${TABLE}.utm_term ;;
  }
  measure: count {
    type: count
    drill_fields: [id, devices.id]
  }
}
