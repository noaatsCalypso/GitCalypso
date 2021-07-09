Update  AN_PARAM_ITEMS ap  set ap.attribute_value=ap.attribute_value||',NPV_NOCASH' 
WHERE ap.attribute_name='FILTERED_MEASURE_LIST' 
AND ap.class_name='com.calypso.tk.risk.LadderLivePLParam' 
AND INSTR(ap.attribute_value,'NPV_NOCASH',1,1)=0
;

Update  AN_PARAM_ITEMS ap  set ap.attribute_value=ap.attribute_value||',NPV_NOCASH' 
WHERE ap.attribute_name='MeasureList' 
AND ap.class_name='com.calypso.tk.risk.LadderLivePLParam' 
AND INSTR(ap.attribute_value,'NPV_NOCASH',1,1)=0
;

Update  AN_PARAM_ITEMS ap  set ap.attribute_value=ap.attribute_value||',NPV_NOCASH' 
WHERE ap.attribute_name='MeasureListAbs' 
AND ap.class_name='com.calypso.tk.risk.LadderLivePLParam' 
AND INSTR(ap.attribute_value,'NPV_NOCASH',1,1)=0
;

Update  AN_PARAM_ITEMS ap  set ap.attribute_value=ap.attribute_value||',NPV_NOCASH' 
WHERE ap.attribute_name='MeasureListAbsBase' AND ap.class_name='com.calypso.tk.risk.LadderLivePLParam' 
AND INSTR(ap.attribute_value,'NPV_NOCASH',1,1)=0
;