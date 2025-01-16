view: career_frequencies {
  derived_table: {
    sql:
      SELECT
        CASE
          WHEN career_count > 1 THEN career
          ELSE 'Other'
        END AS career_grouped,  -- Agrupa las carreras menos frecuentes como 'Other'
        SUM(career_count) AS total_frequency
      FROM (
        SELECT
          TRIM(jt.career) AS career,  -- Limpia espacios en las carreras
          COUNT(*) AS career_count
        FROM
          socio_demographics
        JOIN JSON_TABLE(preferred_careers, '$[*]'
          COLUMNS (career VARCHAR(255) PATH '$')) jt
        ON TRUE
        GROUP BY jt.career
      ) AS career_counts  -- Tabla derivada
      GROUP BY career_grouped
      ORDER BY total_frequency DESC
    ;;
  }

  dimension: career_grouped {
    sql: ${TABLE}.career_grouped ;;
    type: string
    label: "Career Grouped"
    description: "Carreras agrupadas, las menos frecuentes se clasifican como 'Otras'."
  }

  measure: total_frequency {
    sql: ${TABLE}.total_frequency ;;
    type: number
    label: "Total Frequency"
    description: "Frecuencia total por carrera agrupada."
  }

  measure: percentage_total {
    sql: ${TABLE}.total_frequency / SUM(${TABLE}.total_frequency) OVER () ;;
    type: number
    value_format: "0.00%"
    label: "Percentage of Total"
    description: "Porcentaje de cada grupo de carrera sobre el total."
  }
}
