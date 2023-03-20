--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_job_t') }}
)
, staged as (
    select
        job_id
	    , priority
        , version
        , xmlns_saw
        , xmlns_cond
        , xmlns_sawx
        , xmlns_xsi
        , sched_value_get
        , sched_seq
        , sched_index
        , sched_disabled	--get from lateral flattened subset alias.column
        , sched_timezone	--get from lateral flattened subset alias.column
        , dv_seq
        , dv_index
        , dv_value_get
        , dv_type	--get from lateral flattened subset alias.column
        , dv_run_as	--get from lateral flattened subset alias.column
        , dv_run_as_guid	--get from lateral flattened subset alias.column
        , rcp_value_get
        , rcp_seq
        , rcp_index
        , rcp_specificRecipients_flag
        , rcp_subscribers_flag
        , rcp_customize_flag
    from source
)

select * from staged
