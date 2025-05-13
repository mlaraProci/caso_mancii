view: socio_demographics {
  sql_table_name: MANCII_RESULTS.socio_demographics ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
  dimension: cellphone {
    type: string
    sql: ${TABLE}.cellphone ;;
  }
  dimension: choice {
    type: string
    sql: ${TABLE}.choice ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  #dimension: country {
  #  type: string
  #  map_layer_name: countries
  #  sql: TRIM(UPPER(${TABLE}.country)) ;;
  #}

  dimension: city {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.city ;;
  }
  dimension: contact {
    type: string
    sql: ${TABLE}.contact ;;
  }
  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
  }
#  dimension: country {
#    type: location
#    map_layer_name: countries
#   sql: ${TABLE}.country ;;
#  }
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
  dimension: favorite_subjects {
    type: string
    sql: ${TABLE}.favorite_subjects ;;
  }
  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
  }
  dimension: modality {
    type: string
    sql: ${TABLE}.modality ;;
  }
  dimension: neighborhood {
    type: string
    sql: ${TABLE}.neighborhood ;;
  }
  dimension: nickname {
    type: string
    sql: ${TABLE}.nickname ;;
  }
  dimension: participant_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.participant_id ;;
  }
  dimension: preferred_careers {
    type: string
    sql: ${TABLE}.preferred_careers ;;
  }
  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
  }
  dimension: social_media {
    type: string
    #sql: ${TABLE}.social_media ;;
    sql: MANCII_RESULTS.socio_demographics.social_media ;;

  }

  dimension: sectional_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.sectional_id ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: who_paid {
    type: string
    sql: ${TABLE}.who_paid ;;
  }
  measure: count {
    type: count
    drill_fields: [id, nickname, participants.id, participants.name]
  }
}
