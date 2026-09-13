SELECT
    -- Primary key
    product_id
    , child_product_id
    , CONCAT(product_id, child_product_id) AS product_child_product_pk

    -- What we know about the product relationship
    , quantity AS child_quantity

    -- Processing
    , _updated_at AS source_last_updated_at_ntz -- Chosen because aLways about a second after `updated_at`

FROM {{ source('demo', 'product_relationships') }}
