{% macro delete_ci_models(dbt_pr_id, materialization) %}

  {# -- Get the current GCP project and dataset from the dbt target configuration -- #}
  {% set project_id = target.project %}
  {% set dataset = target.schema %}

  {# -- Define table type based on the materialization input (either 'BASE TABLE' or 'VIEW') -- #}
  {% set table_type = 'BASE TABLE' if materialization == 'table' else 'VIEW' %}

  {# -- Construct the SQL query to find all CI-generated tables/views with the PR prefix -- #}
  {% set query %}
    SELECT table_schema, table_name
    FROM `{{ project_id }}.{{ dataset }}.INFORMATION_SCHEMA.TABLES`
    WHERE table_name LIKE 'pr_{{ dbt_pr_id }}_%'
      AND table_type = '{{ table_type }}'
  {% endset %}

  {# -- Execute the query and fetch the results -- #}
  {% call statement('get_ci_models', fetch_result=True) %}
    {{ query }}
  {% endcall %}

  {# -- Loop over the returned table names and drop each one -- #}
  {% for row in load_result('get_ci_models')['data'] %}
    {% set table_schema = row[0] %}      {# -- Extract schema name from result -- #}
    {% set table_name = row[1] %}        {# -- Extract table/view name from result -- #}

    {# -- Generate a DROP statement to delete the table/view -- #}
    {% call statement('drop_ci_model_' ~ loop.index) %}
      DROP {{ materialization.upper() }} IF EXISTS `{{ project_id }}.{{ table_schema }}.{{ table_name }}`
    {% endcall %}

    {# -- Log the deletion for visibility in dbt output -- #}
    {% do log("Dropped: " ~ table_name, info=true) %}
  {% endfor %}

{% endmacro %}
