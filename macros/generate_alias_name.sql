{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
    {%- if target.name == 'ci' -%}
        {{ 'pr_' ~ env_var("DBT_PR_ID") ~ '_' ~ node.name }}
    {%- else -%}
        {%- if custom_alias_name is none -%}
            {%- if env_var("DBT_FEDID", "") != "" -%}
                {{ node.name ~ '_' ~ env_var("DBT_FEDID") }}
            {%- else -%}
                {{ node.name }}
            {%- endif -%}
        {%- else -%}
            {{ custom_alias_name | trim }}
        {%- endif -%}
    {%- endif -%}
{%- endmacro %}
