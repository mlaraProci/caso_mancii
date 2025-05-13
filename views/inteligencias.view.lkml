view: inteligencias {
  derived_table: {
    sql:SELECT
       HEX(p.id) AS id,  -- Convertimos el ID a formato hexadecimal
       p.name AS name,  -- Incluimos el campo name de la tabla participants
       LOWER(TRIM(cm.kind)) AS kind,  -- Normalizamos el valor de kind
       cmd.value AS value,  -- Incluimos value de construct_metrics_decimal
       MAX(CASE WHEN cm.kind = 'Inteligencia_musical' THEN cmd.value END) AS Inteligencia_musical,
MAX(CASE WHEN cm.kind = 'Inteligencia_corporalkinestesica' THEN cmd.value END) AS Inteligencia_corporalkinestesica,
MAX(CASE WHEN cm.kind = 'Inteligencia_interpersonal' THEN cmd.value END) AS Inteligencia_interpersonal,
MAX(CASE WHEN cm.kind = 'Inteligencia_naturalista' THEN cmd.value END) AS Inteligencia_naturalista,
MAX(CASE WHEN cm.kind = 'Inteligencia_linguistica' THEN cmd.value END) AS Inteligencia_linguistica,
MAX(CASE WHEN cm.kind = 'Inteligencia_espacial' THEN cmd.value END) AS Inteligencia_espacial,
MAX(CASE WHEN cm.kind = 'Inteligencia_intrapersonal' THEN cmd.value END) AS Inteligencia_intrapersonal,
MAX(CASE WHEN cm.kind = 'inteligencia_artificial' THEN cmd.value END) AS Inteligencia_artificial,
MAX(CASE WHEN cm.kind = 'Inteligencia_existencial' THEN cmd.value END) AS Inteligencia_existencial,
MAX(CASE WHEN cm.kind = 'Inteligencia_logicomatematica' THEN cmd.value END) AS Inteligencia_logicomatematica
FROM constructs c
JOIN projects pr ON pr.id = c.project_id
JOIN project_clients pc ON pc.project_id = pr.id
JOIN clients cl ON cl.id = pc.client_id
JOIN construct_metrics cm ON cm.construct_id = c.id
JOIN participants p ON p.id = cm.participant_id
JOIN construct_metrics_decimal cmd ON cm.id = cmd.metric_id
LEFT JOIN socio_demographics sd ON sd.participant_id = p.id
 `socio_demographics`
LEFT JOIN sectionals ON socio_demographics.sectional_id = sectionals.id
WHERE LOWER(TRIM(c.name)) LIKE '%inteligencias%'  -- Filtramos por el nombre del constructo
  AND cmd.value > 0  -- Filtramos valores mayores a 0
  AND LOWER(TRIM(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["client_acronym"] }}', '%'))  -- Filtro dinámico para el acrónimo del cliente
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
    '{{ _user_attributes["school"] }}' IS NULL
    OR '{{ _user_attributes["school"] }}' = ''
    OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes["school"] }}', '%'))
  )
  AND (
    '{{ _user_attributes['sectional'] }}' IS NULL
    OR '{{ _user_attributes['sectional'] }}' = ''
    OR TRIM(LOWER(sectionals.name)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['sectional'] }}', '%'))
  )
GROUP BY HEX(p.id), p.name, cm.kind, cmd.value


 ;;
  }

  # Dimensión para el ID en formato hexadecimal
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensión para `kind`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de inteligencia como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de inteligencia como dimensión"
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre"
  }

  # Medidas para cada tipo de inteligencia basadas en `kind`
  measure: Inteligencia_corporalkinestesica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia corporalkinestesica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia corporal-kinestésica"
  }

  measure: Inteligencia_espacial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia espacial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia espacial"
  }

  measure: Inteligencia_existencial {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia existencial' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia existencial"
  }

  measure: Inteligencia_interpersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia interpersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia interpersonal"
  }

  measure: Inteligencia_intrapersonal {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia intrapersonal' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia intrapersonal"
  }

  measure: Inteligencia_linguistica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia linguistica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lingüística"
  }

  measure: Inteligencia_logicomatematica {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia logicomatematica' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia lógico-matemática"
  }

  measure: Inteligencia_musical {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia musical' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia musical"
  }

  measure: Inteligencia_naturalista {
    type: sum
    sql: CASE WHEN ${kind} = 'inteligencia naturalista' THEN ${value} ELSE 0 END ;;
    description: "Valor del tipo de inteligencia naturalista"
  }
  measure: count {
    type: count
    drill_fields: [id, kind, value]
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      Inteligencia_corporalkinestesica,
      Inteligencia_espacial,
      Inteligencia_existencial,
      Inteligencia_interpersonal,
      Inteligencia_intrapersonal,
      Inteligencia_linguistica,
      Inteligencia_logicomatematica,
      Inteligencia_musical,
      Inteligencia_naturalista
    ]
  }
}
