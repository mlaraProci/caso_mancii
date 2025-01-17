view: personality {
  derived_table: {
    sql: WITH base_query AS (
    SELECT
        `construct_metrics`.`kind`,
        `construct_metrics_decimal`.`value`
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `project_clients` ON `project_clients`.`project_id` = `projects`.`id`
    JOIN `clients` ON `clients`.`id` = `project_clients`.`client_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `socio_demographics` ON `socio_demographics`.`participant_id` = `participants`.`id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
    WHERE
        TRIM(LOWER(`constructs`.`name`)) LIKE '%personalidad%'
        AND TRIM(LOWER(projects.title)) LIKE '%vocacional%'
        AND TRIM(LOWER(clients.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
        AND `construct_metrics_decimal`.`value` > 0
)
SELECT
    'amabilidad' AS type,
    SUM(CASE WHEN `kind` LIKE '%Amabilidad%' THEN `value` ELSE 0 END) /
    NULLIF(COUNT(CASE WHEN `kind` LIKE '%Amabilidad%' THEN 1 ELSE NULL END), 0) AS value
FROM base_query
UNION ALL
SELECT
    'apertura_a_la_experiencia' AS type,
    SUM(CASE WHEN `kind` LIKE '%experiencia%' THEN `value` ELSE 0 END) /
    NULLIF(COUNT(CASE WHEN `kind` LIKE '%experiencia%' THEN 1 ELSE NULL END), 0) AS value
FROM base_query
UNION ALL
SELECT
    'conciencia' AS type,
    SUM(CASE WHEN `kind` LIKE '%Conciencia%' THEN `value` ELSE 0 END) /
    NULLIF(COUNT(CASE WHEN `kind` LIKE '%Conciencia%' THEN 1 ELSE NULL END), 0) AS value
FROM base_query
UNION ALL
SELECT
    'estabilidad_emocional' AS type,
    SUM(CASE WHEN `kind` LIKE '%Estabilidad emocional%' THEN `value` ELSE 0 END) /
    NULLIF(COUNT(CASE WHEN `kind` LIKE '%Estabilidad emocional%' THEN 1 ELSE NULL END), 0) AS value
FROM base_query
UNION ALL
SELECT
    'extraversion' AS type,
    SUM(CASE WHEN `kind` LIKE '%Extraversion%' THEN `value` ELSE 0 END) /
    NULLIF(COUNT(CASE WHEN `kind` LIKE '%Extraversion%' THEN 1 ELSE NULL END), 0) AS value
FROM base_query;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensiones adicionales para `kind` y `value`
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    description: "Tipo de personalidad"
  }

  measure: value {
    type: sum
    sql: ${TABLE}.value ;;
    description: "Valor máximo de amabilidad"
  }


  set: detail {
    fields: [
      id,
      type,
      value
    ]
  }
}
