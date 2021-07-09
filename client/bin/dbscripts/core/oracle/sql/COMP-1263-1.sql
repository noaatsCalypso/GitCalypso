ALTER TABLE ersc_job MODIFY (ID varchar2(36))
;
ALTER TABLE ersc_rule_check MODIFY (ID varchar2(36))
;
ALTER TABLE ersc_rule_check_join MODIFY (RULE_ID2 varchar2(36),
										 RULE_CHECK_ID3 varchar2(36))
;
ALTER TABLE ersc_rule_check_result MODIFY (ID varchar2(36),
											CHECK_ID varchar2(36))
;
ALTER TABLE ersc_rule_portfolio MODIFY (ID varchar2(36))
;
ALTER TABLE ersc_rule_portfolio_join MODIFY (RULE_ID0 varchar2(36),
											 RULE_PORTFOLIO_ID1 varchar2(36))
;
ALTER TABLE ersc_rule_result MODIFY (ID varchar2(36),
									 JOB_ID varchar2(36),
									 RULE_ID varchar2(36))
;
ALTER TABLE ersc_rule_result_check_join MODIFY (RULE_RESULT_ID0 varchar2(36),
												RULE_CHECK_RESULT_ID1 varchar2(36))
;
ALTER TABLE ersc_sanction_item MODIFY (ID varchar2(36))
;
ALTER TABLE ersc_rule_sanction_join MODIFY (RULE_ID4 varchar2(36),
											SANCTION_ITEM_ID5 varchar2(36))
;
ALTER TABLE ersc_rule_result_trade MODIFY (ID varchar2(36),
										   RULE_ID varchar2(36),
										   RULE_RESULT_ID varchar2(36))
;
ALTER TABLE ersc_rule_group MODIFY (ID varchar2(36))
;