{{ 
    config (materialized = 'incremental', schema = 'TRANSACTION_DATA', 
    unique_key = ['SALESORGCODE', 'DISTRIBUTIONCHANNELCODE', 'CUSTOMERID', 'MATERIALID', 'VERSION', 'VERSIONLAG', 'UPLOADYEAR', 'CALENDARYEARMONTH']
    )
}}

SELECT CONSTRAINFORECAST,SALESORGCODE, DISTRIBUTIONCHANNELCODE, CUSTOMERID, MATERIALID, VERSION, VERSIONLAG, CAST(UPLOADYEAR AS VARCHAR), 
CALENDARYEARMONTH FROM {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.SAP_CONSTRAINED_FORECAST

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where CALENDARYEARMONTH > (select max(calendaryearmonth) from {{ this }})

{% endif %}