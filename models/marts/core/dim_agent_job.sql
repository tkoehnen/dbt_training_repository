--{{ config(materialized='view') }}

with job as (
    select * from {{ ref('int_agent_job') }}
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
        , decode(upper(job.job_type), null, null, 'AGENT', 'Y', 'N') as job_type_agent_flag
        , decode(upper(job.job_type), null, null, 'EMAIL', 'Y', 'N') as job_type_email_flag
        , decode(upper(job.dv_type), null, null, 'RECIPIENT', 'Y', 'N') as job_dv_recipient_flag
        , decode(upper(job.dv_type), null, null, 'RUNASUSER', 'Y', 'N') as job_dv_runasuser_flag
    from job
)

select * from final
order by job_id asc
