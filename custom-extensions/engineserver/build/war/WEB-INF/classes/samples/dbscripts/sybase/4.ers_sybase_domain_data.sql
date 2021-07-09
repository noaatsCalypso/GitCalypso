INSERT INTO domain_values (name,value,description) VALUES('engineName','RiskEngineBroker','ERS')
go
INSERT INTO domain_values (name,value,description) VALUES('engineName','ERSWebServiceEngine',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventRiskRequest',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventRiskEngineLogMsg',' ')
go

INSERT INTO engine_config (engine_id,engine_name,engine_comment,version_num) VALUES(-1 ,'RiskEngineBroker','', 1)
go
UPDATE engine_config set engine_id = (SELECT MAX(engine_id) + 1 FROM engine_config) WHERE engine_name = 'RiskEngineBroker' AND engine_id = -1
go
INSERT INTO engine_config (engine_id,engine_name,engine_comment,version_num) VALUES(-1 ,'ERSWebServiceEngine','', 1)
go
UPDATE engine_config set engine_id = (SELECT MAX(engine_id) + 1 FROM engine_config) WHERE engine_name = 'ERSWebServiceEngine' AND engine_id = -1
go
INSERT INTO ps_event_config(event_config_name,event_class,engine_name)VALUES('Back-Office','PSEventRiskRequest','RiskEngineBroker')
go

INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_EOD_ARCHIVE','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_ANALYSIS','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_UPDATE_HIST_SCENARIOS','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_HOUSEKEEPING','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_RISK_IMPORT','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_TRANSFER_RESULTS','')
go
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_RESULT_AGGREGATE','')
go

INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSHierarchy','permission to Create and Modify portfolio hierarchy')
go
INSERT INTO domain_values (name,value,description) VALUES('function','RunERSAdhoc','permission to Run Adhoc analysis in ERS')
go
INSERT INTO domain_values (name,value,description) VALUES('function','ViewERSJobs','permission to View ERS Job Viewer')
go
INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSBatch','permission to Create and Modify ERS overnight batch')
go
INSERT INTO domain_values (name,value,description) VALUES('function','AllowERSMakeOfficial','permission to make ERS adhoc report results official')
go
INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSRiskAttribution','permission to Create and Modify risk attribution')
go
INSERT INTO domain_values (name,value,description) VALUES('function','UseERSManagementConsole','permission to use ERS Management Console')
go
INSERT INTO domain_values (name,value,description) VALUES('function','ViewERSHierarchy','permission to view ERS portfolio hierarchy')
go
INSERT INTO domain_values (name,value,description) VALUES('function','ERSApproveRiskParameter','permission to authorise ERS hierarchy and risk attributions')
go



insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSHierarchy',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'RunERSAdhoc',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ViewERSJobs',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSBatch',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'AllowERSMakeOfficial',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSRiskAttribution',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'UseERSManagementConsole',0)
go
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ViewERSHierarchy',0)
go

insert into domain_values (name,value) values ('domainName','workflowRuleERSReport')
go
insert into domain_values (name,value) values ('domainName','ERSReportStatus')
go
insert into domain_values (name,value) values ('domainName','ERSReportAction')
go
insert into domain_values (name,value) values ('workflowType','ERSReport')
go
insert into domain_values (name,value) values ('workflowRuleERSReport','ERSManualCheck')
go
insert into domain_values (name,value) values ('ERSReportAction','UPDATE')
go
insert into domain_values (name,value) values ('ERSReportStatus','NEEDS_CORRECTION')
go
insert into domain_values (name,value) values ('ERSReportStatus','PENDING')
go
insert into domain_values (name,value) values ('ERSReportStatus','VERIFIED')
go
insert into domain_values (name,value) values ('ERSReportStatus','INVESTIGATION')
go

insert into domain_values (name,value) values ('ersAnalysisPostprocessorClass','risk.util.postproc.PLVectorAggregation')
go
insert into domain_values (name,value) values ('ersAnalysisPostprocessorClass','risk.util.postproc.PLVectorAggregationSens:*')
go

INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventLimitDataWarehouseImport',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventLimitDataWarehouseExport',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventLimitDataWarehousePreDeal',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventERSLimitDataWarehouseCMLImport',' ')
go
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventERSLimitDataWarehouseExposureEvent',' ')
go

insert into domain_values (name,value) values ('domainName','RMS_Cycle')
go

