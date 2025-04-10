view: aprendizaje {
  derived_table: {
    sql:
      WITH base_data AS (
        SELECT
          p.id AS participant_id,
          HEX(p.id) AS hashed_id,
          p.name AS participant_name,
          LOWER(TRIM(cm.kind)) AS learning_style,
          pr.title AS project_title,
          cl.id AS client_id,
          cl.acronym AS client_acronym
        FROM `constructs` c
        JOIN `projects` pr ON pr.id = c.project_id
        JOIN `project_clients` pc ON pr.id = pc.project_id
        JOIN `clients` cl ON pc.client_id = cl.id
        JOIN `construct_metrics` cm ON cm.construct_id = c.id
        JOIN `participants` p ON p.id = cm.participant_id
        LEFT JOIN `socio_demographics` sd ON p.id = sd.participant_id
        WHERE LOWER(TRIM(c.name)) LIKE '%estilos de aprendizaje%'
          AND TRIM(LOWER(pr.title)) LIKE '%vocacional%'
          AND TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
            {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
              {% assign cities = _user_attributes['city'] | split: ',' %}
              AND (
                {% for c in cities %}
                  TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ c | strip | escape }}', '%'))
                  {% unless forloop.last %} OR {% endunless %}
                {% endfor %}
              )
            {% endif %}
          AND (
            '{{ _user_attributes['school'] }}' IS NULL
            OR '{{ _user_attributes['school'] }}' = ''
            OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
          )
      ),
      style_categories AS (
        SELECT
          CASE
            WHEN learning_style LIKE '%audit%' THEN 'Auditivo'
            WHEN learning_style LIKE '%lectura%' OR learning_style LIKE '%escritura%' THEN 'Lectura/Escritura'
            WHEN learning_style LIKE '%kines%' OR learning_style LIKE '%cinest%' THEN 'Kinestésico'
            WHEN learning_style LIKE '%visual%' THEN 'Visual'
            WHEN learning_style LIKE '%social%' THEN 'Social'
            ELSE 'Otro'
          END AS style_type,
          COUNT(*) AS style_count,
          (SELECT COUNT(DISTINCT participant_id) FROM base_data) AS total_participants
        FROM base_data
        GROUP BY 1
      )
      SELECT
        style_type AS type,
        style_count AS count_kind,
        100.0 * style_count / NULLIF(total_participants, 0) AS percentage_scale,
        CASE
          WHEN 100.0 * style_count / NULLIF(total_participants, 0) < 20 THEN 'Poco común'
          WHEN 100.0 * style_count / NULLIF(total_participants, 0) < 50 THEN 'Moderado'
          ELSE 'Dominante'
        END AS prevalence_category,
        hashed_id  -- Añadido para poder contar participantes únicos
      FROM style_categories
      JOIN base_data ON style_categories.style_type = base_data.learning_style
      WHERE style_type != 'Otro'
      GROUP BY style_type, style_count, total_participants, hashed_id
      ORDER BY style_count DESC;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    description: "Estilo de aprendizaje (Auditivo, Visual, Kinestésico, etc.)"
    html:
      CASE
        WHEN {{ value }} = 'Auditivo' THEN
          '<span style="color: #4285F4; font-weight: bold;">{{value}}</span>'
        WHEN {{ value }} = 'Visual' THEN
          '<span style="color: #EA4335; font-weight: bold;">{{value}}</span>'
        WHEN {{ value }} = 'Kinestésico' THEN
          '<span style="color: #FBBC05; font-weight: bold;">{{value}}</span>'
        WHEN {{ value }} = 'Lectura/Escritura' THEN
          '<span style="color: #34A853; font-weight: bold;">{{value}}</span>'
        ELSE
          '<span style="color: #9E9E9E; font-weight: bold;">{{value}}</span>'
      END ;;
  }

  dimension: count_kind {
    type: number
    sql: ${TABLE}.count_kind ;;
    description: "Número de participantes con este estilo"
  }

  dimension: prevalence_category {
    type: string
    sql: ${TABLE}.prevalence_category ;;
    description: "Categoría de prevalencia del estilo"
  }

  dimension: hashed_id {
    type: string
    sql: ${TABLE}.hashed_id ;;
    hidden: yes
    description: "ID hasheado del participante para conteos únicos"
  }

  measure: total_styles {
    type: sum
    sql: ${count_kind} ;;
    description: "Total de estilos registrados (puede haber múltiples por persona)"
  }

  measure: scale {
    type: average
    sql: ${TABLE}.percentage_scale ;;
    description: "Porcentaje promedio de cada estilo en la población"
    value_format_name: percent_1
  }

  measure: unique_participants {
    type: count_distinct
    sql: ${hashed_id} ;;
    description: "Número único de participantes con estilos registrados"
  }

  set: style_analysis {
    fields: [
      type,
      count_kind,
      prevalence_category
    ]
  }

  set: style_summary {
    fields: [
      total_styles,
      unique_participants,
      scale
    ]
  }
}
