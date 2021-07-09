UPDATE curve_parameter SET value = REPLACE(VALUE, ',', '.') WHERE parameter_name IN ('January','February','March','April','May','June','July','August','September','October','November','December')
;