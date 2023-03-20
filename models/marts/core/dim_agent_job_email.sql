--{{ config(materialized='view') }}

with job_email as (
    select * from {{ ref('stg_agent_xml_email') }}
)
, final as (
    select
        job_email.job_id
        , ((job_email.job_id + 100000)*100) + job_email.emailrcp_index_1 as job_id_emailrcp_index
        , job_email.email_value_get
        , job_email.email_seq
        , job_email.email_index
        , job_email.emailrcp_value_get
        , job_email.emailrcp_seq
        , job_email.emailrcp_index
        , job_email.emailrcp_index_1
        , job_email.emailrcp_address
        , job_email.emailrcp_type
    from  job_email
    order by job_id asc, job_id_emailrcp_index asc
)

select * from final
