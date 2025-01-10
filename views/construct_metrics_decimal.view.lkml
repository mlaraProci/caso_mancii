view: construct_metrics_decimal {
  derived_table: {
    sql: SELECT
      cm.construct_id AS construct_id,
      cm.participant_id AS participant_id,
      cm.kind AS kind,
      cmd.metric_id AS metric_id,
      cmd.value AS value
    FROM
      MANCII_RESULTS.construct_metrics AS cm
    JOIN
      MANCII_RESULTS.construct_metrics_decimal AS cmd
    ON
      cm.construct_id = cmd.metric_id ;;
  }

  dimension: construct_id {
    type: string
    sql: ${TABLE}.construct_id ;;
  }

  dimension: participant_id {
    type: string
    sql: ${TABLE}.participant_id ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: metric_id {
    type: string
    sql: ${TABLE}.metric_id ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  # Optional: Add other dimensions as needed, e.g., timestamps
  # Remove these if `created_at`, `updated_at`, and `deleted_at` are not in the result of the derived table
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }

  dimension_group: deleted {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_at ;;
  }

  measure: count {
    type: count
  }
}
