update official_pl_config_attr set attr_value = 'Change in Asset Value'            where attr_type = 'plmeasure' and attr_value = 'Asset Value P' || chr(38) || 'L'            
;
update official_pl_config_attr set attr_value = 'Change in Asset Value (Base)'     where attr_type = 'plmeasure' and attr_value = 'Asset Value P' || chr(38) || 'L (Base)'     
;
update official_pl_config_attr set attr_value = 'Change in Risk Value'             where attr_type = 'plmeasure' and attr_value = 'Risk Value P' || chr(38) || 'L'             
;
update official_pl_config_attr set attr_value = 'Change in Risk Value (Base)'      where attr_type = 'plmeasure' and attr_value = 'Risk Value P' || chr(38) || 'L (Base)'      
;
update official_pl_config_attr set attr_value = 'Change in Settled Cash'           where attr_type = 'plmeasure' and attr_value = 'Settled Cash P' || chr(38) || 'L'           
;
update official_pl_config_attr set attr_value = 'Change in Settled Cash (Base)'    where attr_type = 'plmeasure' and attr_value = 'Settled Cash P' || chr(38) || 'L (Base)'    
;
update official_pl_config_attr set attr_value = 'Change in Unsettled Cash'         where attr_type = 'plmeasure' and attr_value = 'Unsettled Cash P' || chr(38) || 'L'         
;
update official_pl_config_attr set attr_value = 'Change in Unsettled Cash (Base)'  where attr_type = 'plmeasure' and attr_value = 'Unsettled Cash P' || chr(38) || 'L (Base)'  
;
