view: attendent {
  sql_table_name: MANCII_RESULTS.attendent ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: alignment_institution {
    type: string
    sql: ${TABLE}.alignmentInstitution ;;
  }
  dimension_group: birth {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.birth ;;
  }
  dimension: budget {
    type: number
    sql: ${TABLE}.budget ;;
  }
  dimension: budget_unit {
    type: string
    sql: ${TABLE}.budget_unit ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: family_income {
    type: number
    sql: ${TABLE}.family_income ;;
  }
  dimension: family_income_unit {
    type: string
    sql: ${TABLE}.family_income_unit ;;
  }
  dimension: financing {
    type: string
    sql: ${TABLE}.financing ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.firstName ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.lastName ;;
  }
  dimension: need_financing {
    type: yesno
    sql: ${TABLE}.need_financing ;;
  }
  dimension: participant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.participant_id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, participants.id, participants.name]
  }
}
