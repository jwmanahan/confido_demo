SELECT
    -- Primary key
    id AS retailer_id
    , _uuid

    -- Foreign keys
    , company_detail_id AS company_id
    , muffin_account_id
    , muffin_chain_id

    -- What we know about the retailer
    , name AS retailer_name
    , is_custom

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'retailers') }}
WHERE name NOT ILIKE '%test%' -- Note to reviewer: I see name "teat" but don't think that clean up should be done in dbt as it's an unpredictable typo. Would ask to fix with DML in the source table instead
