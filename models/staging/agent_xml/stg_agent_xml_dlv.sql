--{{ config(materialized='view') }}

with source as (
    select * from {{ source('agent_xml', 'xml_agent_test_table') }}
)
, staged as (
	select
	  GET(xmldata, '@jobID')::integer as job_id
	--, GET(xmldata, '@priority')::STRING as priority
    --, GET(xmldata, '@version')::STRING as version
        --, dlvdest.*
            , GET( dlvdest.value, '@' )::STRING as dlvdest_value_get
            , dlvdest_dest.seq as dlvdest_dest_seq
            --, dlvdest_dest.path as dlvdest_dest_path
        , dlvdest_dest.index as dlvdest_dest_index
        , dlvdest_dest.index + 1 as dlvdest_dest_index_1
    	--, GET( dlvdest.value, '@' ) || '/' || GET( dlvdest_dest.value, '@' )::STRING as dlvdest_dest_path_value_get
            --, dlvdest_dest.*
            , GET( dlvdest_dest.value, '@' )::STRING as dlvdest_dest_value_get
            , GET( dlvdest_dest.value, '@category' )::STRING as dlvdest_dest_category
from  source
    , lateral FLATTEN(source.xmldata:"$") dlvdest               --deliveryDestinations
    	, lateral FLATTEN(dlvdest.value:"$") dlvdest_dest           --deliveryDestinations/destinations
where 1=1
  and GET( dlvdest.value, '@' ) = 'saw:deliveryDestinations'
    and GET( dlvdest_dest.value, '@' ) = 'saw:destination'
)

select * from staged
order by job_id asc
