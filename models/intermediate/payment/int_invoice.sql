WITH cte_invoice_items AS (
    SELECT
        invoice_id
        , COUNT(1) n_invoice_items
        , SUM(unit_quantity) invoice_total_quantity
        , SUM(invoice_item_price) invoice_total_price
        , ARRAY_AGG(DISTINCT charge_direction) charge_directions_present
    FROM {{ ref('stg_demo__invoice_items') }}
    GROUP BY 1
)

SELECT
    -- Primary key
    inv.invoice_id

    -- Foreign keys
    , inv.company_id
    , inv.customer_remote_id -- Doesn't seem to JOIN to available columns in stg_demo__global_customers
    , inv.subsidiary_id

    -- Invoice info
    , inv.invoice_number
    , CASE WHEN paid_on_date IS NOT NULL THEN 'Paid' -- This assumption needs to be checked
        ELSE 'Open'
      END AS invoice_state
    , NVL(ii.charge_directions_present, ['No line items']) AS charge_directions_present -- Could add to row definition

    -- Timing
    , inv.invoice_created_at_ntz
    , inv.paid_on_date

    -- Price
    , NVL(ii.invoice_total_price, 0) AS invoice_total_price
    , inv.currency

    -- Other measures of size
    , NVL(ii.n_invoice_items, 0) AS n_invoice_items
    , NVL(ii.invoice_total_quantity, 0) AS invoice_total_quantity

    -- Processing
    , CURRENT_TIMESTAMP AS table_last_generated_at


FROM {{ ref('stg_demo__invoices') }} AS inv
LEFT JOIN cte_invoice_items AS ii
    ON inv.invoice_id = ii.invoice_id
