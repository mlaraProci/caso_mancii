view: carreras {
  derived_table: {
    sql:SELECT
    HEX(p.`id`) AS id, -- Convertimos el ID a formato hexadecimal
    p.`name` AS name, -- Seleccionamos el nombre del participante
    LOWER(TRIM(cm.`kind`)) AS kind, -- Normalizamos el valor de `kind`
    MAX(cmd.`value`) AS value -- Seleccionamos el valor máximo
FROM `constructs` c
JOIN `projects` pr ON pr.`id` = c.`project_id`
JOIN `construct_metrics` cm ON cm.`construct_id` = c.`id`
JOIN `participants` p ON p.`id` = cm.`participant_id`
JOIN `construct_metrics_decimal` cmd ON cm.`id` = cmd.`metric_id`
JOIN `socio_demographics` sd ON p.`id` = sd.`participant_id` -- Relación con socio_demographics
JOIN `clients` cl ON sd.`client_id` = cl.`id` -- Relación con clients
WHERE LOWER(TRIM(pr.`title`)) LIKE 'previous-test'
  AND LOWER(TRIM(c.`name`)) LIKE '%areas de conocimiento%'
  AND cmd.`value` > 0
  AND TRIM(LOWER(cl.acronym)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['client_acronym'] }}', '%'))
  AND (
      '{{ _user_attributes['city'] }}' IS NULL
      OR '{{ _user_attributes['city'] }}' = ''
      OR TRIM(LOWER(sd.city)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['city'] }}', '%'))
  )
  AND (
      '{{ _user_attributes['school'] }}' IS NULL
      OR '{{ _user_attributes['school'] }}' = ''
      OR TRIM(LOWER(sd.school)) LIKE LOWER(CONCAT('%', '{{ _user_attributes['school'] }}', '%'))
  )
GROUP BY HEX(p.`id`), p.`name`, LOWER(TRIM(cm.`kind`))
;;
  }


  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
    description: "ID del participante en formato hexadecimal"
  }

  # Dimensión para `kind`
  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
    description: "Tipo de carrera como dimensión"
  }

  # Dimensión para `value`
  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
    description: "Valor asociado al tipo de carrera como dimensión"
  }
