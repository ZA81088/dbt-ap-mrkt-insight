{% snapshot RTM_LEADTIME %}

{{ config ( 
            target_schema = 'MASTER_DATA', 
            unique_key = 'RETAILCODE||SERVICE_PROVIDER_CODE_WC||SERVICE_PROVIDER_CODE_GY', 
            strategy = 'timestamp', updated_at = 'last_modified_time', ) 
}}

select * from  {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.RTM_LEADTIME

{% endsnapshot %}