view: answers {
  sql_table_name: MANCII_RESULTS.answers ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
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
  dimension: heat_map_data {
    type: string
    sql: ${TABLE}.heat_map_data ;;
  }
  dimension: participant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.participant_id ;;
  }
  dimension: question_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.question_id ;;
  }
  dimension_group: response {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.response_time ;;
  }
  dimension: response_type {
    type: string
    sql: ${TABLE}.response_type ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension_group: view {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.view_time ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
	id,
	participants.id,
	participants.name,
	questions.construct_name,
	questions.id,
	answer_boolean.count,
	answer_date.count,
	answer_decimal.count,
	answer_integer.count,
	answer_json.count,
	answer_metrics.count,
	answer_range.count,
	answer_text.count
	]
  }

}
