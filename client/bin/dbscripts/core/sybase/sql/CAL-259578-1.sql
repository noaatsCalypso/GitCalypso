update official_pl_config_attr set attr_value = 'Change in Asset Value'            where attr_type = 'plmeasure' and attr_value = 'Asset Value P' || char(38) || 'L'            
go
update official_pl_config_attr set attr_value = 'Change in Asset Value (Base)'     where attr_type = 'plmeasure' and attr_value = 'Asset Value P' || char(38) || 'L (Base)'     
go
update official_pl_config_attr set attr_value = 'Change in Risk Value'             where attr_type = 'plmeasure' and attr_value = 'Risk Value P' || char(38) || 'L'             
go
update official_pl_config_attr set attr_value = 'Change in Risk Value (Base)'      where attr_type = 'plmeasure' and attr_value = 'Risk Value P' || char(38) || 'L (Base)'      
go
update official_pl_config_attr set attr_value = 'Change in Settled Cash'           where attr_type = 'plmeasure' and attr_value = 'Settled Cash P' || char(38) || 'L'           
go
update official_pl_config_attr set attr_value = 'Change in Settled Cash (Base)'    where attr_type = 'plmeasure' and attr_value = 'Settled Cash P' || char(38) || 'L (Base)'    
go
update official_pl_config_attr set attr_value = 'Change in Unsettled Cash'         where attr_type = 'plmeasure' and attr_value = 'Unsettled Cash P' || char(38) || 'L'         
go
update official_pl_config_attr set attr_value = 'Change in Unsettled Cash (Base)'  where attr_type = 'plmeasure' and attr_value = 'Unsettled Cash P' || char(38) || 'L (Base)'  
go
