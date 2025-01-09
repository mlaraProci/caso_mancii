view: project_clients {
  sql_table_name: MANCII_RESULTS.project_clients ;;

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: project_id {
    type: string
    sql: ${TABLE}.project_id ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count
  }
}
