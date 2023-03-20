--{{ config(materialized='view') }}

with job_reposd as (
    select * from {{ ref('stg_agent_reposd_job') }}
)
, job_xml as (
    select * from {{ ref('stg_agent_xml_job') }}
)

, job_dlv as (
    select * from {{ ref('stg_agent_xml_dlv') }}
)
, job_dlv_count as (
    select distinct
        job_id
        , count(*) as count
    from job_dlv
    group by 1
)
, job_rcp as (
    select * from {{ ref('stg_agent_xml_rcp') }}
)
, job_rcp_count as (
    select distinct
        job_id
        , count(*) as count
    from job_rcp
    group by 1
)
, job_email as (
    select * from {{ ref('stg_agent_xml_email') }}
)
, job_email_count as (
    select distinct
        job_id
        , count(*) as count
    from job_email
    group by 1
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
        , job_dlv_count.count as specific_delivery_dest_count        
        , job_rcp_count.count as specific_recipient_count
        , job_email_count.count as specific_email_recipient_count
        , count(distinct job_reposd.job_id) as distinct_job_count
        , case when job_reposd.job_type = 'Agent' then count(distinct job_reposd.job_id) else 0 end as distinct_job_agent_count
        , case when job_reposd.job_type = 'Email' then count(distinct job_reposd.job_id) else 0 end as distinct_job_email_count
        , case when job_xml.dv_type = 'recipient' then count(distinct job_reposd.job_id) else 0 end as distinct_recipient_type_count
        , case when job_xml.dv_type = 'runAsUser' then count(distinct job_reposd.job_id) else 0 end as distinct_runasuser_type_count
    from job_reposd
        , job_xml
        , job_dlv_count
        , job_rcp_count
        , job_email_count
    where job_reposd.job_id = job_xml.job_id(+)
        and job_reposd.job_id = job_dlv_count.job_id(+)
        and job_reposd.job_id = job_rcp_count.job_id(+)
        and job_reposd.job_id = job_email_count.job_id(+)
    group by 1,2,3,4,5,6,7,8,9,10,11,12
    order by job_id asc
)

select * from final
