
view: evaluacion_general_de_inteligencias {
  derived_table: {
    sql: SELECT
      c.name AS intelligence_type,
      AVG(cmd.value) AS average_metric_value
      FROM
      construct_metrics cm
      JOIN
      constructs c ON cm.construct_id = c.id
      JOIN
      construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      GROUP BY
      c.name ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: intelligence_type {
    type: string
    sql: ${TABLE}.intelligence_type ;;
  }

  dimension: average_metric_value {
    type: number
    sql: ${TABLE}.average_metric_value ;;
  }

  set: detail {
    fields: [
        intelligence_type,
	average_metric_value
    ]
  }
}
