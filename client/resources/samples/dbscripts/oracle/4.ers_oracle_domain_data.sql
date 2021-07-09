INSERT INTO domain_values (name,value,description) VALUES('engineName','RiskEngineBroker','ERS')
;
INSERT INTO domain_values (name,value,description) VALUES('engineName','ERSWebServiceEngine',' ')
;
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventRiskRequest',' ')
;
INSERT INTO domain_values (name,value,description) VALUES('eventClass','PSEventRiskEngineLogMsg',' ')
;

INSERT INTO engine_config (engine_id,engine_name,engine_comment,version_num) VALUES(-1 ,'RiskEngineBroker','', 1)
;
UPDATE engine_config set engine_id = (SELECT MAX(engine_id) + 1 FROM engine_config) WHERE engine_name = 'RiskEngineBroker' AND engine_id = -1
;

INSERT INTO engine_config (engine_id,engine_name,engine_comment,version_num) VALUES(-1 ,'ERSWebServiceEngine','', 1)
;
UPDATE engine_config set engine_id = (SELECT MAX(engine_id) + 1 FROM engine_config) WHERE engine_name = 'ERSWebServiceEngine' AND engine_id = -1
;


INSERT INTO ps_event_config(event_config_name,event_class,engine_name)VALUES('Back-Office','PSEventRiskRequest','RiskEngineBroker')
;

INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_EOD_ARCHIVE','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_ANALYSIS','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_UPDATE_HIST_SCENARIOS','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_HOUSEKEEPING','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_RISK_IMPORT','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_TRANSFER_RESULTS','')
;
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_RESULT_AGGREGATE','')
;

INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSHierarchy','permission to Create and Modify portfolio hierarchy')
;
INSERT INTO domain_values (name,value,description) VALUES('function','RunERSAdhoc','permission to Run Adhoc analysis in ERS')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ViewERSJobs','permission to View ERS Job Viewer')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSBatch','permission to Create and Modify ERS overnight batch')
;
INSERT INTO domain_values (name,value,description) VALUES('function','AllowERSMakeOfficial','permission to make ERS adhoc report results official')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ModifyERSRiskAttribution','permission to Create and Modify risk attribution')
;
INSERT INTO domain_values (name,value,description) VALUES('function','UseERSManagementConsole','permission to use ERS Management Console')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ViewERSHierarchy','permission to view ERS portfolio hierarchy')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ERSApproveRiskParameter','permission to authorise ERS hierarchy and risk attributions')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ERSRMSWorkflowPending','permission to authorise Pending to RMS exceptions')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ERSRMSWorkflowAnalysed','permission to authorise Analysed to RMS exceptions')
;
INSERT INTO domain_values (name,value,description) VALUES('function','ERSRMSWorkflowReviewed','permission to authorise Reviewed to RMS exceptions')
;

insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSHierarchy',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'RunERSAdhoc',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ViewERSJobs',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSBatch',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'AllowERSMakeOfficial',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ModifyERSRiskAttribution',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'UseERSManagementConsole',0)
;
insert into group_access (group_name,access_id,access_value,read_only_b) values ('calypso_group', 1, 'ViewERSHierarchy',0)
;

insert into domain_values (name,value) values ('domainName','workflowRuleERSReport')
;
insert into domain_values (name,value) values ('domainName','ERSReportStatus')
;
insert into domain_values (name,value) values ('domainName','ERSReportAction')
;
insert into domain_values (name,value) values ('workflowType','ERSReport')
;
insert into domain_values (name,value) values ('workflowRuleERSReport','ERSManualCheck')
;
insert into domain_values (name,value) values ('ERSReportAction','UPDATE')
;
insert into domain_values (name,value) values ('ERSReportStatus','NEEDS_CORRECTION')
;
insert into domain_values (name,value) values ('ERSReportStatus','PENDING')
;
insert into domain_values (name,value) values ('ERSReportStatus','VERIFIED')
;
insert into domain_values (name,value) values ('ERSReportStatus','INVESTIGATION')
;

insert into domain_values (name,value) values ('ersAnalysisPostprocessorClass','risk.util.postproc.PLVectorAggregation')
;
insert into domain_values (name,value) values ('ersAnalysisPostprocessorClass','risk.util.postproc.PLVectorAggregationSens:*')
;

insert into domain_values (name,value) values ('domainName','RMS_Cycle')
;

delete from domain_values where name='ERSRiskServer.engines' and value='DataWarehouseRiskEngine'
;
begin
add_domain_values('ERSRiskServer.engines','DataWareHouseRiskEngine','' );
end;
/
delete from domain_values where name='engineName' and value='DataWarehouseRiskEngine'
;
insert into domain_values (name, value) values ('engineName', 'DataWareHouseRiskEngine', 'ERS')
;

update domain_values set value ='DataWareHouseRiskEngine'  where value='DataWarehouseRiskEngine'
;

update engine_config set engine_name = 'DataWareHouseRiskEngine' where engine_name = 'DataWarehouseRiskEngine'
;
