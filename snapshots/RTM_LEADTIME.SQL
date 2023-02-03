{% snapshot RTM_LEADTIME %}

{{
    config(
      target_database='APITDBDEV',
      target_schema='MASTER_DATA',
      unique_key= "RETAILCODE||'-'||SERVICE_PROVIDER_CODE_WC||'-'||SERVICE_PROVIDER_CODE_GY",

      strategy='timestamp',
      updated_at='LAST_MODIFIED_TIME'
    )
}}

select * from APITDBDEV.STAGING.RTM_LEADTIME

{% endsnapshot %}