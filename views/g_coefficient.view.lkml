view: g_coefficient {
  sql_table_name: MANCII_RESULTS.g_coefficient ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
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
  dimension: facet_variance {
    type: string
    sql: ${TABLE}.facet_variance ;;
  }
  dimension: g_coefficient_value {
    type: number
    sql: ${TABLE}.g_coefficient_value ;;
  }
  dimension: person_variance {
    type: number
    sql: ${TABLE}.person_variance ;;
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