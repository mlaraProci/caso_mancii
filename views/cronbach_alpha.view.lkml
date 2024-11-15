view: cronbach_alpha {
  sql_table_name: MANCII_RESULTS.cronbach_alpha ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: alpha_value {
    type: number
    sql: ${TABLE}.alpha_value ;;
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
  dimension: item_variances {
    type: string
    sql: ${TABLE}.item_variances ;;
  }
  dimension: num_items {
    type: number
    sql: ${TABLE}.num_items ;;
  }
  dimension: total_variance {
    type: number
    sql: ${TABLE}.total_variance ;;
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
