-- Invoice product
SELECT
    -- Primary key
    ii.invoice_item_id

    -- Information about the invoice overall
    , ii.invoice_id
    , inv.invoice_number

    -- Pricing
    , inv.currency AS invoice_currency
    , ii.invoice_item_price AS price_on_invoice_item
    , DIV0(ii.invoice_item_price, inv.invoice_total_price) AS pct_of_invoice_price
    , ii.charge_direction
    , ii.unit_quantity
    , ii.unit_price
    , ii.calc_invoice_item_price AS price_implied_by_price_x_quantity
    -- TODO: + Price implied by product

    -- Timing
    , inv.invoice_state
    , inv.invoice_created_at_ntz
    , inv.paid_on_date

    -- What we know about the item and product
    , ci.item_id
    , ii.item_remote_id
    , ci.item_name

    -- What we know about the company
    , co.company_id
    , co.company_name
    , co.muffin_organization_id

    -- Processing
    , CURRENT_TIMESTAMP AS table_last_generated_at

FROM stg_demo__invoice_items AS ii
INNER JOIN int_invoice AS inv
    ON ii.invoice_id = inv.invoice_id
-- TODO: Would like to join to customers here, but not with the currently existing JOIN possibilities
LEFT JOIN stg_demo__items AS ci -- "company item". As of Sept 2026, JOIN is 1:1
    ON ii.item_remote_id = ci.item_remote_id -- would prefer item_id
    AND inv.company_detail_id = ci.company_detail_id
LEFT JOIN stg_demo__company_details AS co
    ON inv.company_detail_id = co.company_id
-- TODO: Product probably belongs here for PIT forecast prices, but doesn't appear to have eligible JOIN conditions in its current state
WHERE NVL(inv.currency, 'USD') = 'USD' -- TODO: add join to an exchange rate table and column usd_price
ORDER BY
    inv.invoice_created_at_ntz DESC
    , inv.company_detail_id ASC
    , ii.invoice_item_id DESC
