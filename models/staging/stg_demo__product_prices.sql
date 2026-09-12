SELECT
    -- Primary key
    product_id
    , effective_at AS price_effective_date
    , CONCAT(
        product_id
        , '-', NVL(global_customer_id, 0)
        , '-', price_effective_date
      ) AS product_customer_effective_date_pk
    , id AS product_price_id -- Alternate PK

    -- Foreign keys
    , global_customer_id
    , distribution_center_id
    , forecast_version_id -- most recent only

    -- Things we know about the product price
    , amount AS price
    -- TODO: int layer should have price_end_date

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'product_prices') }}
QUALIFY 1 = ( -- Remove apparent duplication in source data
    ROW_NUMBER() OVER (
        PARTITION BY
            product_id
            , price_effective_date
            , global_customer_id
            -- Below this line included in case there can be different prices for the same product for different distros
            , distribution_center_id
        ORDER BY forecast_version_id DESC NULLS LAST
    )
)
