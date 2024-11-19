view: consulta_1 {
  derived_table: {
    sql:
      SELECT id, HEX(id) AS identify
      FROM participants ;;
  }

  dimension: id_as_string {
    type: string
    sql: CAST(${TABLE}.id AS CHAR) ;;
    description: "ID convertido"
  }

  dimension: identify {
    type: string
    sql: ${TABLE}.identify ;;
  }
}
