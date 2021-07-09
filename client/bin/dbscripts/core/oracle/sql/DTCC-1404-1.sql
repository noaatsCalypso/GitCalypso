-- Deleting DTCC message set-ups over Equity Derivatives and Swaps
DELETE FROM advice_config
WHERE message_type = 'DTCC_CONFIRM'
      AND ( product_type LIKE 'Equity%' OR product_type = 'Swap')
;

-- Deleting static data filter isDTCC_Equities
DELETE FROM sd_filter_domain WHERE sd_filter_name = 'isDTCC_Equities'
;
DELETE FROM sd_filter_domain WHERE domain_value = 'isDTCC_Equities'
;
DELETE FROM sd_filter_element WHERE sd_filter_name = 'isDTCC_Equities'
;
DELETE FROM sd_filter WHERE sd_filter_name = 'isDTCC_Equities'
;

-- Deleting static data filter isDTCC_Rates
DELETE FROM sd_filter_domain WHERE sd_filter_name = 'isDTCC_Rates'
;
DELETE FROM sd_filter_domain WHERE domain_value = 'isDTCC_Rates'
;
DELETE FROM sd_filter_element WHERE sd_filter_name = 'isDTCC_Rates'
;
DELETE FROM sd_filter WHERE sd_filter_name = 'isDTCC_Rates'
;
