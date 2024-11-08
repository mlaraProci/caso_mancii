view: answer_text {
  sql_table_name: MANCII_RESULTS.answer_text ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: answer_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.answer_id ;;
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
  dimension: length {
    type: number
    sql: ${TABLE}.length ;;
  }
  dimension: nouns {
    type: string
    sql: ${TABLE}.nouns ;;
  }
  dimension: sentiment_classification {
    type: string
    sql: ${TABLE}.sentiment_classification ;;
  }
  dimension: sentiment_score {
    type: number
    sql: ${TABLE}.sentiment_score ;;
  }
  dimension: term_frequency {
    type: string
    sql: ${TABLE}.term_frequency ;;
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
  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
  dimension: verbs {
    type: string
    sql: ${TABLE}.verbs ;;
  }
  measure: count {
    type: count
    drill_fields: [id, answers.id]
  }
}
