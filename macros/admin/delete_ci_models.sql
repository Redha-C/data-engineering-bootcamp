{% macro delete_ci_models(dbt_pr_id, materialization) -%}

    {% call statement('get_pr_tables', fetch_result=True) %}
        SHOW {{ materialization }}s FROM {{ schema }}
        LIKE 'pr_{{ dbt_pr_id }}_{{ project_name }}*';

    {% endcall %}

    {%- for to_delete in load_result('get_pr_tables')['data'] %}
    {% call statement() -%}
      {% do log(to_delete, info=true) %}
      drop {{ materialization }} if exists {{ to_delete[0] }}.{{ to_delete[1] }} ;
    {%- endcall %}
  {%- endfor %}


{%- endmacro %}
