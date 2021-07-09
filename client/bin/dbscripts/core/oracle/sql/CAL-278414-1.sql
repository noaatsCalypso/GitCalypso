delete from AN_VIEWER_CONFIG where ANALYSIS_NAME='CrossAssetPL' and VIEWER_CLASS_NAME='apps.risk.CrossAssetPLAnalysisViewer'
;
ALTER TABLE sched_task ADD external_ref varchar2(255) NULL
;
     
create or replace procedure sched_task_extref as
begin
declare cursor c1 is select task_id, task_type from sched_task
where external_ref is null ;
begin
  for c1_rec in c1 loop
    update sched_task set external_ref = concat(concat(task_type , '_'), 
            (select count(*)+1 from sched_task where task_type = c1_rec.task_type and external_ref> ' ' ))
    where task_id = c1_rec.task_id;
  end loop;
commit;
end;
end sched_task_extref;
;
     
begin
 sched_task_extref;
end;
;
     
DROP PROCEDURE sched_task_extref
;
     
ALTER TABLE sched_task MODIFY external_ref NOT NULL
;

 

begin
 drop_procedure_if_exists ('sp_cal_upd_proc');
end;
;

begin
drop_procedure_if_exists ('sp_is_processed');
end;
;

begin
drop_procedure_if_exists ('sp_save_event');
end;
;

alter table product_seclending add (fee_type varchar2(20) null)
;
alter table prd_seclend_hist add (fee_type varchar2(20) null)
;
UPDATE PRODUCT_SECLENDING SET FEE_TYPE = 'Percentage rate' WHERE FEE_TYPE NOT IN ('Percentage rate', 'Amount per million', 'Absolute amount')
;
UPDATE PRD_SECLEND_HIST SET FEE_TYPE = 'Percentage rate' WHERE FEE_TYPE NOT IN ('Percentage rate', 'Amount per million', 'Absolute amount')
;
alter table product_seclending modify fee_type not null
;
alter table prd_seclend_hist modify fee_type not null
;


UPDATE product_repo SET substitution_b = 1 WHERE product_id IN
  (SELECT product_repo.product_id FROM product_desc, product_repo
   WHERE product_repo.product_id = product_desc.product_id
   AND product_desc.product_type = 'Repo'
   AND product_repo.buysellback_b = 0
   AND product_repo.hold_in_custody_b = 0
   AND product_repo.single_coll_b = 0)
;


UPDATE bo_transfer SET available=1 WHERE transfer_type='SECURITY' AND trade_id in
  (SELECT trade_id FROM trade WHERE product_id in
  (SELECT PRODUCT_ID FROM product_repo WHERE SUBSTITUTION_B = 1 ))
;


INSERT INTO domain_values ( name, value, description ) VALUES (
  'volSurfaceGenerator', ' CMSBasisAdj', ' Allows a quote adjustment and
 the related point adjustment surface to store a matrix of volatility
 adjustments representing the basis between swaption and CMS swaps' )
;

DELETE FROM pricer_measure where measure_name = 'DELTA_AT_DOWN_BARRIER'
;
DELETE FROM pricer_measure where measure_name = 'DELTA_AT_UP_BARRIER'
;

INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment)
  VALUES  ('DELTA_AT_UP_BARRIER','tk.core.PricerMeasure',224,'Delta when spot is at barrier')  
;

INSERT INTO pricer_measure (measure_name,measure_class_name,measure_id,measure_comment)
  VALUES('DELTA_AT_DOWN_BARRIER','tk.core.PricerMeasure',225,'Delta when spot is at barrier') 
;

INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_product_config', 1)
;
INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) VALUES (1000, 'mcc_intraday_param_config', 1)
;
INSERT INTO report_win_def (win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color)
  VALUES(128, 'MCCStatistics', 0, 0, 1)
;

alter table pricer_measure modify measure_comment varchar2(255)
;
delete from an_viewer_config where analysis_name='Composite' and read_viewer_b = 0
;
insert into an_viewer_config (analysis_name, viewer_class_name, read_viewer_b) values 
    ('Composite', 'apps.risk.CompositeAnalysisReportFrameworkViewer',0)
;

delete from wfw_transition where workflow_id in (500, 501, 502)
;

INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES
   (500, 'LegalEntity', 'NONE', 'NEW', 'PENDING', 0, 1, 'ALL', 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES 
   (502, 'LegalEntity', 'PENDING', 'AMEND', 'VERIFIED', 1, 1, 'ALL', 0, 0, 0, 0 )
;
INSERT INTO wfw_transition ( workflow_id, event_class, status, possible_action, resulting_status, use_stp_b, same_user_b,
   product_type, log_completed_b, kick_cutoff_b, create_task_b, update_only_b ) VALUES 
   (501, 'LegalEntity', 'NONE', 'AMEND', 'PENDING', 0, 1, 'ALL', 0, 0, 0, 0 )
;



INSERT INTO book_attribute ( attribute_name, comments ) VALUES ( 'VALUATION_TIMEZONES', 'Valuation Timezones' )
;
INSERT INTO bo_workflow_rule ( id, rule_name ) VALUES ( 18, 'HandleAckNack' )
;
INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 20000, 'DefaultServer', 'ReferenceEntityLite', 0, 'Calypso', 'LFU' )
;
INSERT INTO calypso_cache ( limit, app_name, limit_name, expiration, implementation, eviction ) VALUES ( 10000, 'DefaultClient', 'ReferenceEntityLite', 0, 'NonTransactional', 'LFU' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'curve_underlying', 'cu_fx_fixed', 'cu_id', 'cu_id', 'Curve', 'NONE' )
;
INSERT INTO db_relation ( parent_table, child_table, parent_cols, child_cols, relation_category, special_comment ) VALUES ( 'product_bond', 'abs_collateral_group', 'product_id', 'product_id', 'Product', 'NONE' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageType', 'ACC_SEC_STATEMENT', 'Security Account Statement Text/Html Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageType', 'ACC_SEC_POS_STATEMENT', 'Security Account Statement Swift (MT535)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageType', 'ACC_SEC_TRAN_STATEMENT', 'Security Account Statement Swift (MT536)' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Types', 'TradeAudit', 'TradeAudit Report' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'SpotDateCalculator', 'This defines the name of the java class in the package com.calypso.tk.util that performs the date calculation logic' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'SpotDateCalculatorForSource', 'This allows to restrict usage of the SpotDateCalculator to specific source only' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'BBAShiftCalendar', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rateIndexAttributes', 'BBAShiftDateRoll', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'FOLLOWING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'MOD_FOLLOW', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'PRECEDING', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'MOD_PRECED', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'NO_CHANGE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'END_MONTH', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'IMM_MON', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'IMM_WED', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'MOD_SUCC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'BBAShiftDateRoll', 'SFE', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SpotDateCalculator', 'BBARateIndexSpotDateCalculator', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SpotDateCalculatorForSource', 'BBA', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'FXSpotBlotter', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'FXSpotBlotter', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'FwdLadder', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'FwdLadder', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'AmendGroup', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'RemoveGroup', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'disableReportTableFiltering', 'Reports where table filtering conflicts with other feature and should be disabled' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'Account', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'LegalEntity', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'IndustryHierarchy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'Strategy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'FundStrategy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'disableReportTableFiltering', 'StrategyAttribute', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'ViewOnlyMergeCounterParties', 'Allows users to view only merge counterparties tab in Process Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'restriction', 'ViewOnlyMergeCounterParties', 'Allows users to view only merge counterparties tab in Process Trade' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'MessageAttributeCopier', 'Specify the Message Attribute Copier' )
;
INSERT INTO domain_values ( name, value ) VALUES ( 'MessageAttributeCopier', 'Default' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'SABRDirectBpVols', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'volSurfaceGenerator', 'SwaptionCEV', 'Calibrates the CEV model to a swaption smile' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'VolSurface.gensimple', 'CEVSimple', 'Holds the model parameters for the CEV model' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'MsgAttributes', 'NackReason', 'Nack Reason' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'rate_index_type', 'Swap', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'engineParam', 'VALUATION_TIMEZONES', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'REPORT.Functions', 'Constant', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'tradeTerminationAction', 'Actions to be carried out from the TerminationWindow' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'GenericOption.extendedType', 'CommoditySwap2', 'To identify the CS2 underlying product in pricer config for GenericOption' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'CommodityReset', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'liquidationKeyword', 'Strategy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'liquidationKeyword', 'Long/Short', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'liquidationKeyword', 'Custodian', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'feeCalculator', 'MarginPtsPVBaseZD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT103', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT202', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT210', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT210BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT305', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT320', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT509', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT509GSCC', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT515', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT518', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT527', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT540', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT540BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT541', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT541BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT542', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT542BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT543', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT543BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT544', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT544BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT545', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT545BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT546', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT546BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT547', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT547BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT548', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT900', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT900BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT910', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'ExternalMessageField.MessageMapper', 'MT910BONY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'classAuditMode', 'FixingDatePolicy', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'workflowRuleMessage', 'HandleAckNack', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageStatus', 'TO_SEND', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CurvePrepay.PrepaymentModel', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'Swaption.Pricer', 'PricerSwaptionCEV', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'CreateModifyCA', 'Access permission to create/modify CA product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RemoveCA', 'Access permission to remove CA product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'RevertCA', 'Access permission to remove CA product' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'function', 'AssignCptyOnXfer', 'Access permission to change the counterparty of a transfer when doing an ASSIGN' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'messageType', 'ACK_MSG', 'Swift Message Acknoledgement' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskPresenter', 'SyntheticHedge', 'Syhthetic Hedge Analysis' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'riskAnalysis', 'WhatIf', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'StepIn_Transferor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Novation_Transferor', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Novation_Transferee', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Novation_Remaining', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'tradeKeyword', 'Novation_Transfer_Role', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'systemKeyword', 'PartialNovatedTo', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'SWIFT.Templates', 'MT518', 'Security Confirmation' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityFixingDatePolicy', 'Custom Fixing Date Policy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency', 'Custom Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'Whole', 'Whole' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'Periodic', 'Periodic' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'FutureContractLTD', 'FutureContractLTD' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'Bullet', 'Bullet' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency', 'Daily', 'Daily' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityAveragingPolicy', 'Custom Averaging Policy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingPolicy', 'Standard', 'Standard' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingPolicy', 'Cumulative', 'Cumulative' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingPolicy', 'ATC', 'ATC' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingPolicy', 'CTA', 'CTA' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingPolicy', 'CTAWithFXRoll', 'CTAWithFXRoll' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityFXAveragingRoundingPolicy', 'Custom FX AveragingRounding Policy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingRoundingPolicy', 'Average', 'Average' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingRoundingPolicy', 'Conversion', 'Conversion' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingRoundingPolicy', 'Both', 'Both' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityFXAveragingRoundingPolicy', 'DontRound', 'DontRound' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityAveragingRoundingPolicy', 'Custom AveragingRounding Policy' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingRoundingPolicy', 'Average', 'Average' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityAveragingRoundingPolicy', 'DontRound', 'DontRound' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.Bullet', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Bullet', 'BULLET', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.Whole', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Whole', 'WHOLE_PERIOD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.Daily', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Daily', 'WHOLE_PERIOD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Daily', 'FIRST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Daily', 'LAST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.Contract', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Contract', 'CONTRACT', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'domainName', 'CommodityPaymentFrequency.Periodic', 'Fixing Date Policy for Payment Frequency' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Periodic', 'WHOLE_PERIOD', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Periodic', 'FIRST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'CommodityPaymentFrequency.Periodic', 'LAST_DAY', '' )
;
INSERT INTO domain_values ( name, value, description ) VALUES ( 'PropertyTemplateType', 'CommodityCertificate', 'Templates for various market sectors of Commodity Certificates' )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'CreateModifyCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'CreateModifyCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'CreateModifyCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'CreateModifyCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'CreateModifyCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'RemoveCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'RemoveCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'RemoveCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'RemoveCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'RemoveCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'admin', 1, 'RevertCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'calypso_group', 1, 'RevertCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'operationnal', 1, 'RevertCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'sales', 1, 'RevertCA', 0 )
;
INSERT INTO group_access ( group_name, access_id, access_value, read_only_b ) VALUES ( 'trader', 1, 'RevertCA', 0 )
;
INSERT INTO pc_param ( pricer_config_name, pricer_name, param_name, param_value ) VALUES ( 'default', 'PricerSwaptionCEV', 'CEV_VALUATION_METHOD', 'HAGAN_WOODWARD_HIGHORDER' )
;
delete from pricer_measure where measure_name='W_VEGA' and measure_id=240
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'W_VEGA', 'tk.core.PricerMeasure', 240, 'Weighted vega calculated by weighting volatility' )
;
delete from pricer_measure where measure_name='W_MOD_VEGA' and measure_id=241
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'W_MOD_VEGA', 'tk.core.PricerMeasure', 241, 'Weighted modified vega calculated by weighting volatility' )
;
delete from pricer_measure where measure_name = 'MDELTA_AT_UP_BARRIER'
;
delete from pricer_measure where measure_name = 'MDELTA_AT_DOWN_BARRIER'
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_AT_UP_BARRIER', 'tk.core.PricerMeasure', 226 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'MDELTA_AT_DOWN_BARRIER', 'tk.core.PricerMeasure', 227 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'D_CEV_ALPHA', 'tk.core.PricerMeasure', 280, 'CEV model Alpha' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'D_CEV_BETA', 'tk.core.PricerMeasure', 281, 'CEV model Beta' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'BID_ASK_SPREAD', 'tk.core.PricerMeasure', 245 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'WAL', 'tk.core.PricerMeasure', 278 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'NVEGA_BPVOL', 'tk.core.PricerMeasure', 284 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id ) VALUES ( 'AVG_RECOVERY', 'tk.core.PricerMeasure', 288 )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'LOWER_PAR_STRIKE', 'tk.core.PricerMeasure', 289, 'DF weighted average strike' )
;
INSERT INTO pricer_measure ( measure_name, measure_class_name, measure_id, measure_comment ) VALUES ( 'UPPER_PAR_STRIKE', 'tk.core.PricerMeasure', 290, 'DF weighted average strike' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b ) VALUES ( 'UPPER_BOUND_VOL_SURF', 'java.lang.Double', '', 'Upper bound while solving for implied volatility in voltality surface generation', 0 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) VALUES ( 'CEV_VALUATION_METHOD', 'java.lang.String', 'EXACT,HAGAN_WOODWARD_HIGHORDER,HAGAN_WOODWARD_LOWORDER,ANDERSON_RADCLIFFE_DD', 'Valaution methodology for Europena option pricing', 1, 'VALUATION_METHOD', 'HAGAN_WOODWARD_HIGHORDER' )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ( 'COMM_PROD_USE_MISSING_POLICY', 'java.lang.Boolean', 'true,false', 'Whether to use a Missing Historical Price Policy to find Commodity and FX resets when pricing Commodity trades', 'COMM_PROD_USE_MISSING_POLICY', 'false', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, display_name, default_value, is_global_b ) VALUES ( 'PM_PROD_USE_MISSING_POLICY', 'java.lang.Boolean', 'true,false', 'Whether to use a Missing Historical Price Policy to find FX resets when pricing Precious Metal trades', 'PM_PROD_USE_MISSING_POLICY', 'false', 1 )
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, default_value ) VALUES ( 'BUCKET_TYPE', 'java.lang.String', 'A,HW', 'Bucketing method for CDO OFM loss grid calculation', 1, 'A' )
;

delete from report_win_def where win_def_id = 126
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 126, 'ComparisonAnalysis', 0, 0, 0 )
;
INSERT INTO report_win_def ( win_def_id, def_name, use_book_hrchy, use_pricing_env, use_color ) VALUES ( 127, 'CloseBusinessDay', 0, 0, 0 )
;

INSERT INTO send_config ( send_config_id, advice_status, product_type, advice_type, address_method, gateway, send_b, save_b, publish_b, by_gateway_b, by_method_b ) VALUES ( 1, 'TO_SEND', 'ALL', 'CONFIRM', 'SWIFT', 'SWIFT', 1, 1, 0, 1, 0 )
;
DELETE FROM domain_values WHERE name = 'FXOption.Pricer' and value = 'PricerFXOption'
;


/* Update Patch Version */
UPDATE calypso_info
       SET patch_version='003',	
	   patch_date=TO_DATE('20/11/2007 12:00:00','DD/MM/YYYY HH-MI-SS')
;
