SELECT
    -- Primary key
    id AS item_id

    -- Foreign keys
    , company_detail_id AS company_id
    , remote_id AS item_remote_id -- Presumed to be the ID of the item in the client company's systems

    -- What we know about the items
    , name AS item_name

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'items') }}
WHERE name NOT ILIKE '%test%'
