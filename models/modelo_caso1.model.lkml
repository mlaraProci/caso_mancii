connection: "vocational_test"

# include all the views
include: "/views/**/*.view.lkml"

datagroup: modelo_caso1_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: modelo_caso1_default_datagroup
##################################################################
explore: consulta_1 {}

explore: personalidades {}

explore: personalidades3 {}

explore: tipos_de_aprendizaje {}

explore: aprendizaje {}

explore: personalidad2 {}

explore: parent_responses {
  view_name: parent_responses
}


explore: areas_de_conocimientov2 {
}
explore: areas_de_conocimientov3 {
}

explore: type_of_learning {}

explore: VistaTypesPersonas {}

explore: personality {}

explore: carreras {}

explore: carrerasS {}

explore: carreras2 {}

explore:  career_frequencies{}

explore: contact {}

explore: inteligencias {}

explore: Types {}

explore: aprendizaje_tipos{}

explore: areas_de_conocimiento {}

explore: valores {}

explore: estadisticas_agregadas_para_personalidades {}

explore: estadisticas_agregadas_para_tipos_de_aprendizaje {}

explore: estadisticas_agregadas_para_carreras{}

explore: estadisticas_agregadas_para_inteligencias {}

explore: estadisticas_agregadas_para_areas_de_conocimiento {}

explore: estadisticas_agregadas_para_valores {}

explore: sectionals {}

