--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_table') }}
)
, staged as (
	select
	  GET(xmldata, '@jobID')::integer as job_id
        --, rcp.*
        , GET( rcp.value, '@' )::STRING as rcp_value_get
        , GET( rcp.value, '@specificRecipients' )::BOOLEAN as rcp_specificRecipients_flag
        , GET( rcp.value, '@subscribers' )::BOOLEAN as rcp_subscribers_flag
        , GET( rcp.value, '@customize' )::BOOLEAN as rcp_customize_flag
            --, rcp_spec.*
            , GET( rcp_spec.value, '@' )::STRING as rcp_spec_value_get
            , rcp_spec.seq as rcp_spec_seq
            , rcp_spec.index as rcp_spec_index
            , rcp_spec.index + 1 as rcp_spec_index_1
                --, rcp_spec_usergroup.*
                , GET( rcp_spec_usergroup.value, '@' )::STRING as rcp_spec_usergroup_type
                , rcp_spec_usergroup.seq as rcp_spec_usergroup_seq
                --, rcp_spec_usergroup.key as rcp_spec_usergroup_key
                --, rcp_spec_usergroup.path as rcp_spec_usergroup_path
                , rcp_spec_usergroup.index as rcp_spec_usergroup_index
                , rcp_spec_usergroup.index +1 as rcp_spec_usergroup_index_1
                , GET( rcp_spec_usergroup.value, '@name' )::STRING as rcp_spec_usergroup_name
                , GET( rcp_spec_usergroup.value, '@guid' )::STRING as rcp_spec_usergroup_guid
from  source
	, lateral FLATTEN(source.xmldata:"$") dv                            --dataVisibility
    , lateral FLATTEN(source.xmldata:"$") rcp                           --recipients
        , lateral FLATTEN(rcp.value:"$") rcp_spec                           --specificRecipients
            , lateral FLATTEN(rcp_spec.value:"$") rcp_spec_usergroup            --user & group
where 1=1
  and GET( dv.value, '@' ) = 'saw:dataVisibility'
  and GET( rcp.value, '@' ) = 'saw:recipients'
    and GET( rcp_spec.value, '@' ) = 'saw:specificRecipients'
      and GET( rcp_spec_usergroup.value, '@' ) in ('saw:user', 'saw:group')
)

select * from staged
order by job_id asc
