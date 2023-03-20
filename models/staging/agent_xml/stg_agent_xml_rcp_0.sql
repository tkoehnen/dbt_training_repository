--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_rcp_t') }}
)
, staged as (
    select
         job_id
        , rcp_value_get
        , rcp_specificRecipients_flag
        , rcp_subscribers_flag
        , rcp_customize_flag
        , rcp_spec_value_get
        , rcp_spec_seq
        , rcp_spec_index
        , rcp_spec_index_1
        , rcp_spec_usergroup_type	    --get from lateral flattened subset alias.column
        , rcp_spec_usergroup_seq
        , rcp_spec_usergroup_index
        , rcp_spec_usergroup_index_1
        , rcp_spec_usergroup_name	    --get from lateral flattened subset alias.column
        , rcp_spec_usergroup_guid	    --get from lateral flattened subset alias.column
    from source
)

select * from staged
