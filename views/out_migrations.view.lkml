view: out_migrations {
  sql_table_name: MANCII_RESULTS.out_migrations ;;

  dimension: batch {
    type: number
    sql: ${TABLE}.batch ;;
  }
  dimension: class {
    type: string
    sql: ${TABLE}.class ;;
  }
  dimension: group {
    type: string
    sql: ${TABLE}.`group` ;;
  }
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: namespace {
    type: string
    sql: ${TABLE}.namespace ;;
  }
  dimension: time {
    type: number
    sql: ${TABLE}.time ;;
  }
  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
  }
  measure: count {
    type: count
  }
}
