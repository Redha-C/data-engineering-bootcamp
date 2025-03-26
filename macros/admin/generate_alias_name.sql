{% macro generate_alias_name(custom_alias_name=none, node=none) -%}
    
    {# -- CASE 1: When target is "ci", we want to prefix table names with the PR ID -- #}
    {%- if target.name == 'ci' -%}
        {{ 'pr_' ~ env_var("DBT_PR_ID") ~ '_' ~ node.name }}

    {# -- CASE 2: In all other environments (dev, prod, etc.) -- #}
    {%- else -%}
        
        {# -- If no custom alias is provided -- #}
        {%- if custom_alias_name is none -%}
            
            {# -- Optional: Add a suffix if DBT_FEDID environment variable is set (e.g. for federation/multi-user dev) -- #}
            {%- if env_var("DBT_FEDID", "") != "" -%}
                {{ node.name ~ '_' ~ env_var("DBT_FEDID") }}
            
            {# -- Otherwise, just use the node (model) name -- #}
            {%- else -%}
                {{ node.name }}
            {%- endif -%}
        
        {# -- CASE 3: If a custom alias is explicitly passed to the model -- #}
        {%- else -%}
            {{ custom_alias_name | trim }}  {# -- Trim whitespace just in case -- #}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}
