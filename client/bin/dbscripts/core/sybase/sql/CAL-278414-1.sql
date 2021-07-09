delete from an_viewer_config where analysis_name='CrossAssetPL' and viewer_class_name='apps.risk.CrossAssetPLAnalysisViewer'
go

                  


add_column_if_not_exists 'sched_task', 'external_ref', 'varchar(255) NULL'
go
     
create procedure sched_task_extref as
declare @c_task_id int
declare @c_task_type varchar(32)
begin
begin transaction
declare c1 cursor for select task_id, task_type from sched_task where external_ref is null
  open c1
    fetch c1 into @c_task_id, @c_task_type
    while (@@sqlstatus = 0)
    begin
    update sched_task set external_ref = task_type + '_' + cast((select count(*)+1 from sched_task where task_type = @c_task_type and external_ref> ' ' ) 
               as varchar(255)) where task_id = @c_task_id
    fetch c1 into @c_task_id, @c_task_type
    end
  close c1
deallocate cursor c1
commit transaction
end
go
     
exec sched_task_extref
go
     
DROP PROCEDURE sched_task_extref
go
     
ALTER TABLE sched_task MODIFY external_ref NOT NULL
go

if exists (select 1 from sysobjects where name = 'sp_cal_upd_proc'
                                    and type = 'P')
   begin
     drop procedure sp_cal_upd_proc
   end 
go

if exists (select 1 from sysobjects where name = 'sp_is_processed'
                                    and type = 'P')
   begin
     drop procedure sp_is_processed
   end 
go

if exists (select 1 from sysobjects where name = 'sp_save_event'
                                    and type = 'P')
   begin
     drop procedure sp_save_event
   end 
go


add_column_if_not_exists 'product_seclending', 'fee_type', 'varchar(20) null'
go
add_column_if_not_exists 'prd_seclend_hist','fee_type', 'varchar(20) null'
go
UPDATE product_seclending SET fee_type = 'Percentage rate' WHERE fee_type NOT IN ('Percentage rate', 'Amount per million', 'Absolute amount')
go
UPDATE prd_seclend_hist SET fee_type = 'Percentage rate' WHERE fee_type NOT IN ('Percentage rate', 'Amount per million', 'Absolute amount')
go
alter table product_seclending modify fee_type not null
go
alter table prd_seclend_hist modify fee_type not null
go


UPDATE product_repo SET substitution_b = 1 WHERE product_id IN
  (SELECT product_repo.product_id FROM product_desc, product_repo
   WHERE product_repo.product_id = product_desc.product_id
   AND product_desc.product_type = 'Repo'
   AND product_repo.buysellback_b = 0
   AND product_repo.hold_in_custody_b = 0
   AND product_repo.single_coll_b = 0)
go


UPDATE bo_transfer SET available=1 WHERE transfer_type='SECURITY' AND trade_id in
  (SELECT trade_id FROM trade WHERE product_id in
  (SELECT product_id FROM product_repo WHERE substitution_b = 1 ))
go


add_domain_values  
'volSurfaceGenerator', ' CMSBasisAdj', 'Allows a quote adjustment and
 the related point adjustment surface to store a matrix of volatility
 adjustments representing the basis between swaption and CMS swaps'
go

DELETE FROM pricer_measure where measure_name = 'DELTA_AT_DOWN_BARRIER'
go
DELETE FROM pricer_measure where measure_name = 'DELTA_AT_UP_BARRIER'
go

INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment)
  VALUES ('DELTA_AT_UP_BARRIER','tk.core.PricerMeasure',224,'Delta when spot is at barrier')  
go

INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment)
  VALUES ('DELTA_AT_DOWN_BARRIER','tk.core.PricerMeasure',225,'Delta when spot is at barrier') 
go

INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_product_config', 1)
go
INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_intraday_param_config', 1)
go
INSERT INTO report_win_def (win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color)
   VALUES (128, 'MCCStatistics', 0, 0, 1)
go

