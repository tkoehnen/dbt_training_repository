--{{ config(materialized='view') }}

with job_rcp as (
    select * from {{ ref('stg_agent_xml_rcp_0') }}
)
, final as (
    select
        job_rcp.job_id
        , ((job_rcp.job_id + 100000)*100) + job_rcp.rcp_spec_usergroup_index_1 as job_id_rcp_index
        , job_rcp.rcp_value_get
        , job_rcp.rcp_specificRecipients_flag
        , job_rcp.rcp_subscribers_flag
        , job_rcp.rcp_customize_flag
        , job_rcp.rcp_spec_value_get
        , job_rcp.rcp_spec_seq
        , job_rcp.rcp_spec_index
        , job_rcp.rcp_spec_index_1
        , job_rcp.rcp_spec_usergroup_type
        , job_rcp.rcp_spec_usergroup_seq
        , job_rcp.rcp_spec_usergroup_index
        , job_rcp.rcp_spec_usergroup_index_1
        , job_rcp.rcp_spec_usergroup_name
        , job_rcp.rcp_spec_usergroup_guid	 
    from  job_rcp
    order by job_id asc, job_id_rcp_index asc
)

select * from final
