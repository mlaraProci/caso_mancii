view: carrerasprueba {

  derived_table: {
    sql:
      WITH RECURSIVE numbers AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM numbers WHERE n < 3
      ),

      extracted_careers AS (
      SELECT
      sd.id,
      TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(sd.preferred_careers, '[^",]+', 1, n), '[\\[\\]"]', '')) AS career_raw
      FROM socio_demographics sd
      JOIN participants p ON p.id = sd.participant_id
      JOIN project_participants pp ON pp.participant_id = p.id
      JOIN projects pr ON pr.id = pp.project_id
      JOIN project_clients pc ON pc.project_id = pr.id
      JOIN clients c ON c.id = pc.client_id
      CROSS JOIN numbers
      WHERE
      sd.preferred_careers NOT IN ('Not Applicable', 'Not Answered', 'No sé', 'no se', 'no se que estudiar todavía', 'nose aun', 'aun no se')
      AND REGEXP_SUBSTR(sd.preferred_careers, '[^",]+', 1, n) IS NOT NULL
      AND TRIM(LOWER(c.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
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
      ),

      cleaned_careers AS (
      SELECT
      id,
      REGEXP_REPLACE(
      REGEXP_REPLACE(
      LOWER(career_raw),
      '[áéíóúñü]',
      ''
      ),
      '[()\\.]', ''
      ) AS career_clean
      FROM extracted_careers
      WHERE
      career_raw NOT IN ('not applicable', 'not answered', 'no sé', 'no se', 'sample', 'test', 'prueba')
      AND career_raw NOT LIKE '%no se%'
      AND LENGTH(career_raw) > 2
      ),

      grouped_careers AS (
      SELECT
      CASE
      WHEN career_clean LIKE '%medicina%' OR career_clean LIKE '%medico%' OR career_clean LIKE '%doctor%' THEN 'medicina'
      WHEN career_clean LIKE '%psicolog%' THEN 'psicologia'
      WHEN career_clean LIKE '%derecho%' OR career_clean LIKE '%abogad%' THEN 'derecho'
      WHEN career_clean LIKE '%administracion%empres%' OR career_clean LIKE '%adm%empres%' THEN 'administracion de empresas'
      WHEN career_clean LIKE '%negocio%internacional%' THEN 'negocios internacionales'
      WHEN career_clean LIKE '%ingenieria%sistema%' OR career_clean LIKE '%software%' THEN 'ingenieria de sistemas'
      WHEN career_clean LIKE '%marketing%' OR career_clean LIKE '%mercadotecnia%' THEN 'marketing'
      WHEN career_clean LIKE '%veterinari%' THEN 'veterinaria'
      WHEN career_clean LIKE '%diseño%grafic%' OR career_clean LIKE '%diseno%grafic%' THEN 'diseño grafico'
      WHEN career_clean LIKE '%contadur%' THEN 'contabilidad'
      ELSE career_clean
      END AS carrera,
      COUNT(*) AS frecuencia
      FROM cleaned_careers
      GROUP BY 1
      )

      SELECT
      carrera,
      frecuencia,
      ROUND(frecuencia * 100.0 / SUM(frecuencia) OVER (), 2) AS porcentaje
      FROM grouped_careers
      ORDER BY frecuencia DESC ;;
  }

  dimension: carrera {
    type: string
    sql: ${TABLE}.carrera ;;
    description: "Carrera normalizada y agrupada"
  }

  dimension: frecuencia {
    type: number
    sql: ${TABLE}.frecuencia ;;
    description: "Número de menciones de esta carrera"
  }

  dimension: porcentaje {
    type: number
    sql: ${TABLE}.porcentaje ;;
    description: "Porcentaje sobre el total de menciones"
    value_format_name: percent_2
  }

  measure: total_menciones {
    type: sum
    sql: ${frecuencia} ;;
    description: "Total de menciones de carreras"
  }
}
