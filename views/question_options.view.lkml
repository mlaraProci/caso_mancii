view: question_options {
  sql_table_name: MANCII_RESULTS.question_options ;;
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
  dimension: extracted_value {
    type: number
    sql: ${TABLE}.extracted_value ;;
  }
  dimension: has_order {
    type: yesno
    sql: ${TABLE}.has_order ;;
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
  dimension: nouns {
    type: string
    sql: ${TABLE}.nouns ;;
  }
  dimension: option_order {
    type: number
    sql: ${TABLE}.option_order ;;
  }
  dimension: option_text {
    type: string
    sql: ${TABLE}.option_text ;;
  }
  dimension: question_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.question_id ;;
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
    drill_fields: [id, questions.construct_name, questions.id]
  }
}
