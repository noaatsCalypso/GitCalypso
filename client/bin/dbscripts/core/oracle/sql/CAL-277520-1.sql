/* Upgrade Version */

/* Fix Risk Attribution Classname issue in HistSim */
update ERS_RISK_ATTRIBUTION set node_class=replace(node_class,'tk.risk.sim.','') where node_class like '%tk.risk.sim.%'
;
alter table 
   ers_grouping 
modify 
   ( 
   attr1_name varchar2(64),
   attr1_value varchar2(64),
   attr2_name varchar2(64),
   attr2_value varchar2(64),
   attr3_name varchar2(64),
   attr3_value varchar2(64),
   attr4_name varchar2(64),
   attr4_value varchar2(64),
   attr5_name varchar2(64),
   attr5_value varchar2(64),
   attr6_name varchar2(64),
   attr6_value varchar2(64),
   attr7_name varchar2(64),
   attr7_value varchar2(64),
   attr8_name varchar2(64),
   attr8_value varchar2(64),
   attr9_name varchar2(64),
   attr9_value varchar2(64),
   group_id varchar2(64)
   )
;

/* Make scenario set description unique CAL-197473 */
update ers_scenario_set set description = scset_id || '-' || description
;

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='RiskEngineBroker' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'RiskEngineBroker',' ' );
end if;
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='DataWareHouseRiskEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'DataWareHouseRiskEngine',' ' );
end if;
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='ERSLimitEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'ERSLimitEngine',' ' );
end if;
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='ERSCreditEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'ERSCreditEngine',' ' );
end if;
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='ERSComplianceEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'ERSComplianceEngine',' ' );
end if;
end;
/
