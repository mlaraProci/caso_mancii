    view: contact {
      derived_table: {
        sql: SELECT
                HEX(`participants`.`id`) AS id,
                `participants`.`name` as `Nombre`,
                `participants`.`email` as `Correo`,
                `participants`.`identification_type` as `Tipo_de_identificacion`,
                `participants`.`identification` as `Identificacion`,
                `socio_demographics`.`grade` AS `Grado`,
                `socio_demographics`.`cellphone` AS `Numero_telefonico`,
                `socio_demographics`.`city` AS `Ciudad`,
                `socio_demographics`.`school` AS `Colegio`,
                `socio_demographics`.`who_paid` AS `Quien_paga`,
                `socio_demographics`.`modality` AS `Modalidad`,
                `socio_demographics`.`choice` AS `Que_te_hace_elegir_una_universidad`
              FROM `participants`
              JOIN `socio_demographics`
              ON `socio_demographics`.`participant_id` = `participants`.`id`;
              ;;
      }

      # Dimensiones
      dimension: id {
        type: string
        sql: ${TABLE}.id ;;
      }

      dimension: Nombre {
        type: string
        sql: ${TABLE}.Nombre ;;
      }

      dimension: Correo {
        type: string
        sql: ${TABLE}.Correo ;;
      }

      dimension: Tipo_de_identificacion {
        type: string
        sql: ${TABLE}.Tipo_de_identificacion ;;
      }

      dimension: Identificacion {
        type: string
        sql: ${TABLE}.Identificacion ;;
      }

      dimension: Grado {
        type: string
        sql: ${TABLE}.Grado ;;
      }

      dimension: Numero_telefonico {
        type: string
        sql: ${TABLE}.Numero_telefonico ;;
      }

      dimension: Ciudad {
        type: string
        sql: ${TABLE}.Ciudad ;;
      }

      dimension: Colegio {
        type: string
        sql: ${TABLE}.Colegio ;;
      }

      dimension: Quien_paga {
        type: string
        sql: ${TABLE}.Quien_paga ;;
      }

      dimension: Modalidad {
        type: string
        sql: ${TABLE}.Modalidad ;;
      }

      dimension: Que_te_hace_elegir_una_universidad {
        type: string
        sql: ${TABLE}.Que_te_hace_elegir_una_universidad ;;
      }

      # Conjunto de campos detallados
      set: detail {
        fields: [
          id,
          Nombre,
          Correo,
          Tipo_de_identificacion,
          Identificacion,
          Grado,
          Numero_telefonico,
          Ciudad,
          Colegio,
          Quien_paga,
          Modalidad,
          Que_te_hace_elegir_una_universidad
        ]
      }
    }
