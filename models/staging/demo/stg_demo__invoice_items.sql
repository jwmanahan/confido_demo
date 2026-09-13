SELECT
    -- Primary key
    id AS invoice_item_id

    -- Foreign keys
    , invoice_id
    , item_remote_id

    -- Things we know about the invoice item
    , total_amount AS invoice_item_price -- presumably whole currency units
    , NVL(quantity, 1) AS unit_quantity
    , NVL(
        unit_price,
        DIV0(total_amount, unit_quantity)
      ) AS unit_price
    , unit_quantity * ii.unit_price AS calc_invoice_item_price -- Always within $10 of printed total price, but often off by <$10
    , CASE WHEN invoice_item_price < 0 THEN 'Negative charge'
        WHEN invoice_item_price > 0 THEN 'Positive charge'
        WHEN invoice_item_price = 0 THEN 'No charge'
        ELSE 'Other'
      END AS charge_direction

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'invoice_items') }} AS ii
