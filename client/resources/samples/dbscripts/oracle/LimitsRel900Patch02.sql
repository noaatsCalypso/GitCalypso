insert into ers_hierarchy(hierarchy_name,version,node_id,parent_id,node_name,node_data,node_key) values ('Default',1,0, 0,'All','All',65921)
;

insert into ers_hierarchy_attribute(hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version,hierarchy_type) VALUES ('Default', '__ALL__', 14, 1, TO_DATE('26/07/2007','DD/MM/YYYY'), 1, 'Book')
;

update ers_limit set attr2_name = attr1_name
;

update ers_limit set attr2_value = attr1_value
;

update ers_limit set attr1_name = ' '
;

update ers_limit set attr1_value = ' '
;

update ers_limit set attr1_name = hierarchy where service_class='CreditRisk'
;

update ers_limit set attr1_value = node_name where service_class='CreditRisk'
;

update ers_limit set hierarchy = 'Default' where service_class='CreditRisk'
;

update ers_limit set node_name = 'All' where service_class='CreditRisk'
;

update ers_limit set measure = 'Issuer' where measure = 'Notional' and service = 'Issuer Risk'
;


update ers_limit_pending set attr2_name = attr1_name
;

update ers_limit_pending set attr2_value = attr1_value
;

update ers_limit_pending set attr1_name = ' '
;

update ers_limit_pending set attr1_value = ' '
;

update ers_limit_pending set attr1_name = hierarchy where service_class='CreditRisk'
;

update ers_limit_pending set attr1_value = node_name where service_class='CreditRisk'
;

update ers_limit_pending set hierarchy = 'Default' where service_class='CreditRisk'
;

update ers_limit_pending set node_name = 'All' where service_class='CreditRisk'
;

update ers_limit_pending set measure = 'Issuer' where measure = 'Notional' and service = 'Issuer Risk'
;


update ers_limit_authorise set attr2_name = attr1_name
;

update ers_limit_authorise set attr2_value = attr1_value
;

update ers_limit_authorise set attr1_name = ' '
;

update ers_limit_authorise set attr1_value = ' '
;

update ers_limit_authorise set attr1_name = hierarchy where service_class='CreditRisk'
;

update ers_limit_authorise set attr1_value = node_name where service_class='CreditRisk'
;

update ers_limit_authorise set hierarchy = 'Default' where service_class='CreditRisk'
;

update ers_limit_authorise set node_name = 'All' where service_class='CreditRisk'
;

update ers_limit_authorise set measure = 'Issuer' where measure = 'Notional' and service = 'Issuer Risk'
;



update ers_limit_authorise_reject set attr2_name = attr1_name
;

update ers_limit_authorise_reject set attr2_value = attr1_value
;

update ers_limit_authorise_reject set attr1_name = ' '
;

update ers_limit_authorise_reject set attr1_value = ' '
;

update ers_limit_authorise_reject set attr1_name = hierarchy where service_class='CreditRisk'
;

update ers_limit_authorise_reject set attr1_value = node_name where service_class='CreditRisk'
;

update ers_limit_authorise_reject set hierarchy = 'Default' where service_class='CreditRisk'
;

update ers_limit_authorise_reject set node_name = 'All' where service_class='CreditRisk'
;

update ers_limit_authorise_reject set measure = 'Issuer' where measure = 'Notional' and service = 'Issuer Risk'
;



update ers_limit_authorise set authorised_by = user_name
;

update ers_limit_authorise_reject set authorised_by = user_name
;


update ers_limit_adjustment set authorised_by = user_name
;

update ers_limit_adjustment_authorise set authorised_by = user_name
;

update ers_limit_adjustment_reject set authorised_by = user_name
;

update ers_limit_report_detail set report_key = 'category'
where report_key = 'hierarchy'
and report_id in (select report_id from ers_limit_report_detail 
where report_key = 'service' 
and report_value = 'Credit Risk')
;

update ers_limit_report_detail set report_key = 'categoryValue'
where report_key = 'nodeName'
and report_id in (select report_id from ers_limit_report_detail 
where report_key = 'service' 
and report_value = 'Credit Risk')
;


INSERT INTO domain_values (name,value,description) VALUES('workflowRuleTrade','CheckLimit','')
;

INSERT INTO domain_values (name,value,description) VALUES('workflowRuleTrade','CheckLimitBreach','')
;

INSERT INTO domain_values (name,value,description) VALUES('workflowRuleTrade','CheckLimitViolation','')
;

INSERT INTO domain_values (name,value,description) VALUES('workflowRuleTrade','CheckLimitWarningOrViolation','')
;

INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_LIMIT_BATCH','')
;

