view: aprendizaje {

  derived_table: {
    sql:
      SELECT
        HEX(p.id) AS participant_id,
        p.name AS participant_name,
        LOWER(TRIM(cm.kind)) AS raw_learning_type,
        cmd.value AS type_value,

      CASE
      WHEN LOWER(TRIM(cm.kind)) LIKE '%audit%' THEN 'Auditiva'
      WHEN LOWER(TRIM(cm.kind)) LIKE '%visual%' THEN 'Visual'
      WHEN LOWER(TRIM(cm.kind)) LIKE '%kinest%' THEN 'Kinestésica'
      WHEN LOWER(TRIM(cm.kind)) LIKE '%lectura%' OR LOWER(TRIM(cm.kind)) LIKE '%escritura%' THEN 'Lectura/Escritura'
      WHEN LOWER(TRIM(cm.kind)) LIKE '%social%' THEN 'Social'
      ELSE 'Otro'
      END AS learning_type,

      CASE
      WHEN cmd.value = 0 THEN 0
      WHEN cmd.value <= 0.3 THEN 1
      WHEN cmd.value <= 0.7 THEN 2
      ELSE 3
      END AS development_level,

      CASE
      WHEN cmd.value = 0 THEN 'No desarrollado'
      WHEN cmd.value <= 0.3 THEN 'Desarrollo incipiente'
      WHEN cmd.value <= 0.7 THEN 'Desarrollo medio'
      ELSE 'Desarrollo avanzado'
      END AS development_status,

      CASE WHEN cmd.value > 0.1 THEN TRUE ELSE FALSE END AS has_meaningful_development,
      CASE WHEN cmd.value = 1 THEN TRUE ELSE FALSE END AS has_full_development,

      pr.title AS project_title,
      cl.acronym AS client_acronym,
      sd.city,
      sd.school
      FROM construct_metrics cm
      JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
      JOIN participants p ON p.id = cm.participant_id
      JOIN constructs c ON cm.construct_id = c.id
      JOIN projects pr ON c.project_id = pr.id
      JOIN project_clients pc ON pr.id = pc.project_id
      JOIN clients cl ON pc.client_id = cl.id
      LEFT JOIN socio_demographics sd ON p.id = sd.participant_id
      WHERE
      LOWER(c.name) LIKE '%aprendizaje%'
      AND LOWER(pr.title) LIKE '%vocacional%'
      AND ('{{ _user_attributes['client_acronym'] }}' = '' OR TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%')))
      AND (
      '{{ _user_attributes['city'] }}' IS NULL
      OR '{{ _user_attributes['city'] }}' = ''
      OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
      OR TRIM(LOWER(sd.country)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
      )
      AND (
      '{{ _user_attributes['school'] }}' IS NULL
      OR '{{ _user_attributes['school'] }}' = ''
      OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
      )
      ;;
  }

  dimension: participant_id {
    type: string
    sql: ${TABLE}.participant_id ;;
    primary_key: yes
  }

  dimension: participant_name {
    type: string
    sql: ${TABLE}.participant_name ;;
  }

  dimension: learning_type {
    type: string
    sql: ${TABLE}.learning_type ;;
  }

  dimension: type_value {
    type: number
    sql: ${TABLE}.type_value ;;
    value_format_name: decimal_2
  }

  dimension: development_level {
    type: number
    sql: ${TABLE}.development_level ;;
    description: "0=Ninguno, 1=Incipiente, 2=Medio, 3=Avanzado"
  }

  dimension: development_status {
    type: string
    sql: ${TABLE}.development_status ;;
    html:
      CASE
        WHEN {{ value }} = 'No desarrollado' THEN '<span style="color: #ff4d4d;">{{value}}</span>'
        WHEN {{ value }} = 'Desarrollo incipiente' THEN '<span style="color: #ffcc00;">{{value}}</span>'
        WHEN {{ value }} = 'Desarrollo medio' THEN '<span style="color: #4dff4d;">{{value}}</span>'
        ELSE '<span style="color: #00cc00;">{{value}}</span>'
      END ;;
  }

  dimension: client_acronym {
    type: string
    sql: ${TABLE}.client_acronym ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
  }

  filter: has_development {
    type: yesno
    sql: ${TABLE}.has_meaningful_development ;;
  }

  filter: full_development {
    type: yesno
    sql: ${TABLE}.has_full_development ;;
  }

  measure: total_participants {
    type: count_distinct
    sql: ${participant_id} ;;
  }

  measure: developed_participants {
    type: count_distinct
    sql: ${participant_id} ;;
    filters: [has_development: "yes"]
  }

  measure: development_percentage {
    type: number
    sql: 100.0 * ${developed_participants} / NULLIF(${total_participants}, 0) ;;
    value_format_name: percent_1
  }

  measure: avg_development {
    type: average
    sql: ${type_value} ;;
    filters: [type_value: ">0"]
    value_format_name: decimal_2
  }

  set: participant_overview {
    fields: [
      participant_name,
      learning_type,
      development_status,
      type_value,
      client_acronym,
      city,
      school
    ]
  }
}
