SELECT
    -- Primary key
    id AS global_customer_id
    , _uuid -- unclear what this is for so far, may JOIN with confido_distribution_centers

    -- Foregin keys
    , company_detail_id

    -- Things we know about the global customer
    , name AS global_customer_name
    , is_distributor

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'global_customers') }}
WHERE name NOT ILIKE '%test%'
