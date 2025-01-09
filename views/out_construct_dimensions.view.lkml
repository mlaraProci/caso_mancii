view: out_construct_dimensions {
  sql_table_name: MANCII_RESULTS.out_construct_dimensions ;;

  dimension: construct {
    type: number
    sql: ${TABLE}.construct ;;
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
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
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
  measure: count {
    type: count
    drill_fields: [name]
  }
}
