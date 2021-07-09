Update
	(SELECT 
		pd.product_sub_type old, 
		pci.exercise_type new 
	from 
		product_desc pd 
		INNER JOIN 
		product_call_info pci 
		
		ON 
		pd.product_id=pci.product_id 
		AND 
		pci.call_type='Cancellable' 
		AND 
		pd.product_extended_type=pci.call_type 
		AND 
		pd.product_type='Swap' 
		AND 
		pd.product_sub_type='Standard') t 
SET t.old=new
;

INSERT all 
into DOMAIN_VALUES (Name,value,description)  values('Swap.subtype','American',' ')
into DOMAIN_VALUES (Name,value,description)  values('Swap.subtype','Bermudan',' ')
into DOMAIN_VALUES (Name,value,description)  values('Swap.subtype','European',' ')
select 1 from dual
;