view: constructs {
  sql_table_name: MANCII_RESULTS.constructs ;;
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
  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: project_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.project_id ;;
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
	name,
	projects.id,
	projects.project_name,
	comparative_fit_index.count,
	construct_metrics.count,
	content_validity_index.count,
	convergence_divergence_correlation.count,
	cronbach_alpha.count,
	equivalence_coefficient.count,
	g_coefficient.count,
	interaction_metrics.count,
	intraclass_correlation_coefficient.count,
	questions.count,
	root_mean_square_error.count,
	validity_evidence.count
	]
  }

}
