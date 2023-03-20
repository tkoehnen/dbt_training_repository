--{{ config(materialized='view') }}

with job as (
    select * from {{ ref('int_agent_job') }}
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
        job.job_id
        , job.job_name
        , job.username
        , job.job_type
        , job.job_param
        , job.filepath_source
        , job.dv_type
        , job.dv_run_as
        , job.dv_run_as_guid
        , job_dlv_count.count as specific_delivery_dest_count        
        , job_rcp_count.count as specific_recipient_count
        , job_email_count.count as specific_email_recipient_count
        , count(distinct job.job_id) as distinct_job_count
        , case when job.job_type = 'Agent' then count(distinct job.job_id) else 0 end as job_type_agent_count
        , case when job.job_type = 'Email' then count(distinct job.job_id) else 0 end as job_type_email_count
        , case when job.dv_type = 'recipient' then count(distinct job.job_id) else 0 end as job_dv_recipient_count
        , case when job.dv_type = 'runAsUser' then count(distinct job.job_id) else 0 end as job_dv_runasuser_count
    from job
        , job_dlv_count
        , job_rcp_count
        , job_email_count
    where job.job_id = job_dlv_count.job_id(+)
        and job.job_id = job_rcp_count.job_id(+)
        and job.job_id = job_email_count.job_id(+)
    group by 1,2,3,4,5,6,7,8,9,10,11,12
)

select * from final
order by job_id asc