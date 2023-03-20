--{{ config(materialized='view') }}

with source as (
    select * from {{ source('reposd_job', 'agent_job_param_reposd_table') }}
),
staged as (
    select
        job_id
        , name as job_name
        , user_id as username
        , job_type
        , job_param
        , filepath_source
    from source
)

select * from staged