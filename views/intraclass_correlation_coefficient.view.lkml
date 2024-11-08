view: intraclass_correlation_coefficient {
  sql_table_name: MANCII_RESULTS.intraclass_correlation_coefficient ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: a_parameter {
    type: number
    sql: ${TABLE}.a_parameter ;;
  }
  dimension: b_parameter {
    type: number
    sql: ${TABLE}.b_parameter ;;
  }
  dimension: c_parameter {
    type: number
    sql: ${TABLE}.c_parameter ;;
  }
  dimension: construct_id {
    type: string
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
  dimension: theta_values {
    type: string
    sql: ${TABLE}.theta_values ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, constructs.id, constructs.name]
  }
}
