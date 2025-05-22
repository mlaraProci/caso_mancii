view: carrerasS {
  derived_table: {
    sql:
      WITH RECURSIVE numbers AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM numbers WHERE n < 3
      ),

      extracted_careers AS (
      SELECT
      sd.id AS id,
      sd.school AS school,
      sd.city AS city,
      sd.country AS country,
      sd.grade AS grade,
      sd.participant_id AS participant_id,
      TRIM(LOWER(REGEXP_REPLACE(REGEXP_SUBSTR(sd.preferred_careers, '[^",]+', 1, n), '[\\[\\]"]', ''))) AS career_raw
      FROM socio_demographics sd
      JOIN (
      SELECT
      participant_id,
      construct_id,
      ROW_NUMBER() OVER (PARTITION BY participant_id ORDER BY id DESC) AS rn
      FROM construct_metrics
      ) cm ON cm.participant_id = sd.participant_id AND cm.rn = 1
      JOIN constructs c ON c.id = cm.construct_id
      JOIN projects pr ON pr.id = c.project_id
      JOIN project_clients pc ON pr.id = pc.project_id
      JOIN clients cl ON pc.client_id = cl.id
      CROSS JOIN numbers
      WHERE
      sd.preferred_careers NOT IN ('Not Applicable', 'Not Answered', 'No sé', 'no se', 'no se que estudiar todavía', 'nose aun', 'aun no se')
      AND REGEXP_SUBSTR(sd.preferred_careers, '[^",]+', 1, n) IS NOT NULL
      ),

      cleaned_careers AS (
      SELECT
      id,
      city,
      country,
      school,
      grade,
      REGEXP_REPLACE(
      REGEXP_REPLACE(
      LOWER(career_raw),
      '[áéíóúñü]',
      ''
      ),
      '[()\\.]',
      ''
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
        WHEN career_clean LIKE '%psicolog%' THEN 'psicología'
        WHEN career_clean LIKE '%derecho%' OR career_clean LIKE '%abogad%' THEN 'derecho'
        WHEN career_clean LIKE '%administracion%empres%' OR career_clean LIKE '%adm%empres%' THEN 'administración de empresas'
        WHEN career_clean LIKE '%negocio%internacional%' THEN 'negocios internacionales'
        WHEN career_clean LIKE '%ingenieria%sistema%' OR career_clean LIKE '%software%' THEN 'ingeniería de sistemas'
        WHEN career_clean LIKE '%marketing%' OR career_clean LIKE '%mercadotecnia%' THEN 'marketing'
        WHEN career_clean LIKE '%veterinari%' THEN 'veterinaria'
        WHEN career_clean LIKE '%diseño%grafic%' OR career_clean LIKE '%diseno%grafic%' THEN 'diseño gráfico'
        WHEN career_clean LIKE '%contadur%' THEN 'contabilidad'
        WHEN career_clean LIKE '%zootecn%' THEN 'zootecnia'
        WHEN career_clean LIKE '%turismo%' OR career_clean LIKE '%relaciones%tur%' THEN 'turismo'
        WHEN career_clean LIKE '%tripulante%' OR career_clean LIKE '%tcp%' OR career_clean LIKE '%sobrecargo%' THEN 'tripulante de cabina'
        WHEN career_clean LIKE '%trabajo%social%' OR career_clean LIKE '%sociloga%' OR career_clean LIKE '%relacion%public%' THEN 'trabajo social'
        WHEN career_clean LIKE '%topograf%' THEN 'topografía'
        WHEN career_clean LIKE '%literatura%' THEN 'literatura'
        WHEN career_clean LIKE '%teoria%musical%' OR career_clean LIKE '%teora%musical%' THEN 'teoría musical'
        WHEN career_clean LIKE '%militar%' OR career_clean LIKE '%soldado%' OR career_clean LIKE '%teniente%' OR career_clean LIKE '%oficial%policia%' OR career_clean LIKE '%policia%' THEN 'fuerza pública'
        WHEN career_clean LIKE '%tecnic%' OR career_clean LIKE '%soldadura%' OR career_clean LIKE '%refrigeracion%' THEN 'técnico industrial'
        WHEN career_clean LIKE '%tatuaje%' THEN 'tatuador'
        WHEN career_clean LIKE '%publicidad%' THEN 'publicidad'
        WHEN career_clean LIKE '%quimic%' THEN 'química'
        WHEN career_clean LIKE '%produccion%musical%' THEN 'producción musical'
        WHEN career_clean LIKE '%produccion%audiovisual%' THEN 'producción audiovisual'
        WHEN career_clean LIKE '%profesor%' OR career_clean LIKE '%maestr%' OR career_clean LIKE '%pedagog%' THEN 'educación'
        WHEN career_clean LIKE '%piloto%' THEN 'piloto'
        WHEN career_clean LIKE '%peluquer%' OR career_clean LIKE '%cosmetolog%' OR career_clean LIKE '%estetic%' THEN 'cosmetología y belleza'
        WHEN career_clean LIKE '%nutricion%' OR career_clean LIKE '%dietetica%' THEN 'nutrición'
        WHEN career_clean LIKE '%odontolog%' OR career_clean LIKE '%ortodoncia%' THEN 'odontología'
        WHEN career_clean LIKE '%paramedic%' THEN 'paramédico'
        WHEN career_clean LIKE '%pastel%' OR career_clean LIKE '%repost%' THEN 'pastelería y repostería'
        WHEN career_clean LIKE '%serigraf%' THEN 'serigrafía'
        WHEN career_clean LIKE '%neonatolog%' THEN 'neonatología'
        WHEN career_clean LIKE '%musica%' OR career_clean LIKE '%msica%' OR career_clean LIKE '%interpretacion instrumental%' THEN 'música'
        WHEN career_clean LIKE '%modelaje%' OR career_clean LIKE '%modelo%' OR career_clean LIKE '%moda%' THEN 'modelaje y moda'
        WHEN career_clean LIKE '%mercadeo%' OR career_clean LIKE '%marketing%' OR career_clean LIKE '%marketin%' THEN 'mercadeo y marketing'
        WHEN career_clean LIKE '%mecanica%' OR career_clean LIKE '%mecanic%' OR career_clean LIKE '%mecnica%' OR career_clean LIKE '%mecatr%' THEN 'ingeniería mecánica y afines'
        WHEN career_clean LIKE '%maquinaria pesada%' THEN 'operador maquinaria pesada'
        WHEN career_clean LIKE '%maquillaje%' OR career_clean LIKE '%lashista%' THEN 'cosmetología y belleza'
        WHEN career_clean LIKE '%matematic%' THEN 'matemáticas'
        WHEN career_clean LIKE '%maestra%' OR career_clean LIKE '%licenciatura%' OR career_clean LIKE '%licenciado%' THEN 'educación'
        WHEN career_clean LIKE '%lenguas%' OR career_clean LIKE '%idiomas%' OR career_clean LIKE '%inglés%' THEN 'lenguas extranjeras'
        WHEN career_clean LIKE '%informatica%' OR career_clean LIKE '%sistemas%' OR career_clean LIKE '%program%' THEN 'ingeniería de sistemas'
        WHEN career_clean LIKE '%criminolog%' THEN 'criminología'
        WHEN career_clean LIKE '%automotriz%' OR career_clean LIKE '%automotores%' THEN 'ingeniería automotriz'
        WHEN career_clean LIKE '%ingenieria civil%' OR career_clean LIKE '%ingeniero civil%' THEN 'ingeniería civil'
        WHEN career_clean LIKE '%ingenieria industrial%' OR career_clean LIKE '%ingeniero industrial%' THEN 'ingeniería industrial'
        WHEN career_clean LIKE '%ingenieria de sistemas%' OR career_clean LIKE '%ingeniero en sistemas%' OR career_clean LIKE '%ingenieria en sistemas%' THEN 'ingeniería de sistemas'
        WHEN career_clean LIKE '%ingenieria mecanica%' OR career_clean LIKE '%ingeniero mecanico%' OR career_clean LIKE '%ingenieria mecnica%' OR career_clean LIKE '%ingeniera mecanica%' THEN 'ingeniería mecánica'
        WHEN career_clean LIKE '%ingenieria de software%' OR career_clean LIKE '%ingenieria de sistemas%' THEN 'ingeniería de software'
        WHEN career_clean LIKE '%ingenieria electronica%' OR career_clean LIKE '%ingeniera electronica%' THEN 'ingeniería electrónica'
        WHEN career_clean LIKE '%ingenieria biomedica%' OR career_clean LIKE '%ingeniera biomedica%' THEN 'ingeniería biomédica'
        WHEN career_clean LIKE '%ingenieria agricola%' OR career_clean LIKE '%ingeniera agronoma%' OR career_clean LIKE '%ingeniera agropecuaria%' THEN 'ingeniería agrícola'
        WHEN career_clean LIKE '%ingenieria aeroespacial%' OR career_clean LIKE '%ingeniera aeroespacial%' THEN 'ingeniería aeroespacial'
        WHEN career_clean LIKE '%ingenieria ambiental%' OR career_clean LIKE '%ingeniera ambiental%' THEN 'ingeniería ambiental'
        WHEN career_clean LIKE '%ingenieria de procesos%' THEN 'ingeniería de procesos'
        WHEN career_clean LIKE '%ingenieria automatica%' OR career_clean LIKE '%ingenieria mecatronica%' THEN 'ingeniería mecatrónica'
        WHEN career_clean LIKE '%ingenieria biotecnologica%' THEN 'ingeniería biotecnología'
        WHEN career_clean LIKE '%ingenieria petrolera%' OR career_clean LIKE '%ingeniera petrolera%' THEN 'ingeniería petrolera'
        WHEN career_clean LIKE '%ingenieria nuclear%' THEN 'ingeniería nuclear'
        WHEN career_clean LIKE '%ingenieria electromecanica%' OR career_clean LIKE '%ingeniera electromecnica%' THEN 'ingeniería electromecánica'
        WHEN career_clean LIKE '%ingenieria industrial%' THEN 'ingeniería industrial'
        WHEN career_clean LIKE '%ingenieria de sonido%' THEN 'ingeniería de sonido'
        WHEN career_clean LIKE '%ingenieria de sistemas negocios%' THEN 'ingeniería de sistemas y negocios'
        WHEN career_clean LIKE '%ingenieria de sistemas ingeniera industrial%' THEN 'ingeniería de sistemas y ingeniería industrial'
        WHEN career_clean LIKE '%ingenieria de sistemas ingeniera industrial e idiomas%' THEN 'ingeniería de sistemas y ingeniería industrial con idiomas'
        WHEN career_clean LIKE '%biologa marina%' OR career_clean LIKE '%biología marina%' OR career_clean LIKE '%biologa%' THEN 'Biología Marina'
        WHEN career_clean LIKE '%gastro%' OR career_clean LIKE '%gastronomia%' THEN 'Gastronomía'
        WHEN career_clean LIKE '%futbol%' OR career_clean LIKE '%futbolista%' THEN 'Fútbol'
        WHEN career_clean LIKE '%fisioterapia%' OR career_clean LIKE '%fisioterapeuta%' THEN 'Fisioterapia'
        WHEN career_clean LIKE '%enfermera%' OR career_clean LIKE '%enfermería%' OR career_clean LIKE '%enfermera profesional%' OR career_clean LIKE '%enfermera jefe%' THEN 'Enfermería'
        WHEN career_clean LIKE '%educacion fisica%' OR career_clean LIKE '%educación física%' THEN 'Educación Física'
        WHEN career_clean LIKE '%arquitectura%' OR career_clean LIKE '%arquitecto%' THEN 'Arquitectura'
        WHEN career_clean LIKE '%derecho%' OR career_clean LIKE '%abogacía%' THEN 'Derecho'
        WHEN career_clean LIKE '%criminalistica%' OR career_clean LIKE '%criminalística%' OR career_clean LIKE '%criminologa%' OR career_clean LIKE '%criminología%' THEN 'Criminología'
        WHEN career_clean LIKE '%comunicacion social%' OR career_clean LIKE '%comunicación social%' OR career_clean LIKE '%periodismo%' THEN 'Comunicación Social y Periodismo'
        WHEN career_clean LIKE '%ciencias del deporte%' OR career_clean LIKE '%deportes%' OR career_clean LIKE '%ciencias de la recreación y del deporte%' THEN 'Ciencias del Deporte'
        WHEN career_clean LIKE '%ciencias sociales%' OR career_clean LIKE '%antropologia%' OR career_clean LIKE '%sociologia%' THEN 'Ciencias Sociales'
        WHEN career_clean LIKE '%arte%' OR career_clean LIKE '%bellas artes%' OR career_clean LIKE '%artes plásticas%' THEN 'Artes'
        WHEN career_clean LIKE '%astronomia%' OR career_clean LIKE '%astrónoma%' OR career_clean LIKE '%astrofísica%' THEN 'Astronomía'
        WHEN career_clean LIKE '%zootecnia%' OR career_clean LIKE '%biología marina%' THEN 'Zootecnia'
        WHEN career_clean LIKE '%odontologia%' OR career_clean LIKE '%odontología%' THEN 'Odontología'

      ELSE career_clean
      END AS carrera,
      GROUP_CONCAT(DISTINCT city ORDER BY city SEPARATOR ', ') AS city,
      GROUP_CONCAT(DISTINCT country ORDER BY country SEPARATOR ', ') AS country,
      GROUP_CONCAT(DISTINCT school ORDER BY school SEPARATOR ', ') AS school,
      GROUP_CONCAT(DISTINCT grade ORDER BY grade SEPARATOR ', ') AS grade,
      COUNT(*) AS frecuencia
      FROM cleaned_careers
      GROUP BY 1
      )

      SELECT
      carrera,
      city,
      country,
      school,
      grade,
      frecuencia,
      ROUND(frecuencia * 100.0 / SUM(frecuencia) OVER (), 2) AS porcentaje
      FROM grouped_careers
      ORDER BY frecuencia DESC ;;
  }

  dimension: carrera {
    type: string
    sql: ${TABLE}.carrera ;;
  }

  dimension: frecuencia {
    type: number
    sql: ${TABLE}.frecuencia ;;
  }

  dimension: porcentaje {
    type: number
    sql: ${TABLE}.porcentaje ;;
    value_format_name: percent_2
  }

  dimension: cities {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: countries {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: schools {
    type: string
    sql: ${TABLE}.school ;;
  }

  dimension: grades {
    type: string
    sql: ${TABLE}.grade ;;
    description: "Grado escolar relacionado a la carrera"
  }

  measure: total_menciones {
    type: sum
    sql: ${frecuencia} ;;
  }
}
