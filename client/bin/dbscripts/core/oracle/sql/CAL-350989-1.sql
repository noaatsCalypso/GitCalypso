DELETE FROM an_param_items WHERE param_name IN (SELECT param_name FROM an_param_items WHERE class_name = 'com.calypso.tk.risk.SensitivityParam' AND attribute_name = 'MktType' AND attribute_value != 'Rate') AND attribute_name = 'FORP_UseAlternateInterpolator' AND attribute_value='true'
;