###############################################################
explore: analysis_parameters {
  join: analysis_results {
    type: left_outer
    sql_on: ${analysis_parameters.analysis_result_id} = ${analysis_results.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${analysis_results.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: analysis_results {
  join: questions {
    type: left_outer
    sql_on: ${analysis_results.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: analysis_types {}

explore: answer_boolean {
  join: answers {
    type: left_outer
    sql_on: ${answer_boolean.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_date {
  join: answers {
    type: left_outer
    sql_on: ${answer_date.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_decimal {
  join: answers {
    type: left_outer
    sql_on: ${answer_decimal.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_integer {
  join: answers {
    type: left_outer
    sql_on: ${answer_integer.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_json {
  join: answers {
    type: left_outer
    sql_on: ${answer_json.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_metrics {
  join: answers {
    type: left_outer
    sql_on: ${answer_metrics.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_range {
  join: answers {
    type: left_outer
    sql_on: ${answer_range.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answer_text {
  join: answers {
    type: left_outer
    sql_on: ${answer_text.answer_id} = ${answers.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: answers {
  join: participants {
    type: left_outer
    sql_on: ${answers.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: questions {
    type: left_outer
    sql_on: ${answers.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: attendent {
  join: participants {
    type: left_outer
    sql_on: ${attendent.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }
}

explore: comparative_fit_index {
  join: constructs {
    type: left_outer
    sql_on: ${comparative_fit_index.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: concurrent_correlation_coefficient {
  join: questions {
    type: left_outer
    sql_on: ${concurrent_correlation_coefficient.questions_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: construct_metrics {
  join: constructs {
    type: left_outer
    sql_on: ${construct_metrics.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${construct_metrics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: construct_metrics_boolean {}

explore: construct_metrics_date {}

explore: construct_metrics_decimal {}

explore: construct_metrics_integer {}

explore: construct_metrics_json {}

explore: construct_metrics_range {}

explore: constructs {
  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: content_validity_index {
  join: constructs {
    type: left_outer
    sql_on: ${content_validity_index.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: convergence_divergence_correlation {
  join: constructs {
    type: left_outer
    sql_on: ${convergence_divergence_correlation.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: cronbach_alpha {
  join: constructs {
    type: left_outer
    sql_on: ${cronbach_alpha.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: devices {
  join: participants {
    type: left_outer
    sql_on: ${devices.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: socio_demographics {
    type: left_outer
    sql_on: ${socio_demographics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: construct_metrics {
    type: left_outer
    sql_on: ${participants.id} = ${construct_metrics.participant_id} ;;
    relationship: one_to_many
  }

  join: constructs {
    type: left_outer
    sql_on: ${construct_metrics.construct_id} = ${constructs.id} ;;
    relationship: one_to_many
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }

  join: project_clients {
    type: left_outer
    sql_on: ${projects.id} = ${project_clients.project_id} ;;
    relationship: one_to_many
  }

  join: clients  {
    type: left_outer
    sql_on: ${project_clients.client_id} = ${clients.id} ;;
    relationship: one_to_many
  }

  join: sectionals {
    type:  left_outer
    sql_on:  ${socio_demographics.sectional_id} = ${sectionals.id};;
    relationship: one_to_many
  }

  sql_always_where:
  ${clients.acronym} LIKE CONCAT('%',
  '{% if _user_attributes['client_acronym'] %}{{ _user_attributes["client_acronym"] | escape }}{% else %}%%{% endif %}',
  '%')
  {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
    {% assign cities = _user_attributes['city'] | split: ',' %}

    AND (
      {% assign conditions = '' %}
      {% for c in cities %}
        {% assign clean_city = c | strip | escape %}
        {% assign condition = "${socio_demographics.city} LIKE CONCAT('%', '" | append: clean_city | append: "', '%')" %}
        {% if forloop.first %}
          {% assign conditions = condition %}
        {% else %}
          {% assign conditions = conditions | append: ' OR ' | append: condition %}
        {% endif %}
      {% endfor %}
      {{ conditions }}
      )
  {% endif %}
  {% if _user_attributes['school'] != null and _user_attributes['school'] != "" %}
  AND ${socio_demographics.school} LIKE CONCAT('%', '{{ _user_attributes['school'] | escape }}', '%')
  {% endif %}
  {% if _user_attributes['sectional'] != null and _user_attributes['sectional'] != "" %}
  AND ${sectionals.name} LIKE CONCAT('%', '{{ _user_attributes['sectional'] | escape }}', '%')
  {% endif %};;
}

explore: discrimination_index {
  join: questions {
    type: left_outer
    sql_on: ${discrimination_index.questions_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: equivalence_coefficient {
  join: constructs {
    type: left_outer
    sql_on: ${equivalence_coefficient.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: g_coefficient {
  join: constructs {
    type: left_outer
    sql_on: ${g_coefficient.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: interaction_metrics {
  join: constructs {
    type: left_outer
    sql_on: ${interaction_metrics.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${interaction_metrics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: intraclass_correlation_coefficient {
  join: constructs {
    type: left_outer
    sql_on: ${intraclass_correlation_coefficient.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: item_functioning_differences {
  join: questions {
    type: left_outer
    sql_on: ${item_functioning_differences.questions_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: locations {
  join: devices {
    type: left_outer
    sql_on: ${locations.devices_id} = ${devices.id} ;;
    relationship: many_to_one
  }

  join: interaction_metrics {
    type: left_outer
    sql_on: ${devices.interaction_metrics_id} = ${interaction_metrics.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${interaction_metrics.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${interaction_metrics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: measurement_scales {}

explore: metrics_parameters {
  join: construct_metrics {
    type: left_outer
    sql_on: ${metrics_parameters.construct_metrics_id} = ${construct_metrics.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${construct_metrics.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${construct_metrics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: participants {
  join: socio_demographics {
    type: left_outer
    sql_on: ${socio_demographics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }
  join: construct_metrics {
    type: left_outer
    sql_on: ${participants.id} = ${construct_metrics.participant_id} ;;
    relationship: one_to_many
  }

  join: constructs {
    type: left_outer
    sql_on: ${construct_metrics.construct_id} = ${constructs.id} ;;
    relationship: one_to_many
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: one_to_many
  }

  join: project_clients {
    type: left_outer
    sql_on: ${projects.id} = ${project_clients.project_id} ;;
    relationship: one_to_many
  }

  join: clients  {
    type: left_outer
    sql_on: ${project_clients.client_id} = ${clients.id} ;;
    relationship: one_to_many
  }

  join: sectionals {
    type:  left_outer
    sql_on:  ${socio_demographics.sectional_id} = ${sectionals.id};;
    relationship: one_to_many
  }

  sql_always_where:
    ${clients.acronym} LIKE CONCAT('%',
    '{% if _user_attributes['client_acronym'] %}{{ _user_attributes["client_acronym"] | escape }}{% else %}%%{% endif %}',
    '%')
    {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
      {% assign cities = _user_attributes['city'] | split: ',' %}

      AND (
        {% assign conditions = '' %}
        {% for c in cities %}
          {% assign clean_city = c | strip | escape %}
          {% assign condition = "${socio_demographics.city} LIKE CONCAT('%', '" | append: clean_city | append: "', '%')" %}
          {% if forloop.first %}
            {% assign conditions = condition %}
          {% else %}
            {% assign conditions = conditions | append: ' OR ' | append: condition %}
          {% endif %}
        {% endfor %}
        {{ conditions }}
      )
    {% endif %}
    {% if _user_attributes['school'] != null and _user_attributes['school'] != "" %}
      AND ${socio_demographics.school} LIKE CONCAT('%', '{{ _user_attributes['school'] | escape }}', '%')
    {% endif %}
    {% if _user_attributes['sectional'] != null and _user_attributes['sectional'] != "" %}
      AND ${sectionals.name} LIKE CONCAT('%', '{{ _user_attributes['sectional'] | escape }}', '%')
    {% endif %};;
}

explore: predictive_correlation_coefficient {
  join: questions {
    type: left_outer
    sql_on: ${predictive_correlation_coefficient.questions_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: project_metrics {
  join: projects {
    type: left_outer
    sql_on: ${project_metrics.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: projects {}

explore: question_options {
  join: questions {
    type: left_outer
    sql_on: ${question_options.question_id} = ${questions.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: question_types {}

explore: questions {
  join: constructs {
    type: left_outer
    sql_on: ${questions.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
  join: answers {
    type: left_outer
    sql_on: ${questions.id} = ${answers.question_id} ;;
    relationship: many_to_one
  }
}

explore: root_mean_square_error {
  join: constructs {
    type: left_outer
    sql_on: ${root_mean_square_error.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: utm_parameters {
  join: devices {
    type: left_outer
    sql_on: ${utm_parameters.devices_id} = ${devices.id} ;;
    relationship: many_to_one
  }

  join: interaction_metrics {
    type: left_outer
    sql_on: ${devices.interaction_metrics_id} = ${interaction_metrics.id} ;;
    relationship: many_to_one
  }

  join: constructs {
    type: left_outer
    sql_on: ${interaction_metrics.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: participants {
    type: left_outer
    sql_on: ${interaction_metrics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: validity_evidence {
  join: constructs {
    type: left_outer
    sql_on: ${validity_evidence.construct_id} = ${constructs.id} ;;
    relationship: many_to_one
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: many_to_one
  }
}

explore: socio_demographics {
  join: participants {
    type: left_outer
    sql_on: ${socio_demographics.participant_id} = ${participants.id} ;;
    relationship: many_to_one
  }

  join: construct_metrics {
    type: left_outer
    sql_on: ${participants.id} = ${construct_metrics.participant_id} ;;
    relationship: one_to_many
  }

  join: constructs {
    type: left_outer
    sql_on: ${construct_metrics.construct_id} = ${constructs.id} ;;
    relationship: one_to_many
  }

  join: projects {
    type: left_outer
    sql_on: ${constructs.project_id} = ${projects.id} ;;
    relationship: one_to_many
  }

  join: project_clients {
    type: left_outer
    sql_on: ${projects.id} = ${project_clients.project_id} ;;
    relationship: one_to_many
  }

  join: clients  {
    type: left_outer
    sql_on: ${project_clients.client_id} = ${clients.id} ;;
    relationship: one_to_many
  }

  join: sectionals {
    type:  left_outer
    sql_on:  ${socio_demographics.sectional_id} = ${sectionals.id};;
    relationship: one_to_many
  }

  sql_always_where:
    ${clients.acronym} LIKE CONCAT('%',
    '{% if _user_attributes['client_acronym'] %}{{ _user_attributes["client_acronym"] | escape }}{% else %}%%{% endif %}',
    '%')
    {% if _user_attributes['city'] != null and _user_attributes['city'] != '' %}
      {% assign cities = _user_attributes['city'] | split: ',' %}

      AND (
        {% assign conditions = '' %}
        {% for c in cities %}
          {% assign clean_city = c | strip | escape %}
          {% assign condition = "${socio_demographics.city} LIKE CONCAT('%', '" | append: clean_city | append: "', '%')" %}
          {% if forloop.first %}
            {% assign conditions = condition %}
          {% else %}
            {% assign conditions = conditions | append: ' OR ' | append: condition %}
          {% endif %}
        {% endfor %}
        {{ conditions }}
      )
    {% endif %}
    {% if _user_attributes['school'] != null and _user_attributes['school'] != "" %}
      AND ${socio_demographics.school} LIKE CONCAT('%', '{{ _user_attributes['school'] | escape }}', '%')
    {% endif %}
    {% if _user_attributes['sectional'] != null and _user_attributes['sectional'] != "" %}
    AND ${sectionals.name} LIKE CONCAT('%', '{{ _user_attributes['sectional'] | escape }}', '%')
    {% endif %}
    ;;
}
