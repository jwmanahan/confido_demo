SELECT
    -- Primary key
    id AS invoice_id

    -- Foreign keys
    , customer_remote_id -- TODO: which Ct field does this map to? Differnt types w/ 10, 40, etc vs GENERATED_XXXX. Could group by this
    , company_detail_id AS company_id
    , subsidiary_id
    -- Leaving out check_remit_item_ID since all NULL in source

    -- Things we know about an invoice
    , inv.number AS invoice_number
    , currency
    , created_at AS invoice_created_at_ntz
    , paid_on_date::DATE AS paid_on_date

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'invoices') }} AS inv
WHERE inv.number NOT ILIKE '%test%'
