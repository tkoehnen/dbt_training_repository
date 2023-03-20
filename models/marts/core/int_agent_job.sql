--{{ config(materialized='view') }}

with job_reposd as (
    select * from {{ ref('stg_agent_reposd_job') }}
)
, job_xml as (
    select * from {{ ref('stg_agent_xml_job') }}
)
, final as (
    select 
        job_reposd.job_id
        , job_reposd.job_name
        , job_reposd.username
        , job_reposd.job_type
        , job_reposd.job_param
        , job_reposd.filepath_source
        , job_xml.dv_type
        , job_xml.dv_run_as
        , job_xml.dv_run_as_guid
    from job_reposd
        , job_xml
    where job_reposd.job_id = job_xml.job_id(+)
)

select * from final
order by job_id asc
