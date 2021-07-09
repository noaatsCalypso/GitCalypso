declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='LiquidityPositionPersistenceEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'LiquidityPositionPersistenceEngine','Liquidity Server Connector' );
end if;
end;
/

declare 
cnt number;
begin
   select count(*) into cnt from engine_config where engine_name='LiquidityPositionPersistenceEngine';
	 if( cnt != 0 ) then 
    select count(*) into cnt from engine_param where engine_name='LiquidityPositionPersistenceEngine';
    if( cnt = 0 ) then
      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','CLASS_NAME','com.calypso.tk.liquidity.positionkeeping.processing.engine.LiquidityPositionPersistenceEngine');
      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','DISPLAY_NAME','Liquidity Server Connector');
      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','INSTANCE_NAME','liquidityserver');
      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','STARTUP','false');    
    end if;
	end if;	
end;
/

declare 
n int ; 
c int;
begin
select nvl(max(engine_id)+1,0) into n from engine_config;
select count(*) into c from engine_config where engine_name='FTPEngine' ;
if c = 0 then
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (n,'FTPEngine','FTPEngine' );
end if;
end;
/

declare 
cnt number;
begin
   select count(*) into cnt from engine_config where engine_name='FTPEngine';
	 if( cnt != 0 ) then 
    select count(*) into cnt from engine_param where engine_name='FTPEngine';
    if( cnt = 0 ) then
      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','CLASS_NAME','com.calypso.engine.ftp.FTPEngine');
      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','DISPLAY_NAME','FTP Engine');
      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','INSTANCE_NAME','engineserver');
      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','STARTUP','false');    
    end if;
	end if;	
end;
/

declare 
ev_conf_name ps_event_config.event_config_name%TYPE ; 
begin
	select event_config_name into ev_conf_name from ps_event_cfg_name where is_default_b=1;
	if(ev_conf_name is not null) then
		delete from ps_event_config where engine_name='LiquidityPositionPersistenceEngine' and event_config_name=ev_conf_name;
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventTrade');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessTrade');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventTransfer');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessTransfer');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventRateReset');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventPriceFixing');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventMessage');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessMessage');
	end if;
end;
/

declare 
ev_conf_name ps_event_config.event_config_name%TYPE ; 
begin
	select event_config_name into ev_conf_name from ps_event_cfg_name where is_default_b=1;
	if(ev_conf_name is not null) then
		delete from ps_event_config where engine_name='FTPEngine' and event_config_name=ev_conf_name;
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'FTPEngine','PSEventTrade');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'FTPEngine','PSEventProcessTrade');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'FTPEngine','PSEventLiquidatedPosition');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'FTPEngine','PSEventAggLiquidatedPosition');
		INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (ev_conf_name,'FTPEngine','PSEventRateReset');
	end if;
end;
/

declare 
ev_conf_name ps_event_config.event_config_name%TYPE ; 
begin
	select event_config_name into ev_conf_name from ps_event_cfg_name where is_default_b=1;
	if(ev_conf_name is not null) then
		delete from ps_event_filter where engine_name='LiquidityPositionPersistenceEngine' and event_config_name=ev_conf_name and event_filter in ('LiquidityContextPositionEventFilter') ;
		INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES (ev_conf_name,'LiquidityPositionPersistenceEngine','LiquidityContextPositionEventFilter');
	end if;
end;
/

declare 
ev_conf_name ps_event_config.event_config_name%TYPE ; 
begin
	select event_config_name into ev_conf_name from ps_event_cfg_name where is_default_b=1;
	if(ev_conf_name is not null) then
		delete from ps_event_filter where engine_name='FTPEngine' and event_config_name=ev_conf_name and event_filter in ('FTPEngineEventFilter') ;
		INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES (ev_conf_name,'FTPEngine','FTPEngineEventFilter');
	end if;
end;
/