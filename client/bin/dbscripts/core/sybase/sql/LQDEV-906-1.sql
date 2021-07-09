
update main_entry_prop set property_value='contextposition.setup.ContextPositionSetupManager' where property_value = 'configuration.split.SplitConfigurationWindow$contextposition.mo.ContextPositionBucketConfigObjectLoader'
go
update ctxt_pos_bucket_conf set ctxt_pos_type = 'FIXED_CASH' where ctxt_pos_type ='CASH'
go

create procedure prod_contx_pos
as
begin
declare @cnt int ,
@sql varchar(500)
select @cnt=count(*) from sysobjects where sysobjects.name = 'product_context_position'
if @cnt=1
select @sql = 'update product_context_position set ctxt_pos_type='||char(39)||'FIXED_CASH'||char(39)||' where ctxt_pos_type ='||char(39)||'CASH'||char(39)
exec (@sql)
end
go

exec prod_contx_pos
go

update an_param_items set attribute_name = 'FIXED_CASH_CONTEXTS_TO_ADD_COUNT' where attribute_name = 'CASH_CONTEXTS_TO_ADD_COUNT' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go
update an_param_items set attribute_name = 'FIXED_'+attribute_name where attribute_name like 'CASH_CONTEXTS_TO_ADD_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go
update an_param_items set attribute_name = 'FIXED_CASH_CONTEXTS_TO_SUBTRACT_COUNT' where attribute_name = 'CASH_CONTEXTS_TO_SUBTRACT_COUNT' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go
update an_param_items set attribute_name = 'FIXED_'+attribute_name where attribute_name like 'CASH_CONTEXTS_TO_SUBTRACT_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go

create procedure updateLadderParams 
as
begin
declare @param_name varchar(60), @class_name varchar(60), @ctxt_pos_space varchar(60)
declare c1  cursor for  
	select param.param_name param_name ,param.class_name class_name ,coalesce(fil.ctxt_pos_space,'INTRADAY_LIQUIDITY') ctxt_pos_space from  an_param_items param left outer join  ctxt_pos_filter fil on ( convert(int,param.attribute_value) = fil.cxt_pos_filter_id )
	where class_name = 'com.calypso.tk.risk.ForwardLadderParam' and attribute_name='ContextPositionFilterId' and convert(int,attribute_value) > 0
	open c1
    fetch c1 into @param_name, @class_name , @ctxt_pos_space
 while (@@sqlstatus=0)
 begin
	if not exists (select 1 from an_param_items a where a.attribute_name='FORWARD_LADDER_RUN_MODE' and a.param_name= @param_name and a.class_name=@class_name)
	begin
		IF (@ctxt_pos_space = 'INTRADAY_LIQUIDITY')
			begin
				insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values ( @param_name,@class_name,'FORWARD_LADDER_RUN_MODE','INTRADAY_MODE')
			end
		else
			begin
				if exists (select 1 from an_param_items a where a.attribute_value='true' and a.param_name= @param_name and a.class_name=@class_name and attribute_name='LoadFuturePositions')
				begin
					insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values (@param_name,@class_name,'FORWARD_LADDER_RUN_MODE','SHORTTERM_POSITIONS_MODE')
				end
				else if exists (select 1 from an_param_items a where a.attribute_value='false' and a.param_name= @param_name and a.class_name=@class_name and attribute_name='LoadFuturePositions')
				begin
					insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values (@param_name,@class_name,'FORWARD_LADDER_RUN_MODE','SHORTTERM_TRADES_MODE')
				end
				else if not exists (select 1 from an_param_items a where a.param_name= @param_name and a.class_name=@class_name and attribute_name='LoadFuturePositions')
				begin
					insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values (@param_name,@class_name,'FORWARD_LADDER_RUN_MODE','INTRADAY_MODE')
				end
			end 					
	end
	fetch c1 into @param_name, @class_name, @ctxt_pos_space
 End
 close c1
 	begin
	 	update  ctxt_pos_filter set ctxt_pos_space = 'SHORT_TERM_LIQUIDITY' where ctxt_pos_space ='INTRADAY_LIQUIDITY'
		update  ctxt_pos_filter set cash_ctxt_pos_config_id = -2 where cash_ctxt_pos_config_id = -4
		update  ctxt_pos_filter set sec_ctxt_pos_config_id = -1 where sec_ctxt_pos_config_id = -5 	
 	end
deallocate cursor c1
end
go
exec updateLadderParams
go
drop procedure updateLadderParams
go

update ctxt_pos_bucket_conf set ctxt_pos_space = 'SHORT_TERM_LIQUIDITY' where ctxt_pos_space ='INTRADAY_LIQUIDITY'
go

update an_param_items set attribute_value = str_replace(attribute_value,'INTRADAY_LIQUIDITY.','SHORT_TERM_LIQUIDITY.') where attribute_name like '%_CONTEXTS_TO_SUBTRACT_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go
update an_param_items set attribute_value = str_replace(attribute_value,'INTRADAY_LIQUIDITY.','SHORT_TERM_LIQUIDITY.') where attribute_name like '%_CONTEXTS_TO_ADD_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
go

if exists (select 1 from sysobjects where name ='ctxt_pos_mov_attributes' and type='U')
begin
delete from liq_ctxt_pos_reinit_job
delete from liq_ctxt_pos_reinit_task
end
go