delete from an_viewer_config where analysis_name='Composite' and read_viewer_b = 0
go
insert into an_viewer_config (analysis_name, viewer_class_name, read_viewer_b) values
    ('Composite', 'apps.risk.CompositeAnalysisReportFrameworkViewer',0)
go

delete from wfw_transition where workflow_id in (500, 501, 502)
go

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES
   (500, 'LegalEntity', 'NONE', 'NEW', 'PENDING', 0, 1, 'ALL', 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES
   (502, 'LegalEntity', 'PENDING', 'AMEND', 'VERIFIED', 1, 1, 'ALL', 0, 0, 0, 0 )
go
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES
   (501, 'LegalEntity', 'NONE', 'AMEND', 'PENDING', 0, 1, 'ALL', 0, 0, 0, 0 )
go



INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'VALUATION_TIMEZONES', 'Valuation Timezones' )
go
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 18, 'HandleAckNack' )
go
INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 20000, 'DefaultServer', 'ReferenceEntityLite', 0, 'Calypso', 'LFU' )
go
INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 10000, 'DefaultClient', 'ReferenceEntityLite', 0, 'NonTransactional', 'LFU' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve_underlying', 'cu_fx_fixed', 'cu_id', 'cu_id', 'Curve', 'NONE' )
go
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'product_bond', 'abs_collateral_group', 'product_id', 'product_id', 'Product', 'NONE' )
go
add_domain_values 'messageType', 'ACC_SEC_STATEMENT', 'Security Account Statement Text/Html Report' 
go
add_domain_values   'messageType', 'ACC_SEC_POS_STATEMENT', 'Security Account Statement Swift (MT535)' 
go
add_domain_values   'messageType', 'ACC_SEC_TRAN_STATEMENT', 'Security Account Statement Swift (MT536)' 
go
add_domain_values   'REPORT.Types', 'TradeAudit', 'TradeAudit Report' 
go
add_domain_values   'rateIndexAttributes', 'SpotDateCalculator', 'This defines the name of the java class in the package com.calypso.tk.util that performs the date calculation logic' 
go
add_domain_values   'rateIndexAttributes', 'SpotDateCalculatorForSource', 'This allows to restrict usage of the SpotDateCalculator to specific source only' 
go
add_domain_values   'rateIndexAttributes', 'BBAShiftCalendar', '' 
go
add_domain_values   'rateIndexAttributes', 'BBAShiftDateRoll', '' 
go
add_domain_values   'BBAShiftDateRoll', 'FOLLOWING', '' 
go
add_domain_values   'BBAShiftDateRoll', 'MOD_FOLLOW', '' 
go
add_domain_values   'BBAShiftDateRoll', 'PRECEDING', '' 
go
add_domain_values   'BBAShiftDateRoll', 'MOD_PRECED', '' 
go
add_domain_values   'BBAShiftDateRoll', 'NO_CHANGE', '' 
go
add_domain_values   'BBAShiftDateRoll', 'END_MONTH', '' 
go
add_domain_values   'BBAShiftDateRoll', 'IMM_MON', '' 
go
add_domain_values   'BBAShiftDateRoll', 'IMM_WED', '' 
go
add_domain_values   'BBAShiftDateRoll', 'MOD_SUCC', '' 
go
add_domain_values   'BBAShiftDateRoll', 'SFE', '' 
go
add_domain_values   'SpotDateCalculator', 'BBARateIndexSpotDateCalculator', '' 
go
add_domain_values   'SpotDateCalculatorForSource', 'BBA', '' 
go
add_domain_values   'riskAnalysis', 'FXSpotBlotter', '' 
go
add_domain_values   'riskPresenter', 'FXSpotBlotter', '' 
go
add_domain_values   'riskPresenter', 'FwdLadder', '' 
go
add_domain_values   'riskAnalysis', 'FwdLadder', '' 
go
add_domain_values   'workflowRuleMessage', 'AmendGroup', '' 
go
add_domain_values   'workflowRuleMessage', 'RemoveGroup', '' 
go
add_domain_values   'domainName', 'disableReportTableFiltering', 'Reports where table filtering conflicts with other feature and should be disabled' 
go
add_domain_values   'disableReportTableFiltering', 'Account', '' 
go
add_domain_values   'disableReportTableFiltering', 'LegalEntity', '' 
go
add_domain_values   'disableReportTableFiltering', 'IndustryHierarchy', '' 
go
add_domain_values   'disableReportTableFiltering', 'Strategy', '' 
go
add_domain_values   'disableReportTableFiltering', 'FundStrategy', '' 
go
add_domain_values   'disableReportTableFiltering', 'StrategyAttribute', '' 
go
add_domain_values   'function', 'ViewOnlyMergeCounterParties', 'Allows users to view only merge counterparties tab in Process Trade' 
go
add_domain_values   'restriction', 'ViewOnlyMergeCounterParties', 'Allows users to view only merge counterparties tab in Process Trade' 
go
add_domain_values   'domainName', 'MessageAttributeCopier', 'Specify the Message Attribute Copier' 
go
add_domain_values 'MessageAttributeCopier', 'Default' ,''
go
add_domain_values   'volSurfaceGenerator', 'SABRDirectBpVols', '' 
go
add_domain_values   'volSurfaceGenerator', 'SwaptionCEV', 'Calibrates the CEV model to a swaption smile' 
go
add_domain_values   'VolSurface.gensimple', 'CEVSimple', 'Holds the model parameters for the CEV model' 
go
add_domain_values   'MsgAttributes', 'NackReason', 'Nack Reason' 
go
add_domain_values   'rate_index_type', 'Swap', '' 
go
add_domain_values   'engineParam', 'VALUATION_TIMEZONES', '' 
go
add_domain_values   'REPORT.Functions', 'Constant', '' 
go
add_domain_values   'domainName', 'tradeTerminationAction', 'Actions to be carried out from the TerminationWindow' 
go
add_domain_values   'GenericOption.extendedType', 'CommoditySwap2', 'To identify the CS2 underlying product in pricer config for GenericOption' 
go
add_domain_values   'classAuditMode', 'CommodityReset', '' 
go
add_domain_values   'liquidationKeyword', 'Strategy', '' 
go
add_domain_values   'liquidationKeyword', 'Long/Short', '' 
go
add_domain_values   'liquidationKeyword', 'Custodian', '' 
go
add_domain_values   'feeCalculator', 'MarginPtsPVBaseZD', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT103', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT202', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT210', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT210BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT305', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT320', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT509', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT509GSCC', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT515', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT518', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT527', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT540', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT540BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT541', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT541BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT542', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT542BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT543', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT543BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT544', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT544BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT545', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT545BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT546', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT546BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT547', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT547BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT548', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT900', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT900BONY', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT910', '' 
go
add_domain_values   'ExternalMessageField.MessageMapper', 'MT910BONY', '' 
go
add_domain_values   'classAuditMode', 'FixingDatePolicy', '' 
go
add_domain_values   'workflowRuleMessage', 'HandleAckNack', '' 
go
add_domain_values   'messageStatus', 'TO_SEND', '' 
go
add_domain_values   'domainName', 'CurvePrepay.PrepaymentModel', '' 
go
add_domain_values   'Swaption.Pricer', 'PricerSwaptionCEV', '' 
go
add_domain_values   'function', 'CreateModifyCA', 'Access permission to create/modify CA product' 
go
add_domain_values   'function', 'RemoveCA', 'Access permission to remove CA product' 
go
add_domain_values   'function', 'RevertCA', 'Access permission to remove CA product' 
go
add_domain_values   'function', 'AssignCptyOnXfer', 'Access permission to change the counterparty of a transfer when doing an ASSIGN' 
go
add_domain_values   'messageType', 'ACK_MSG', 'Swift Message Acknoledgement' 
go
add_domain_values   'riskPresenter', 'SyntheticHedge', 'Syhthetic Hedge Analysis' 
go
add_domain_values   'riskAnalysis', 'WhatIf', '' 
go
add_domain_values   'tradeKeyword', 'StepIn_Transferor', '' 
go
add_domain_values   'tradeKeyword', 'Novation_Transferor', '' 
go
add_domain_values   'tradeKeyword', 'Novation_Transferee', '' 
go
add_domain_values   'tradeKeyword', 'Novation_Remaining', '' 
go
add_domain_values   'tradeKeyword', 'Novation_Transfer_Role', '' 
go
add_domain_values   'systemKeyword', 'PartialNovatedTo', '' 
go
add_domain_values   'SWIFT.Templates', 'MT518', 'Security Confirmation' 
go
add_domain_values   'domainName', 'CommodityFixingDatePolicy', 'Custom Fixing Date Policy' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency', 'Custom Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency', 'Whole', 'Whole' 
go
add_domain_values   'CommodityPaymentFrequency', 'Periodic', 'Periodic' 
go
add_domain_values   'CommodityPaymentFrequency', 'FutureContractLTD', 'FutureContractLTD' 
go
add_domain_values   'CommodityPaymentFrequency', 'Bullet', 'Bullet' 
go
add_domain_values   'CommodityPaymentFrequency', 'Daily', 'Daily' 
go
add_domain_values   'domainName', 'CommodityAveragingPolicy', 'Custom Averaging Policy' 
go
add_domain_values   'CommodityAveragingPolicy', 'Standard', 'Standard' 
go
add_domain_values   'CommodityAveragingPolicy', 'Cumulative', 'Cumulative' 
go
add_domain_values   'CommodityAveragingPolicy', 'ATC', 'ATC' 
go
add_domain_values   'CommodityAveragingPolicy', 'CTA', 'CTA' 
go
add_domain_values   'CommodityAveragingPolicy', 'CTAWithFXRoll', 'CTAWithFXRoll' 
go
add_domain_values   'domainName', 'CommodityFXAveragingRoundingPolicy', 'Custom FX AveragingRounding Policy' 
go
add_domain_values   'CommodityFXAveragingRoundingPolicy', 'Average', 'Average' 
go
add_domain_values   'CommodityFXAveragingRoundingPolicy', 'Conversion', 'Conversion' 
go
add_domain_values   'CommodityFXAveragingRoundingPolicy', 'Both', 'Both' 
go
add_domain_values   'CommodityFXAveragingRoundingPolicy', 'DontRound', 'DontRound' 
go
add_domain_values   'domainName', 'CommodityAveragingRoundingPolicy', 'Custom AveragingRounding Policy' 
go
add_domain_values   'CommodityAveragingRoundingPolicy', 'Average', 'Average' 
go
add_domain_values   'CommodityAveragingRoundingPolicy', 'DontRound', 'DontRound' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.Bullet', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.Bullet', 'BULLET', '' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.Whole', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.Whole', 'WHOLE_PERIOD', '' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.Daily', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.Daily', 'WHOLE_PERIOD', '' 
go
add_domain_values   'CommodityPaymentFrequency.Daily', 'FIRST_DAY', '' 
go
add_domain_values   'CommodityPaymentFrequency.Daily', 'LAST_DAY', '' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.Contract', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.Contract', 'CONTRACT', '' 
go
add_domain_values   'domainName', 'CommodityPaymentFrequency.Periodic', 'Fixing Date Policy for Payment Frequency' 
go
add_domain_values   'CommodityPaymentFrequency.Periodic', 'WHOLE_PERIOD', '' 
go
add_domain_values   'CommodityPaymentFrequency.Periodic', 'FIRST_DAY', '' 
go
add_domain_values   'CommodityPaymentFrequency.Periodic', 'LAST_DAY', '' 
go
add_domain_values   'PropertyTemplateType', 'CommodityCertificate', 'Templates for various market sectors of Commodity Certificates' 
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'CreateModifyCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'CreateModifyCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'CreateModifyCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'CreateModifyCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'CreateModifyCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'RemoveCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'RemoveCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'RemoveCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'RemoveCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'RemoveCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'RevertCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'RevertCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'RevertCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'RevertCA', 0 )
go
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'RevertCA', 0 )
go
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionCEV', 'CEV_VALUATION_METHOD', 'HAGAN_WOODWARD_HIGHORDER' )
go
delete from pricer_measure where measure_name='W_VEGA' and measure_id=240
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'W_VEGA', 'tk.core.PricerMeasure', 240, 'Weighted vega calculated by weighting volatility' )
go
delete from pricer_measure where measure_name='W_MOD_VEGA' and measure_id=241
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'W_MOD_VEGA', 'tk.core.PricerMeasure', 241, 'Weighted modified vega calculated by weighting volatility' )
go
delete from pricer_measure where measure_name = 'MDELTA_AT_UP_BARRIER'
go
delete from pricer_measure where measure_name = 'MDELTA_AT_DOWN_BARRIER'
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_AT_UP_BARRIER', 'tk.core.PricerMeasure', 226 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_AT_DOWN_BARRIER', 'tk.core.PricerMeasure', 227 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'D_CEV_ALPHA', 'tk.core.PricerMeasure', 280, 'CEV model Alpha' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'D_CEV_BETA', 'tk.core.PricerMeasure', 281, 'CEV model Beta' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BID_ASK_SPREAD', 'tk.core.PricerMeasure', 245 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'WAL', 'tk.core.PricerMeasure', 278 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NVEGA_BPVOL', 'tk.core.PricerMeasure', 284 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_RECOVERY', 'tk.core.PricerMeasure', 288 )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LOWER_PAR_STRIKE', 'tk.core.PricerMeasure', 289, 'DF weighted average strike' )
go
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'UPPER_PAR_STRIKE', 'tk.core.PricerMeasure', 290, 'DF weighted average strike' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'UPPER_BOUND_VOL_SURF', 'java.lang.Double', '', 'Upper bound while solving for implied volatility in voltality surface generation', 0 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'CEV_VALUATION_METHOD', 'java.lang.String', 'EXACT,HAGAN_WOODWARD_HIGHORDER,HAGAN_WOODWARD_LOWORDER,ANDERSON_RADCLIFFE_DD', 'Valaution methodology for Europena option pricing', 1, 'VALUATION_METHOD', 'HAGAN_WOODWARD_HIGHORDER' )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ( 'COMM_PROD_USE_MISSING_POLICY', 'java.lang.Boolean', 'true,false', 'Whether to use a Missing Historical Price Policy to find Commodity and FX resets when pricing Commodity trades', 'COMM_PROD_USE_MISSING_POLICY', 'false', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ( 'PM_PROD_USE_MISSING_POLICY', 'java.lang.Boolean', 'true,false', 'Whether to use a Missing Historical Price Policy to find FX resets when pricing Precious Metal trades', 'PM_PROD_USE_MISSING_POLICY', 'false', 1 )
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BUCKET_TYPE', 'java.lang.String', 'A,HW', 'Bucketing method for CDO OFM loss grid calculation', 1, 'A' )
go

delete from report_win_def where win_def_id = 126
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 126, 'ComparisonAnalysis', 0, 0, 0 )
go
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 127, 'CloseBusinessDay', 0, 0, 0 )
go

INSERT INTO send_config ( send_config_id, advice_status, product_type, advice_type, address_method, gateway, send_b, save_b, publish_b, by_gateway_b, by_method_b ) VALUES ( 1, 'TO_SEND', 'ALL', 'CONFIRM', 'SWIFT', 'SWIFT', 1, 1, 0, 1, 0 )
go
DELETE FROM domain_values WHERE name = 'FXOption.Pricer' and value = 'PricerFXOption'
go



/* Update Patch Version */
UPDATE calypso_info
       SET  patch_version='003',
	   version_date='20071120'
go

