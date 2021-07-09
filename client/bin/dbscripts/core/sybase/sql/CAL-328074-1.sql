update an_param_items  set attribute_value=attribute_value+',NPV_NOCASH' 
	WHERE attribute_name='FILTERED_MEASURE_LIST'
	AND class_name='com.calypso.tk.risk.LadderLivePLParam' 
	AND CHARINDEX ('NPV_NOCASH',attribute_value)=0
go
	
update an_param_items  set attribute_value=attribute_value+',NPV_NOCASH' 
	WHERE attribute_name='MeasureList'
	AND class_name='com.calypso.tk.risk.LadderLivePLParam' 
	AND CHARINDEX ('NPV_NOCASH',attribute_value)=0
go
	
update an_param_items  set attribute_value=attribute_value+',NPV_NOCASH' 
	WHERE attribute_name='MeasureListAbs'
	AND class_name='com.calypso.tk.risk.LadderLivePLParam' 
	AND CHARINDEX ('NPV_NOCASH',attribute_value)=0
go	
update an_param_items  set attribute_value=attribute_value+',NPV_NOCASH' 
	WHERE attribute_name='MeasureListAbsBase'
	AND class_name='com.calypso.tk.risk.LadderLivePLParam' 
AND CHARINDEX ('NPV_NOCASH',attribute_value)=0
go