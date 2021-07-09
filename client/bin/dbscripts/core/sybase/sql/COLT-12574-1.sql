UPDATE collateral_config SET po_mta_perc_basis = NULL WHERE mcc_id IN
(SELECT mcc_id FROM collateral_config WHERE po_mta_perc_basis='Net Value')
GO
UPDATE collateral_config SET po_thresh_perc_basis = NULL WHERE mcc_id IN
(SELECT mcc_id FROM collateral_config WHERE po_thresh_perc_basis='Net Value')
GO
UPDATE collateral_config SET le_mta_perc_basis = NULL WHERE mcc_id IN
(SELECT mcc_id FROM collateral_config WHERE le_mta_perc_basis='Net Value')
GO
UPDATE collateral_config SET le_thresh_perc_basis = NULL WHERE mcc_id IN
(SELECT mcc_id FROM collateral_config WHERE le_thresh_perc_basis='Net Value')
GO

IF EXISTS (SELECT 1 FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'collateral_config_currency' AND syscolumns.name = 'adj_order')
BEGIN

	EXECUTE('delete from collateral_config_currency where exists (select t1.mrg_call_def, t1.currency_code, t1.is_po_elig, t1.adj_order 
		from collateral_config_currency t1, collateral_config_currency t2 
		where t1.mrg_call_def=t2.mrg_call_def
		and t1.currency_code=t2.currency_code 
		and t1.is_po_elig=t2.is_po_elig 
		and t1.is_po_elig=1
		and t1.adj_order > t2.adj_order)')
		
    	EXECUTE('delete from collateral_config_currency where exists (select t1.mrg_call_def, t1.currency_code, t1.is_le_elig, t1.adj_order 
		from collateral_config_currency t1, collateral_config_currency t2 
		where t1.mrg_call_def=t2.mrg_call_def
		and t1.currency_code=t2.currency_code 
		and t1.is_le_elig=t2.is_le_elig 
		and t1.is_le_elig=1
		and t1.adj_order > t2.adj_order)')

END
go