# Dimensión para `name`
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "Nombre "
  }

  # Medidas para cada tipo de carrera basadas en `kind` usando MAX
    measure: medicina_veterinaria {

      type: max
      sql: CASE WHEN ${kind} = 'medicina_veterinaria' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera medicina veterinaria"
    }

    measure: agronomia {
      type: max
      sql: CASE WHEN ${kind} = 'agronomia' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera agronomia"
    }

    measure: zootecnia {
      type: max
      sql: CASE WHEN ${kind} = 'zootecnia' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera zootecnia"
    }

    measure: administracion_agropecuaria {
      type: max
      sql: CASE WHEN ${kind} = 'administracion_agropecuaria' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera administracion agropecuaria"
    }

    measure: agricultura {
      type: max
      sql: CASE WHEN ${kind} = 'agricultura' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera agricultura"
    }

    measure: ganaderia {
      type: max
      sql: CASE WHEN ${kind} = 'ganaderia' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera ganaderia"
    }

    measure: artes_plasticas {
      type: max
      sql: CASE WHEN ${kind} = 'artes_plasticas' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera artes plásticas"
    }

    measure: diseno_grafico {
      type: max
      sql: CASE WHEN ${kind} = 'diseno_grafico' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera diseno gráfico"
    }

    measure: publicidad {
      type: max
      sql: CASE WHEN ${kind} = 'publicidad' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera publicidad"
    }

    measure: diseno_de_moda {
      type: max
      sql: CASE WHEN ${kind} = 'diseno_de_moda' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera diseno de moda"
    }

    measure: cinematografia {
      type: max
      sql: CASE WHEN ${kind} = 'cinematografia' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera cinematografía"
    }

    measure: dramatica_teatro {
      type: max
      sql: CASE WHEN ${kind} = 'dramatica_teatro' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera dramática teatro"
    }

    measure: danza {
      type: max
      sql: CASE WHEN ${kind} = 'danza' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera danza"
    }

    measure: animacion_digital {
      type: max
      sql: CASE WHEN ${kind} = 'animacion_digital' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera animación digital"
    }

    measure: musica {
      type: max
      sql: CASE WHEN ${kind} = 'musica' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera música"
    }

    measure: fotografia {
      type: max
      sql: CASE WHEN ${kind} = 'fotografia' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera fotografía"
    }

    measure: diseno_de_interiores {
      type: max
      sql: CASE WHEN ${kind} = 'diseno_de_interiores' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera diseno de interiores"
    }

    measure: ilustracion {
      type: max
      sql: CASE WHEN ${kind} = 'ilustracion' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera ilustración"
    }

    measure: diseno_industrial {
      type: max
      sql: CASE WHEN ${kind} = 'diseno_industrial' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera diseno industrial"
    }

    measure: cine_tv {
      type: max
      sql: CASE WHEN ${kind} = 'cine_tv' THEN ${value} ELSE NULL END ;;
      description: "Valor máximo del tipo de carrera cine y televisión"
    }
  measure: educacion_fisica {
    type: max
    sql: CASE WHEN ${kind} = 'educacion_fisica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera educación física"
  }

  measure: derecho_y_afines {
    type: max
    sql: CASE WHEN ${kind} = 'derecho_y_afines' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera derecho y afines"
  }

  measure: filosofia {
    type: max
    sql: CASE WHEN ${kind} = 'filosofia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera filosofía"
  }

  measure: teologia {
    type: max
    sql: CASE WHEN ${kind} = 'teologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera teología"
  }

  measure: formacion_relacionada_con_el_campo_militar {
    type: max
    sql: CASE WHEN ${kind} = 'formacion_relacionada_con_el_campo_militar' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera formación relacionada con el campo militar"
  }

  measure: geografia {
    type: max
    sql: CASE WHEN ${kind} = 'geografia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera geografía"
  }

  measure: historia {
    type: max
    sql: CASE WHEN ${kind} = 'historia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera historia"
  }

  measure: lenguas_modernas {
    type: max
    sql: CASE WHEN ${kind} = 'lenguas_modernas' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera lenguas modernas"
  }

  measure: literatura {
    type: max
    sql: CASE WHEN ${kind} = 'literatura' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera literatura"
  }

  measure: linguistica {
    type: max
    sql: CASE WHEN ${kind} = 'linguistica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera lingüística"
  }

  measure: psicologia {
    type: max
    sql: CASE WHEN ${kind} = 'psicologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera psicología"
  }

  measure: sociologia {
    type: max
    sql: CASE WHEN ${kind} = 'sociologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera sociología"
  }

  measure: trabajo_social {
    type: max
    sql: CASE WHEN ${kind} = 'trabajo_social' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera trabajo social"
  }
  measure: licenciatura_en_educacion_primaria {
    type: max
    sql: CASE WHEN ${kind} = 'licenciatura_en_educacion_primaria' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera licenciatura en educación primaria"
  }

  measure: licenciatura_en_educacion_basica {
    type: max
    sql: CASE WHEN ${kind} = 'licenciatura_en_educacion_basica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera licenciatura en educación básica"
  }

  measure: optometria {
    type: max
    sql: CASE WHEN ${kind} = 'optometria' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera optometría"
  }

  measure: ingeniero_fintech {
    type: max
    sql: CASE WHEN ${kind} = 'ingeniero_fintech' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera ingeniero fintech"
  }

  measure: data_engineer {
    type: max
    sql: CASE WHEN ${kind} = 'data_engineer' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera data engineer"
  }


  set: detail {
    fields: [

      id,
      kind,
      value,
      name,
      medicina_veterinaria,
      agronomia,
      zootecnia,
      administracion_agropecuaria,
      agricultura,
      ganaderia,
      artes_plasticas,
      diseno_grafico,
      publicidad,
      diseno_de_moda,
      cinematografia,
      dramatica_teatro,
      danza,
      animacion_digital,
      musica,
      fotografia,
      diseno_de_interiores,
      ilustracion,
      diseno_industrial,
      cine_tv,
      educacion_fisica,
      derecho_y_afines,
      filosofia,
      teologia,
      formacion_relacionada_con_el_campo_militar,
      geografia,
      historia,
      lenguas_modernas,
      literatura,
      linguistica,
      psicologia,
      sociologia,
      trabajo_social,
      licenciatura_en_educacion_primaria,
      licenciatura_en_educacion_basica,
      optometria,
      ingeniero_fintech,
      data_engineer
    ]



  }
}
