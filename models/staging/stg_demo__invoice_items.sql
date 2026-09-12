SELECT
    -- Primary key
    id AS invoice_item_id

    -- Foreign keys
    , invoice_id
    , item_remote_id

    -- Things we know about the invoice item
    , total_amount -- pos or neg, presumably whole currency units
    , NVL(quantity, 1) AS unit_quantity
    , NVL(
        unit_price,
        DIV0(total_amount, unit_quantity)
      ) AS unit_price
    , unit_quantity * ii.unit_price AS tmp_test_calc_total

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'invoice_items') }} AS ii
