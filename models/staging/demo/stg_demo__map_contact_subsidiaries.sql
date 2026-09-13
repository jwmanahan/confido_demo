SELECT
    -- Primary key
    contact_id
    , subsidiary_id
    , CONCAT(contact_id, '-', subsidiary_id) AS contact_subsidiary_pk

    -- Processing
    , _updated_at AS source_last_updated_at_ntz

FROM {{ source('demo', 'map_contact_subsidiaries') }}
