/* Upgrade Version */
declare 
cnt number;
begin
  select count(*) into cnt from domain_values where name='ERSLimitServer.instances';
  if( cnt = 0 ) then 
		INSERT INTO domain_values ( name, value,description ) values ('ERSLimitServer.instances','enterpriseriskserver','');
		INSERT INTO domain_values ( name, value,description ) values ('ERSLimitServer.instances','erslimitserver','');
  end if;
end;
/

declare 
cnt number;
begin
  select count(*) into cnt from domain_values where name='ERSRiskServer.instances';
  if( cnt = 0 ) then 
		INSERT INTO domain_values ( name, value,description ) values ('ERSRiskServer.instances','enterpriseriskserver','');
		INSERT INTO domain_values ( name, value,description ) values ('ERSRiskServer.instances','ersriskserver','');
  end if;
end;
/
declare 
cnt number;
begin
  select count(*) into cnt from domain_values where name='ERSComplianceServer.instances';
  if( cnt = 0 ) then 
		INSERT INTO domain_values ( name, value,description ) values ('ERSComplianceServer.instances','enterpriseriskserver','');
		INSERT INTO domain_values ( name, value,description ) values ('ERSComplianceServer.instances','erscomplianceserver','');
  end if;
end;
/

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
select count(*) into c from engine_config where engine_name='DataWarehouseRiskEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'DataWarehouseRiskEngine',' ' );
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

