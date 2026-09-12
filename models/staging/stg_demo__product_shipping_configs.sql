SELECT
    -- Primary key
    product_id
    , effective_at AS config_effective_date
    , global_customer_id
    , CONCAT(
        product_id
        , '-', config_effective_date
        , '-', NVL(global_customer_id, 0)
      ) AS product_customer_effective_date_pk

    -- Foreign keys
    , distribution_center_id
    , forecast_version_id
    , shipping_product_id -- What is this?

    -- What we know about the product shipping config
    -- TODO in int layer: add config end date

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'product_shipping_configs') }}
QUALIFY 1 = ( -- Remove apparent duplication in source data
    ROW_NUMBER() OVER (
        PARTITION BY
            product_id
            , config_effective_date
            , global_customer_id
            -- Below this line included in case there can be different configs for the same product for different distros
            , distribution_center_id
        ORDER BY forecast_version_id DESC NULLS LAST
    )
)
