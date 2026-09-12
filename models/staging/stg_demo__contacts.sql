SELECT
    -- Primary key
    id AS contact_id

    -- Foreign keys
    , remote_id AS contact_remote_id -- But remote what? Remote company?
    , parent_remote_id
    , global_customer_id
    , distribution_center_id
    , company_detail_id

    -- What we know about the contact
    , name AS contact_name

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'contacts') }}
WHERE name NOT ILIKE '%test%'
