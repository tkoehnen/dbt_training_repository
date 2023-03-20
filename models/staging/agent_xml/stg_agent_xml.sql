--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_table') }}
),
staged as (
    select
        xmldata
    from source
)

select * from staged
