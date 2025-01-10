view: questions {
  sql_table_name: MANCII_RESULTS.questions ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: average {
    type: number
    sql: ${TABLE}.average ;;
  }
  dimension: construct_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.construct_id ;;
  }
  dimension: construct_name {
    type: string
    sql: ${TABLE}.construct_name ;;
  }
  dimension: construct_type {
    type: string
    sql: ${TABLE}.construct_type ;;
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
  dimension: execution_type {
    type: string
    sql: ${TABLE}.execution_type ;;
  }
  dimension: extracted_value {
    type: number
    sql: ${TABLE}.extracted_value ;;
  }
  dimension: length {
    type: number
    sql: ${TABLE}.length ;;
  }
  dimension: max {
    type: number
    sql: ${TABLE}.max ;;
  }
  dimension: min {
    type: number
    sql: ${TABLE}.min ;;
  }
  dimension: node {
    type: string
    sql: ${TABLE}.node ;;
  }
  dimension: nouns {
    type: string
    sql: ${TABLE}.nouns ;;
  }
  dimension: scale_id {
    type: string
    sql: ${TABLE}.scale_id ;;
  }
  dimension: sentiment_classification {
    type: string
    sql: ${TABLE}.sentiment_classification ;;
  }
  dimension: sentiment_score {
    type: number
    sql: ${TABLE}.sentiment_score ;;
  }
  dimension: sum {
    type: number
    sql: ${TABLE}.sum ;;
  }
  dimension: term_frequency {
    type: string
    sql: ${TABLE}.term_frequency ;;
  }
  dimension: tokens {
    type: string
    sql: ${TABLE}.tokens ;;
  }
  dimension: type_id {
    type: string
    sql: ${TABLE}.type_id ;;
  }
  dimension: unique_words {
    type: number
    sql: ${TABLE}.unique_words ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: verbs {
    type: string
    sql: ${TABLE}.verbs ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  construct_name,
  constructs.id,
  constructs.name,
  analysis_results.count,
  answers.count,
  concurrent_correlation_coefficient.count,
  discrimination_index.count,
  item_functioning_differences.count,
  predictive_correlation_coefficient.count,
  question_options.count
  ]
  }

}
