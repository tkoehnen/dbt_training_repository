--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_email_t') }}
)
, staged as (
    select
        job_id
        , email_value_get
        , email_seq
        , email_index
        , emailrcp_value_get
        , emailrcp_seq
        , emailrcp_index
        , emailrcp_index_1
        , emailrcp_address
        , emailrcp_type
    from source
)

select * from staged
