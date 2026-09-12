SELECT
    -- Primary key
    id AS distribution_center_id
    , _uuid -- unclear what this is so far

    -- Foreign keys
    , global_customer_id
    , muffin_location_id
    , company_detail_id

    -- What we know about the distribution center
    , name AS distribution_center_name
    , CASE WHEN name = 'All Other DCs' THEN 'Default'
        WHEN name ILIKE '%division%' THEN 'Group' -- Add more fragments here as needed
        ELSE 'Single location'
      END AS distribution_center_type

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'confido_distribution_centers') }}
WHERE name NOT ILIKE '%test%'
