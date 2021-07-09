begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='LiquidityPositionPersistenceEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'LiquidityPositionPersistenceEngine','Liquidity Server Connector' )
end
end
go

begin 
declare @cnt int
begin
   select @cnt=count(*) from engine_config where engine_name='LiquidityPositionPersistenceEngine'
	 if( @cnt != 0 ) 
	 begin
		select @cnt=count(*) from engine_param where engine_name='LiquidityPositionPersistenceEngine'
	    if( @cnt = 0 ) 
	      begin
		      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','CLASS_NAME','com.calypso.tk.liquidity.positionkeeping.processing.engine.LiquidityPositionPersistenceEngine')
		      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','DISPLAY_NAME','Liquidity Server Connector')
		      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','INSTANCE_NAME','liquidityserver')
		      insert into engine_param (engine_name,param_name,param_value) values ('LiquidityPositionPersistenceEngine','STARTUP','false')    
	      end
	 end
	end 	
end
go

begin
declare @n int 
declare @c int 
select @n=max(engine_id)+1 from engine_config
select @c= count(*) from engine_config where engine_name='FTPEngine'
if @c = 0 
begin
INSERT INTO engine_config ( engine_id, engine_name, engine_comment ) VALUES (@n,'FTPEngine','FTP Engine' )
end
end
go

begin 
declare @cnt int
begin
   select @cnt=count(*) from engine_config where engine_name='FTPEngine'
	 if( @cnt != 0 ) 
	 begin
		select @cnt=count(*) from engine_param where engine_name='FTPEngine'
	    if( @cnt = 0 ) 
	      begin
		      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','CLASS_NAME','com.calypso.engine.ftp.FTPEngine')
		      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','DISPLAY_NAME','FTP Engine')
		      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','INSTANCE_NAME','engineserver')
		      insert into engine_param (engine_name,param_name,param_value) values ('FTPEngine','STARTUP','false')   
	      end
	 end
	end 	
end
go


begin 
declare @ev_conf_name varchar(32) 
begin
	select @ev_conf_name=event_config_name from ps_event_cfg_name where is_default_b=1
	if @ev_conf_name is not null 
		begin
			delete from ps_event_config where engine_name='LiquidityPositionPersistenceEngine' and event_config_name=@ev_conf_name
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventTrade')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessTrade')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventTransfer')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessTransfer')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventRateReset')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventPriceFixing')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventMessage')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','PSEventProcessMessage')			
		end 
end
end
go

begin 
declare @ev_conf_name varchar(32) 
begin
	select @ev_conf_name=event_config_name from ps_event_cfg_name where is_default_b=1
	if @ev_conf_name is not null 
		begin
			delete from ps_event_config where engine_name='FTPEngine' and event_config_name=@ev_conf_name
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'FTPEngine','PSEventTrade')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'FTPEngine','PSEventProcessTrade')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'FTPEngine','PSEventLiquidatedPosition')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'FTPEngine','PSEventAggLiquidatedPosition')
			INSERT INTO ps_event_config ( event_config_name, engine_name, event_class ) VALUES (@ev_conf_name,'FTPEngine','PSEventRateReset')
		end 
end
end
go

begin 
declare @ev_conf_name varchar(32) 
begin
	select @ev_conf_name=event_config_name from ps_event_cfg_name where is_default_b=1
	if @ev_conf_name is not null 
		begin
			delete from ps_event_filter where engine_name='LiquidityPositionPersistenceEngine' and event_config_name=@ev_conf_name and event_filter in ('LiquidityContextPositionEventFilter')
			INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES (@ev_conf_name,'LiquidityPositionPersistenceEngine','LiquidityContextPositionEventFilter')
		end 
end
end
go

begin 
declare @ev_conf_name varchar(32) 
begin
	select @ev_conf_name=event_config_name from ps_event_cfg_name where is_default_b=1
	if @ev_conf_name is not null 
		begin
			delete from ps_event_filter where engine_name='FTPEngine' and event_config_name=@ev_conf_name and event_filter in ('FTPEngineEventFilter')
			INSERT INTO ps_event_filter ( event_config_name, engine_name, event_filter ) VALUES (@ev_conf_name,'FTPEngine','FTPEngineEventFilter')
		end 
end
end
go
