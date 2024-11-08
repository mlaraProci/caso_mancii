view: interaction_metrics {
  sql_table_name: MANCII_RESULTS.interaction_metrics ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: completed {
    type: yesno
    sql: ${TABLE}.completed ;;
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
  dimension: cta_engagement {
    type: string
    sql: ${TABLE}.cta_engagement ;;
  }
  dimension_group: deleted {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.deleted_at ;;
  }
  dimension: participant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.participant_id ;;
  }
  dimension: redo_count {
    type: number
    sql: ${TABLE}.redo_count ;;
  }
  dimension: segment_name {
    type: string
    sql: ${TABLE}.segment_name ;;
  }
  dimension: transaction_status {
    type: string
    sql: ${TABLE}.transaction_status ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
	id,
	segment_name,
	constructs.id,
	constructs.name,
	participants.id,
	participants.name,
	devices.count
	]
  }

}
