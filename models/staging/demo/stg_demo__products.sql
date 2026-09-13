SELECT
    -- Primary key
    id AS product_id
    , _uuid -- need to figure out what this is

    -- Foreign keys
    , product_family_id
    , company_detail_id AS company_id
    , item_id -- Is this invoice item? Doesn't match any invoice items in sample data
    -- Leaving out ship_with_product_relationship_id because all NULL

    -- What we know about the product
    , name AS product_name
    , type AS product_type
    , cleaned_upc AS upc

    -- Denormalized things we know about the item
    , internal_item_number -- All NULL or empty string as of Sept 2026

    -- Processing
    , upc AS upc_raw -- 0 char string becomes all 0s
    , _updated_at AS source_last_updated_at_ntz -- Chosen because aLways about a second after `updated_at`

FROM {{ source('demo', 'products') }}
WHERE NOT name ILIKE ANY ('%test%', '%demo%')
