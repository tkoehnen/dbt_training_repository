--{{ config(materialized='view') }}

with job_dlv as (
    select * from {{ ref('stg_agent_xml_dlv') }}
)
, final as (
    select
        job_dlv.job_id
        , ((job_dlv.job_id + 100000)*100) + job_dlv.dlvdest_dest_index_1 as job_id_dest_index
        , job_dlv.dlvdest_value_get
        , job_dlv.dlvdest_dest_seq
        , job_dlv.dlvdest_dest_index
        , job_dlv.dlvdest_dest_index_1
        , job_dlv.dlvdest_dest_value_get
        , job_dlv.dlvdest_dest_category
    from  job_dlv
    order by job_id asc, job_id_dest_index asc
)

select * from final
