--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_table') }}
)
, staged as (
    select
	  GET(xmldata, '@jobID')::integer as job_id
	, GET(xmldata, '@priority')::STRING as priority
    , GET(xmldata, '@version')::STRING as version
    , GET(xmldata, '@xmlns:saw')::STRING as xmlns_saw
    , GET(xmldata, '@xmlns:cond')::STRING as xmlns_cond
    , GET(xmldata, '@xmlns:sawx')::STRING as xmlns_sawx
    , GET(xmldata, '@xmlns:xsi')::STRING as xmlns_xsi
        --, sched.*
        , GET( sched.value, '@' )::STRING as sched_value_get
        , sched.seq as sched_seq
        , sched.index as sched_index
        --, sched.index + 1 as sched_index_1
        , GET( sched.value, '@disabled' )::BOOLEAN as sched_disabled
        , GET( sched.value, '@timeZoneId' )::STRING as sched_timezone
        --, dv.*
        , dv.seq as dv_seq
        , dv.index as dv_index
        --, dv.index + 1 as dv_index_1
        , GET( dv.value, '@' )::STRING as dv_value_get
        , GET( dv.value, '@type' )::STRING as dv_type
        , GET( dv.value, '@runAs' )::STRING as dv_run_as
        , GET( dv.value, '@runAsGuid' )::STRING as dv_run_as_guid
        --, rcp.*
        , GET( rcp.value, '@' )::STRING as rcp_value_get
        , rcp.seq as rcp_seq
        , rcp.index as rcp_index
        --, rcp.index + 1 as rcp_index_1
        , GET( rcp.value, '@specificRecipients' )::BOOLEAN as rcp_specificRecipients_flag
        , GET( rcp.value, '@subscribers' )::BOOLEAN as rcp_subscribers_flag
        , GET( rcp.value, '@customize' )::BOOLEAN as rcp_customize_flag
from  source
	, lateral FLATTEN(source.xmldata:"$") dv        --dataVisibility
    , lateral FLATTEN(source.xmldata:"$") sched     --schedule
    , lateral FLATTEN(source.xmldata:"$") rcp       --recipients
where 1=1
  and GET( dv.value, '@' ) = 'saw:dataVisibility'
  and GET( sched.value, '@' ) = 'saw:schedule'
  and GET( rcp.value, '@' ) = 'saw:recipients'
)

select * from staged
order by job_id asc
