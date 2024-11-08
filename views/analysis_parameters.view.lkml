view: analysis_parameters {
  sql_table_name: MANCII_RESULTS.analysis_parameters ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: analysis_result_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.analysis_result_id ;;
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
  dimension: parameter_name {
    type: string
    sql: ${TABLE}.parameter_name ;;
  }
  dimension: parameter_value {
    type: string
    sql: ${TABLE}.parameter_value ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, parameter_name, analysis_results.id]
  }
}
