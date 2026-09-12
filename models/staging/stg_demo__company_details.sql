SELECT
    -- Primary key // TODO: test
    id AS company_id

    -- Foreign keys
    , merge_uuid AS company_external_uuid
    , muffin_organization_id

    -- Things we know about the company
    , name AS company_name

    -- How the company is configured with Confido
    , forecast_end_day_of_week
    , prevent_customer_remapping AS is_customer_remapping_prevented

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'company_details') }}
