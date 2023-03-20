--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_table') }}
)
, staged as (
    select
	  GET(xmldata, '@jobID')::integer as job_id
        --, email.*
        , GET( email.value, '@' )::STRING as email_value_get
        , email.seq as email_seq
        , email.index as email_index
            --, emailrcp.*
            , GET( emailrcp.value, '@' )::STRING as emailrcp_value_get
            , emailrcp.seq as emailrcp_seq
            --, emailrcp.key as emailrcp_key
            --, emailrcp.path as emailrcp_path
            , emailrcp.index as emailrcp_index
            , emailrcp.index + 1 as emailrcp_index_1
            , GET( emailrcp.value, '@address' )::STRING as emailrcp_address
            , GET( emailrcp.value, '@type' )::STRING as emailrcp_type
from  source
	, lateral FLATTEN(source.xmldata:"$") dv            --dataVisibility
    , lateral FLATTEN(source.xmldata:"$") email         --emailRecipients
        , lateral FLATTEN(email.value:"$") emailrcp         --emailRecipient
where 1=1
  and GET( dv.value, '@' ) = 'saw:dataVisibility'
  and GET( email.value, '@' ) = 'saw:emailRecipients'
    and GET( emailrcp.value, '@' ) = 'saw:emailRecipient'   
)

select * from staged
order by job_id asc
