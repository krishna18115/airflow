
{{config(
    materialized='incremental',
    unique_key='CustomerID',
    incremental_strategy='merge',
    on_schema_change='append_new_columns'
)}}

SELECT
    TRIM(CAST(CustomerID AS STRING)) AS CustomerID,
    {{ clean_customer_id('FirstName') }} AS FirstName,
    {{ clean_customer_id('LastName') }} AS LastName,
     FORMAT_DATE(
        '%d-%m-%Y',
        SAFE_CAST(DateOfBirth AS DATE)
    ) AS DateOfBirth,
    NationalInsuranceNumber,
    Email,
    {{clean_phone_number('phone')}} as phone_number,
    AddressLine1,
    Town,
     {{ clean_customer_id('County') }} AS County,
     PostCode,
     CustomerSegment,

    --KYCStatus  logic
      CASE
        WHEN UPPER(TRIM(KYCStatus)) = 'VERIFIED'
            THEN 'Active'

        WHEN UPPER(TRIM(KYCStatus)) = 'PENDING'
            THEN 'Review RRequiredequired'

        WHEN UPPER(TRIM(KYCStatus)) = 'EXPIRED'
            THEN 'KYC Renewal Required'

        ELSE 'Unknown'
    END AS KYCStatus,
    CreatedDate,
    Batch_id,
    Ingested_at
FROM {{ source('Bronze', 'customer_valid') }}

{% if is_incremental() %}

where Ingested_at > 
            (select coalesce(max(Ingested_at),
                    timestamp('1900-01-01'))
            from {{this}}
            )
{% endif %}