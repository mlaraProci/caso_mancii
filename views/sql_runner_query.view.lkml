
view: sql_runner_query {
  derived_table: {
    sql: SELECT
        p.identification AS participant_identification,
        c.name AS intelligence_type,
        MAX(cmd.value) AS max_metric_value
      FROM
        participants p
      JOIN
        construct_metrics cm ON p.id = cm.participant_id
      JOIN
        constructs c ON cm.construct_id = c.id
      JOIN
        construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      GROUP BY
        p.identification,
        c.name
      ORDER BY
        max_metric_value DESC ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: participant_identification {
    type: string
    sql: ${TABLE}.participant_identification ;;
  }

  dimension: intelligence_type {
    type: string
    sql: ${TABLE}.intelligence_type ;;
  }

  dimension: max_metric_value {
    type: number
    sql: ${TABLE}.max_metric_value ;;
  }

  set: detail {
    fields: [
        participant_identification,
	intelligence_type,
	max_metric_value
    ]
  }
}
