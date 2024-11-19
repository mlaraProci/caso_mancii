view: carreras {
  derived_table: {
    sql: SELECT
       HEX(`participants`.`id`) AS id, -- Convertimos el ID a formato hexadecimal
       LOWER(TRIM(`construct_metrics`.`kind`)) AS kind, -- Incluimos kind como una columna directa, normalizando el valor
       `construct_metrics_decimal`.`value` AS value -- Incluimos value como una columna directa
    FROM `constructs`
    JOIN `projects` ON `projects`.`id` = `constructs`.`project_id`
    JOIN `construct_metrics` ON `construct_metrics`.`construct_id` = `constructs`.`id`
    JOIN `participants` ON `participants`.`id` = `construct_metrics`.`participant_id`
    JOIN `construct_metrics_decimal` ON `construct_metrics`.`id` = `construct_metrics_decimal`.`metric_id`
    WHERE LOWER(TRIM(`projects`.`title`)) LIKE 'previous-test'
    AND LOWER(TRIM(`constructs`.`name`)) LIKE '%carreras%'
    AND `construct_metrics_decimal`.`value` > 0
    GROUP BY HEX(`participants`.`id`);;
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

  # Medidas para cada tipo de carrera basadas en `kind` usando MAX
  measure: administracion_agropecuaria {
    type: max
    sql: CASE WHEN ${kind} = 'administracion_agropecuaria' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera administración agropecuaria"
  }

  measure: agricultura {
    type: max
    sql: CASE WHEN ${kind} = 'agricultura' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera agricultura"
  }

  measure: agronomia {
    type: max
    sql: CASE WHEN ${kind} = 'agronomia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera agronomía"
  }

  measure: arquitectura {
    type: max
    sql: CASE WHEN ${kind} = 'arquitectura' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera arquitectura"
  }

  measure: artes_plasticas {
    type: max
    sql: CASE WHEN ${kind} = 'artes_plasticas' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera artes plásticas"
  }

  measure: bacteriologia {
    type: max
    sql: CASE WHEN ${kind} = 'bacteriologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera bacteriología"
  }

  measure: bibliotecologia {
    type: max
    sql: CASE WHEN ${kind} = 'bibliotecologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera bibliotecología"
  }

  measure: cinematografia {
    type: max
    sql: CASE WHEN ${kind} = 'cinematografia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera cinematografía"
  }

  measure: creador_de_contenido {
    type: max
    sql: CASE WHEN ${kind} = 'creador_de_contenido' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera creador de contenido"
  }

  measure: danza {
    type: max
    sql: CASE WHEN ${kind} = 'danza' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera danza"
  }

  measure: diseno_de_interiores {
    type: max
    sql: CASE WHEN ${kind} = 'diseno_de_interiores' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera diseño de interiores"
  }

  measure: diseno_de_moda {
    type: max
    sql: CASE WHEN ${kind} = 'diseno_de_moda' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera diseño de moda"
  }

  measure: diseno_grafico {
    type: max
    sql: CASE WHEN ${kind} = 'diseno_grafico' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera diseño gráfico"
  }

  measure: diseno_industrial {
    type: max
    sql: CASE WHEN ${kind} = 'diseno_industrial' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera diseño industrial"
  }

  measure: fotografia {
    type: max
    sql: CASE WHEN ${kind} = 'fotografia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera fotografía"
  }

  measure: ganaderia {
    type: max
    sql: CASE WHEN ${kind} = 'ganaderia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera ganadería"
  }

  measure: gastronomia {
    type: max
    sql: CASE WHEN ${kind} = 'gastronomia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera gastronomía"
  }

  measure: ilustracion {
    type: max
    sql: CASE WHEN ${kind} = 'ilustracion' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera ilustración"
  }

  measure: instrumentacion_quirurquica {
    type: max
    sql: CASE WHEN ${kind} = 'instrumentacion_quirurquica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera instrumentación quirúrgica"
  }

  measure: licenciatura_en_educacion_basica {
    type: max
    sql: CASE WHEN ${kind} = 'licenciatura_en_educacion_basica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera licenciatura en educación básica"
  }

  measure: medicina_veterinaria {
    type: max
    sql: CASE WHEN ${kind} = 'medicina_veterinaria' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera medicina veterinaria"
  }

  measure: odontologia {
    type: max
    sql: CASE WHEN ${kind} = 'odontologia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera odontología"
  }

  measure: quimica {
    type: max
    sql: CASE WHEN ${kind} = 'quimica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera química"
  }

  measure: salud_publica {
    type: max
    sql: CASE WHEN ${kind} = 'salud_publica' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera salud pública"
  }

  measure: terapias {
    type: max
    sql: CASE WHEN ${kind} = 'terapias' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera terapias"
  }

  measure: zootecnia {
    type: max
    sql: CASE WHEN ${kind} = 'zootecnia' THEN ${value} ELSE NULL END ;;
    description: "Valor máximo del tipo de carrera zootecnia"
  }

  set: detail {
    fields: [
      id,
      kind,
      value,
      administracion_agropecuaria,
      agricultura,
      agronomia,
      arquitectura,
      artes_plasticas,
      bacteriologia,
      bibliotecologia,
      cinematografia,
      creador_de_contenido,
      danza,
      diseno_de_interiores,
      diseno_de_moda,
      diseno_grafico,
      diseno_industrial,
      fotografia,
      ganaderia,
      gastronomia,
      ilustracion,
      instrumentacion_quirurquica,
      licenciatura_en_educacion_basica,
      medicina_veterinaria,
      odontologia,
      quimica,
      salud_publica,
      terapias,
      zootecnia
    ]
  }
}
