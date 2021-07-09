
DROP INDEX ers_addon.IDX_ers_addon
GO
ALTER TABLE ers_analysis_config DROP CONSTRAINT PK_ers_analysisconfig
GO
ALTER TABLE ers_batch DROP CONSTRAINT UNIQ_ers_batch
GO
ALTER TABLE ers_event DROP CONSTRAINT PK_ers_event
GO

ALTER TABLE ers_exposure DROP CONSTRAINT PK_ers_exposure
GO
ALTER TABLE ers_exposure DROP CONSTRAINT ers_exposure
GO

DROP INDEX ers_exposure.IDX1_ers_exposure 
GO
DROP INDEX ers_exposure.IDX2_ers_exposure 
GO
DROP INDEX ers_exposure.IDX3_ers_exposure 
GO
DROP INDEX ers_exposure.IDX4_ers_exposure 
GO

ALTER TABLE ers_exposure_measure DROP CONSTRAINT PK_ers_exposure_measure
GO
ALTER TABLE ers_grouping DROP CONSTRAINT PK_ers_grouping
GO
ALTER TABLE ers_hierarchy DROP CONSTRAINT PK_ers_hierarchy
GO
ALTER TABLE ers_hierarchy_attribute DROP CONSTRAINT PK_ers_hierarchyattr
GO

ALTER TABLE ers_hierarchy_msg DROP CONSTRAINT PK_ers_hierarchymsg
GO

ALTER TABLE ers_info DROP CONSTRAINT PK_ersinfo
GO

DROP INDEX ers_legal_parent.IDX_ers_legal_parent 
GO

ALTER TABLE ers_limit DROP CONSTRAINT UNIQ_ers_limit
GO

DROP INDEX ers_limit.IDX1_ers_limit 
GO


ALTER TABLE ers_limit_adjustment DROP CONSTRAINT UNIQ_ers_limit_adjustment
GO

DROP INDEX ers_limit_adjustment.IDX_ers_limit_adjustment 
GO

DROP INDEX ers_limit_breach.IDX_ers_limit_breach
GO
DROP INDEX ers_limit_drilldown.IDX_ers_limit_drilldown
GO

ALTER TABLE ers_limit_job DROP CONSTRAINT UNIQ_ers_limit_job
GO

DROP INDEX ers_limit_settle_drilldown.IDX_ers_limit_settle_drilldown
GO

DROP INDEX ers_limit_usage.IDX_ers_limit_usage
GO

DROP INDEX ers_log.IDX_ers_log
GO

ALTER TABLE ers_measure_config DROP CONSTRAINT PK_ers_measure_config
GO

DROP INDEX ers_netting_group.IDX_ers_netting_group
GO


DROP INDEX ers_predeal_check.IDX_ers_predeal_check
GO

ALTER TABLE ers_rate_archive DROP CONSTRAINT UNIQ_ersratearchive
GO
DROP INDEX ers_result.IDX_ers_result 
GO

DROP INDEX ers_result_drilldown.IDX_ers_result_drilldown
GO

DROP INDEX ers_result_history.IDX_1_ers_result_hist
GO

DROP INDEX ers_result_history.IDX_ers_result_hist
GO

ALTER TABLE ers_measure_config DROP CONSTRAINT PK_ers_measure_config
GO

ALTER TABLE ers_risk_attribution DROP CONSTRAINT UNIQ_ersriskattr
GO


ALTER TABLE ers_run DROP CONSTRAINT PK_ers_run
GO
ALTER TABLE ers_run DROP CONSTRAINT UNIQ_ers_run
GO
ALTER TABLE ers_run_history DROP CONSTRAINT UNIQ_ers_runhist
GO

DROP INDEX ers_run_history.IDX_ers_run_hist
go

ALTER TABLE  ers_run_param DROP CONSTRAINT PK_ers_run_param
GO
ALTER TABLE  ers_scenario DROP CONSTRAINT UNIQ_ersscenario
GO

DROP INDEX ers_scenario.IDX_ers_scenario
GO
ALTER TABLE ers_scenario_rf DROP CONSTRAINT PK_ersscenariorf
GO


ALTER TABLE ers_scenario_rf_quotes DROP CONSTRAINT PK_ersscenariorfquotes
GO

DROP INDEX ers_settlement.IDX_ers_settlement
GO
ALTER TABLE ers_system DROP CONSTRAINT PK_erstradesystemid
GO

ALTER TABLE ers_trade DROP CONSTRAINT PK_ers_trade
GO
DROP INDEX ers_trade.IDX_ers_trade
GO



ALTER TABLE ers_log ADD msglevel varchar(50) default 'dummy' NOT NULL 
GO
ALTER TABLE ers_log ADD msgcategory varchar(50) default 'dummy' NOT NULL 
GO
ALTER TABLE ers_log ADD isexception bit default 0 NOT NULL 
GO
ALTER TABLE ers_log ADD msgtime varchar(35) default '1900-01-01' NOT NULL
GO
update ers_log set msglevel=msgLevel,msgcategory=msgCategory,isexception=isException,msgtime=msgTime
GO
ALTER TABLE ers_log ADD exceptionmsg image NULL 
GO
update ers_log set exceptionmsg = exceptionMsg
GO

ALTER TABLE ers_log DROP msgLevel,msgCategory,isException,msgTime,exceptionMsg
GO

UPDATE ers_info
SET  patch_version='002',
patch_date='20070830'
go

