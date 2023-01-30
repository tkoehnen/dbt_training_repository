/*
{% macro grant_select(args) %}

{% endmacro %}



{% macro grant_select(schema, role) %}

    {% set name %}
        grant usage on schema {{ schema }} to role {{ role }};
    {% endset %}

{% endmacro %}



{% macro grant_select(schema, role) %}

    {% set name %}
        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in schema {{ schema}} to role {{ role }};
        grant select on all views in schema {{ schema }} to role {{ role }};
    {% endset %}

{% endmacro %}



{% macro grant_select(schema, role) %}

    {% set query %}
        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in schema {{ schema}} to role {{ role }};
        grant select on all views in schema {{ schema }} to role {{ role }};
    {% endset %}

{% endmacro %}



{% macro grant_select(schema, role) %}

    {% set query_name %}
        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in schema {{ schema }} to role {{ role }};
        grant select on all views in schema {{ schema }} to role {{ role }};
    {% endset %}

    {% do run_query(query_name)%}

{% endmacro %}



{{ target.name }}
{{ target.role }}
{{ target.schema }}

{% macro grant_select(schema=target.schema, role= target.role) %}

    {% set query_name %}
        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in schema {{ schema}} to role {{ role }};
        grant select on all views in schema {{ schema }} to role {{ role }};
    {% endset %}

    {% do run_query(query_name)%}

{% endmacro %}


--To run this macro independent of any model, use the following command
-- 'dbt run-operation grant_select'



{% macro grant_select(schema=target.schema, role=target.role) %}

    {% set query_name %}
    grant usage on schema {{ schema }} to role {{ role }};
    grant select on all tables in schema {{ schema }} to role {{ role }};
    grant select on all views in schema {{ schema }} to role {{ role }};
    {% endset %}


    {{ log('Granting select on all tables and views in schema ' ~ schema ~ ' to role ' ~ role, info=True) }}
    {% do run_query(query_name) %}
    {{ log('Privileges granted!', info=True) }}

{% endmacro %}

*/
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
/*

*/
/*
{% macro name()%}

{% set query %}

{% end set %}

{% endnames %}
*/
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------