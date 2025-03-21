view: type_of_learning {
  derived_table: {
    sql: WITH base_query AS (
    SELECT
        cm.kind AS type,
        COUNT(cm.kind) AS count_kind,
        (SELECT COUNT(*)
         FROM construct_metrics cm2
         JOIN participants pt ON pt.id = cm2.participant_id
         JOIN socio_demographics sd ON sd.participant_id = pt.id
         JOIN construct_metrics_decimal cmd2 ON cm2.id = cmd2.metric_id
         JOIN constructs c2 ON cm2.construct_id = c2.id
         JOIN projects pr2 ON c2.project_id = pr2.id
         JOIN project_clients prc ON prc.id = prc.project_id = pr2.id
         JOIN clients cl ON cl.id = prc.client_id
         WHERE
            TRIM(LOWER(c2.name)) LIKE '%estilos de aprendizaje%'
            AND TRIM(LOWER(pr2.title)) LIKE '%vocacional%'
            AND TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
             AND (
                '{{ _user_attributes['city'] }}' IS NULL
                OR '{{ _user_attributes['city'] }}' = ''
                OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
             )
            OR (
                '{{ _user_attributes['city'] }}' IS NULL
                OR '{{ _user_attributes['city'] }}' = ''
                OR TRIM(LOWER(sd.country)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
            )
             AND (
                '{{ _user_attributes['school'] }}' IS NULL
                OR '{{ _user_attributes['school'] }}' = ''
                OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
             )
        ) AS total_count
    FROM
        construct_metrics cm
    JOIN
        construct_metrics_decimal cmd ON cm.id = cmd.metric_id
    JOIN
        participants p ON p.id = cm.participant_id
    JOIN
        socio_demographics sd ON sd.participant_id = p.id
    JOIN
        constructs c ON cm.construct_id = c.id
    JOIN
        projects pr ON c.project_id = pr.id
    WHERE
        TRIM(LOWER(c.name)) LIKE '%aprendizaje%'
    GROUP BY
        cm.kind
)

SELECT
      'auditiva' AS type,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%auditiva%' THEN count_kind ELSE 0 END) AS count_kind,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%auditiva%' THEN count_kind ELSE 0 END) * 100.0 /
      NULLIF(MAX(total_count), 0) AS scale
  FROM base_query

  UNION ALL

  SELECT
      'lectura/escritura' AS type,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%lectura%' THEN count_kind ELSE 0 END) AS count_kind,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%lectura%' THEN count_kind ELSE 0 END) * 100.0 /
      NULLIF(MAX(total_count), 0) AS scale
  FROM base_query

  UNION ALL

  SELECT
      'kinestesica' AS type,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%kinestesica%' THEN count_kind ELSE 0 END) AS count_kind,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%kinestesica%' THEN count_kind ELSE 0 END) * 100.0 /
      NULLIF(MAX(total_count), 0) AS scale
  FROM base_query

  UNION ALL

  SELECT
      'visual' AS type,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%visual%' THEN count_kind ELSE 0 END) AS count_kind,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%visual%' THEN count_kind ELSE 0 END) * 100.0 /
      NULLIF(MAX(total_count), 0) AS scale
  FROM base_query

  UNION ALL

  SELECT
      'social' AS type,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%social%' THEN count_kind ELSE 0 END) AS count_kind,
      SUM(CASE WHEN TRIM(LOWER(type)) LIKE '%social%' THEN count_kind ELSE 0 END) * 100.0 /
      NULLIF(MAX(total_count), 0) AS scale
  FROM base_query;;
  }

  # Dimensiones

 # Dimensión para el ID en formato hexadecimal

  dimension: type {

    type: string
    sql: ${TABLE}.type ;;
    description: "Tipo de personalidad"
  }

  dimension: count_kind {
    type: string
    sql: ${TABLE}.count_kind ;;
    description: "Tipo de personalidad"
  }

  measure: scale {
    type: sum
    sql: ${TABLE}.scale ;;
    description: "Valor máximo de amabilidad"
  }


  set: detail {
    fields: [
      type,
      scale
    ]
  }
}
