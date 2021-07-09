UPDATE COLLATERAL_CONFIG SET PO_MTA_PERC_BASIS = NULL where MCC_ID IN 
(SELECT MCC_ID FROM COLLATERAL_CONFIG where PO_MTA_PERC_BASIS='Net Value')
;
UPDATE COLLATERAL_CONFIG SET PO_THRESH_PERC_BASIS = NULL where MCC_ID IN 
(SELECT MCC_ID FROM COLLATERAL_CONFIG where PO_THRESH_PERC_BASIS='Net Value')
;
UPDATE COLLATERAL_CONFIG SET LE_MTA_PERC_BASIS = NULL where MCC_ID IN 
(SELECT MCC_ID FROM COLLATERAL_CONFIG where LE_MTA_PERC_BASIS='Net Value')
;
UPDATE COLLATERAL_CONFIG SET LE_THRESH_PERC_BASIS = NULL where MCC_ID IN 
(SELECT MCC_ID FROM COLLATERAL_CONFIG where LE_THRESH_PERC_BASIS='Net Value')
;

DECLARE
	v_column_exists number :=0;
BEGIN
	select count(*) into v_column_exists from user_tab_cols where column_name = 'adj_order' and table_name = 'collateral_config_currency';
	if(v_column_exists > 0) then
    	execute immediate 'delete from collateral_config_currency where (mrg_call_def, currency_code, is_po_elig, adj_order) in (select t1.mrg_call_def, t1.currency_code, t1.is_po_elig, t1.adj_order 
		from collateral_config_currency t1, collateral_config_currency t2 
		where t1.mrg_call_def=t2.mrg_call_def
		and t1.currency_code=t2.currency_code 
		and t1.is_po_elig=t2.is_po_elig 
		and t1.is_po_elig=1
		and t1.adj_order > t2.adj_order)';
	end if;

	if(v_column_exists > 0) then
    	execute immediate 'delete from collateral_config_currency where (mrg_call_def, currency_code, is_le_elig, adj_order) in (select t1.mrg_call_def, t1.currency_code, t1.is_le_elig, t1.adj_order 
		from collateral_config_currency t1, collateral_config_currency t2 
		where t1.mrg_call_def=t2.mrg_call_def
		and t1.currency_code=t2.currency_code 
		and t1.is_le_elig=t2.is_le_elig 
		and t1.is_le_elig=1
		and t1.adj_order > t2.adj_order)';
	end if;
END;