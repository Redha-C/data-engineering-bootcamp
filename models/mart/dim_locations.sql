with

locations as (

    select count(*) as count_ from {{ ref('stg_locations') }}

)

select * from locations
