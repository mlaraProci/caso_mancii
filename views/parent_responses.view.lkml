view: parent_responses {

  derived_table: {
    sql:
      WITH responses AS (
        SELECT
          BIN_TO_UUID(cm.participant_id) AS participant_id,
          BIN_TO_UUID(cm.project_client) AS project_client_id,
          SUBSTRING_INDEX(cm.category, '_', 1) AS respondent_id,
          CAST(SUBSTRING_INDEX(cm.category, '_', -1) AS UNSIGNED) AS question_id,
          CASE SUBSTRING_INDEX(cm.category, '_', -1)
            WHEN '1' THEN 'Nombre completo'
            WHEN '2' THEN 'Nombre preferido'
            WHEN '3' THEN 'Aspiración profesional del hijo'
            WHEN '4' THEN 'Institución educativa preferida'
            WHEN '5' THEN 'Ciudad de estudio preferida'
            WHEN '6' THEN 'Tipo de institución'
            WHEN '7' THEN 'Presupuesto máximo por semestre'
            WHEN '8' THEN 'Fuente de financiación'
            WHEN '9' THEN 'Ubicación actual'
            WHEN '10' THEN 'Ingreso familiar mensual'
            WHEN '11' THEN 'Barrio'
            WHEN '12' THEN 'Edad'
            WHEN '13' THEN 'Nacionalidad'
            WHEN '14' THEN 'Sexo'
            WHEN '15' THEN 'Tipo de núcleo familiar'
            WHEN '16' THEN 'Nivel de formación'
            WHEN '17' THEN 'Actividad económica'
            WHEN '18' THEN 'Condiciones especiales del menor'
            WHEN '19' THEN 'Discapacidad del menor'
            WHEN '20' THEN 'Grupo social'
            ELSE 'Desconocido'
          END AS question_text,
          cmd.value AS numeric_value,
          cmd.value_text AS text_value,
          cm.created_at AS response_date
        FROM MANCII_RESULTS.construct_metrics cm
        JOIN MANCII_RESULTS.construct_metrics_decimal cmd ON cmd.metric_id = cm.id
        WHERE cm.kind = 'parent_test'
          AND cm.deleted_at IS NULL
          AND cmd.deleted_at IS NULL
      ),

      career_info AS (
        SELECT
          participant_id,
          GROUP_CONCAT(
            DISTINCT
            TRIM(
              REGEXP_REPLACE(
                REGEXP_REPLACE(
                  REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n),
                  '[\\[\\]"]', ''
                ),
                '[()\\.]', ''
              )
            )
            SEPARATOR ', '
          ) AS careers_list,
          COUNT(
            DISTINCT
            TRIM(
              REGEXP_REPLACE(
                REGEXP_REPLACE(
                  REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n),
                  '[\\[\\]"]', ''
                ),
                '[()\\.]', ''
              )
            )
          ) AS career_count
        FROM socio_demographics
        CROSS JOIN (
          SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
        ) numbers
        WHERE preferred_careers NOT IN ('Not Applicable', 'Not Answered', 'No sé', 'no se', 'no se que estudiar todavía', 'nose aun', 'aun no se')
          AND REGEXP_SUBSTR(preferred_careers, '[^",]+', 1, numbers.n) IS NOT NULL
        GROUP BY participant_id
      )

      SELECT
      r.*,
      sd.school AS school,
      sd.grade AS grade,
      sd.city AS city,
      sd.country AS country,
      sd.preferred_careers AS preferred_careers,
      ci.careers_list,
      ci.career_count
      FROM responses r
      LEFT JOIN MANCII_RESULTS.socio_demographics sd ON r.participant_id = BIN_TO_UUID(sd.participant_id)
      LEFT JOIN career_info ci ON r.participant_id = ci.participant_id
      WHERE 1=1
      {% if _user_attributes['client_acronym'] != null and _user_attributes['client_acronym'] != '' %}
      AND TRIM(LOWER(r.project_client_id)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
      {% endif %}
      {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
      {% assign cities = _user_attributes['city'] | split: ',' %}
      AND (
      {% for c in cities %}
      TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ c | strip | escape }}', '%'))
      {% unless forloop.last %} OR {% endunless %}
      {% endfor %}
      )
      {% endif %}
      {% if _user_attributes['school'] != null and _user_attributes['school'] != '' %}
      AND TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
      {% endif %}
      ;;
  }

  dimension: participant_id {
    type: string
    sql: ${TABLE}.participant_id ;;
    primary_key: yes
  }

  dimension: project_client_id {
    type: string
    sql: ${TABLE}.project_client_id ;;
  }

  dimension: respondent_id {
    type: string
    sql: ${TABLE}.respondent_id ;;
  }

  dimension: question_id {
    type: number
    sql: ${TABLE}.question_id ;;
  }

  dimension: question_text {
    type: string
    sql: ${TABLE}.question_text ;;
  }

  dimension: numeric_value {
    type: number
    sql: ${TABLE}.numeric_value ;;
  }

  dimension: text_value {
    type: string
    sql: ${TABLE}.text_value ;;
  }

  dimension: response_value {
    type: string
    sql:
      CASE
        WHEN ${TABLE}.text_value IS NOT NULL AND ${TABLE}.text_value != '' THEN ${TABLE}.text_value
        WHEN ${TABLE}.numeric_value IS NOT NULL THEN CAST(${TABLE}.numeric_value AS CHAR)
        ELSE NULL
      END ;;
  }

  dimension: response_date {
    type: date_time
    sql: ${TABLE}.response_date ;;
    convert_tz: no
  }

  dimension: question_type {
    type: string
    sql:
      CASE
        WHEN ${TABLE}.question_id IN (1,2,3,4,5,9,11) THEN 'Texto libre'
        WHEN ${TABLE}.question_id IN (7,10,12) THEN 'Numérico'
        ELSE 'Opción múltiple'
      END ;;
  }

  # Dimensión para clasificar las aspiraciones profesionales
  dimension: carrera_clasificada {
    type: string
    sql:
      CASE
        WHEN ${question_id} = 3 THEN /* Solo para pregunta de aspiración profesional */
          CASE
            WHEN LOWER(${text_value}) LIKE '%medicina%' OR LOWER(${text_value}) LIKE '%médico%' OR LOWER(${text_value}) LIKE '%doctor%' THEN 'medicina'
            WHEN LOWER(${text_value}) LIKE '%psicolog%' THEN 'psicologia'
            WHEN LOWER(${text_value}) LIKE '%derecho%' OR LOWER(${text_value}) LIKE '%abogad%' THEN 'derecho'
            WHEN LOWER(${text_value}) LIKE '%administracion%empres%' OR LOWER(${text_value}) LIKE '%adm%empres%' THEN 'administracion de empresas'
            WHEN LOWER(${text_value}) LIKE '%negocio%internacional%' THEN 'negocios internacionales'
            WHEN LOWER(${text_value}) LIKE '%ingenieria%sistema%' OR LOWER(${text_value}) LIKE '%software%' THEN 'ingenieria de sistemas'
            WHEN LOWER(${text_value}) LIKE '%marketing%' OR LOWER(${text_value}) LIKE '%mercadotecnia%' THEN 'marketing'
            WHEN LOWER(${text_value}) LIKE '%veterinari%' THEN 'veterinaria'
            WHEN LOWER(${text_value}) LIKE '%diseño%grafic%' OR LOWER(${text_value}) LIKE '%diseno%grafic%' THEN 'diseño grafico'
            WHEN LOWER(${text_value}) LIKE '%contadur%' THEN 'contabilidad'
            ELSE LOWER(${text_value})
          END
        ELSE NULL
      END ;;
    description: "Aspiración profesional clasificada en categorías estandarizadas"
  }

  # Medida para contar carreras clasificadas
  measure: count_carrera_clasificada {
    type: count
    filters: {
      field: question_id
      value: "3"
    }
    filters: {
      field: carrera_clasificada
      value: "-NULL"
    }
    description: "Conteo de aspiraciones profesionales clasificadas"
  }

  # Nuevas dimensiones agregadas del join con socio_demographics
  dimension: school {
    type: string
    sql: ${TABLE}.school ;;
    description: "Colegio del participante"
  }

  dimension: grade {
    type: string
    sql: ${TABLE}.grade ;;
    description: "Grado escolar del participante"
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    description: "Ciudad del participante"
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
    description: "País del participante"
  }

  dimension: preferred_careers {
    type: string
    sql: ${TABLE}.preferred_careers ;;
    description: "Carreras preferidas del participante"
  }

  dimension: careers_list {
    type: string
    sql: ${TABLE}.careers_list ;;
    description: "Lista de carreras preferidas formateada"
  }

  dimension: career_count {
    type: number
    sql: ${TABLE}.career_count ;;
    description: "Número de carreras preferidas distintas"
  }

  measure: total_responses {
    type: count
    description: "Número total de respuestas"
  }

  measure: count_participants {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    description: "Número de participantes únicos"
  }

  measure: count_tipo_entidad_privada {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "6"
    }
    filters: {
      field: numeric_value
      value: "1"
    }
    description: "Cuenta participantes que seleccionaron 'Privada' como tipo de institución"
  }

  measure: count_tipo_entidad_publica {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "6"
    }
    filters: {
      field: numeric_value
      value: "2"
    }
    description: "Cuenta participantes que seleccionaron 'Pública' como tipo de institución"
  }

  measure: count_tipo_entidad_indiferente {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "6"
    }
    filters: {
      field: numeric_value
      value: "3"
    }
    description: "Cuenta participantes que seleccionaron 'Indiferente' como tipo de institución"
  }

  measure: count_financiamiento_prestamo {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "8"
    }
    filters: {
      field: numeric_value
      value: "1"
    }
    description: "Cuenta participantes que seleccionaron 'Préstamo' como fuente de financiación"
  }

  measure: count_financiamiento_recursos_propios {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "8"
    }
    filters: {
      field: numeric_value
      value: "2"
    }
    description: "Cuenta participantes que seleccionaron 'Recursos propios' como fuente de financiación"
  }

  measure: count_financiamiento_prestamo_familiar {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "8"
    }
    filters: {
      field: numeric_value
      value: "3"
    }
    description: "Cuenta participantes que seleccionaron 'Préstamo familiar' como fuente de financiación"
  }

  measure: count_financiamiento_beca {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "8"
    }
    filters: {
      field: numeric_value
      value: "4"
    }
    description: "Cuenta participantes que seleccionaron 'Beca' como fuente de financiación"
  }

  measure: count_financiamiento_otro {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "8"
    }
    filters: {
      field: numeric_value
      value: "5"
    }
    description: "Cuenta participantes que seleccionaron 'Otro' como fuente de financiación"
  }

  measure: count_actividad_empleado {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "17"
    }
    filters: {
      field: numeric_value
      value: "1"
    }
    description: "Cuenta participantes que seleccionaron 'Empleado' como actividad económica"
  }

  measure: count_actividad_informal {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "17"
    }
    filters: {
      field: numeric_value
      value: "2"
    }
    description: "Cuenta participantes que seleccionaron 'Informal' como actividad económica"
  }

  measure: count_actividad_independiente {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "17"
    }
    filters: {
      field: numeric_value
      value: "3"
    }
    description: "Cuenta participantes que seleccionaron 'Independiente' como actividad económica"
  }

  measure: count_sexo_masculino {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "14"
    }
    filters: {
      field: numeric_value
      value: "1"
    }
    description: "Cuenta participantes que seleccionaron 'Masculino' como sexo"
  }

  measure: count_sexo_femenino {
    type: count_distinct
    sql: ${TABLE}.participant_id ;;
    filters: {
      field: question_id
      value: "14"
    }
    filters: {
      field: numeric_value
      value: "2"
    }
    description: "Cuenta participantes que seleccionaron 'Femenino' como sexo"
  }
}
