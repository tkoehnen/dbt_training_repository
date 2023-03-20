--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_dlv_t') }}
)
, staged as (
    select
        job_id
        , dlvdest_value_get
        , dlvdest_dest_seq
        , dlvdest_dest_index
        , dlvdest_dest_index_1
        , dlvdest_dest_value_get
        , dlvdest_dest_category
    from source
)

select * from staged
