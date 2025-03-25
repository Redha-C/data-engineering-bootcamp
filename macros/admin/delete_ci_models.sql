{% macro delete_ci_models(dbt_pr_id, materialization) %}
  {% set project_id = target.project %}
  {% set dataset = target.schema %}
  {% set table_type = 'BASE TABLE' if materialization == 'table' else 'VIEW' %}

  {% set query %}
    SELECT table_schema, table_name
    FROM `{{ project_id }}.{{ dataset }}.INFORMATION_SCHEMA.TABLES`
    WHERE table_name LIKE 'pr_{{ dbt_pr_id }}_%'
      AND table_type = '{{ table_type }}'
  {% endset %}

  {% call statement('get_ci_models', fetch_result=True) %}
    {{ query }}
  {% endcall %}

  {% for row in load_result('get_ci_models')['data'] %}
    {% set table_schema = row[0] %}
    {% set table_name = row[1] %}

    {% call statement('drop_ci_model_' ~ loop.index) %}
      DROP {{ materialization.upper() }} IF EXISTS `{{ project_id }}.{{ table_schema }}.{{ table_name }}`
    {% endcall %}

    {% do log("Dropped: " ~ table_name, info=true) %}
  {% endfor %}

{% endmacro %}
