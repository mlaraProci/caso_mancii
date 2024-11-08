
view: evaluacion_de_inteligencias_multiples {
  derived_table: {
    sql: SELECT
          participants.identification AS participant_identification,
          constructs.name AS intelligence_type,
          construct_metrics_decimal.value AS metric_value
      FROM
          participants
      JOIN
          construct_metrics ON participants.id = construct_metrics.participant_id
      JOIN
          constructs ON construct_metrics.construct_id = constructs.id
      JOIN
          construct_metrics_decimal ON construct_metrics.id = construct_metrics_decimal.metric_id; ;;
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

  dimension: metric_value {
    type: number
    sql: ${TABLE}.metric_value ;;
  }

  set: detail {
    fields: [
      participant_identification,
      intelligence_type,
      metric_value
    ]
  }
}
