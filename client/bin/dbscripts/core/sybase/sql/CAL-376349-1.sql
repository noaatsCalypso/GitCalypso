UPDATE curve_parameter SET value=STR_REPLACE(value, ',' ,'.') WHERE parameter_name IN ('January','February','March','April','May','June','July','August','September','October','November','December')
go