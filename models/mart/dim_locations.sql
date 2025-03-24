with

locations as (

    select count(*) from {{ ref('stg_locations') }}

)

select * from locations
