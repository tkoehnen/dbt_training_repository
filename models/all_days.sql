--Open new all_days.sql and pull code from dbt_utils.date_spine macro (README file)
--changed end_date from basic cast() to dateadd() to match training example

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2016-01-01' as date)",
    end_date="dateadd(week, 1, current_date)"
   )
}}
