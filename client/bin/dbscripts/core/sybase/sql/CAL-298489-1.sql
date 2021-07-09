if not exists (select 1 from sysobjects where type ='U' and name ='psheet_leg_link')
begin
exec ('create table psheet_leg_link (strategy   varchar(128) not null,
selected_id   numeric not null,
relative_selected_id   numeric default 0 not null  ,
prop_name   varchar(128) not null,
ref_id   numeric not null,
relative_ref_id   numeric  default 0 not null  ,
ref_prop_name   varchar(128) not null,
operator   varchar(32) not null,
operand   float  null,
unit  varchar(128) null,
cell1_to_cell2_link_state   varchar(128)  not null  ,
cell2_to_cell1_link_state   varchar(128) not null,
system_defined   numeric  default 0 not null  ,
is_editable   numeric  default 1 not null ,
variable_operand  varchar(1) null)')
end
go

create procedure psheet_exp_del_link_migration  
as
begin
declare @ref_id numeric ,@operator varchar(32) ,@c12 varchar(128) ,@c21  varchar(128) 
declare psheet_crsr cursor
 for
   select ref_id,operator, cell1_to_cell2_link_state ,cell2_to_cell1_link_state  from psheet_leg_link where strategy = 'OTB' and prop_name = 'Delivery Date' and ref_prop_name = 'Expiry Date' and
  operator IN ('CALCULATE_EXPIRY_DATE', 'CALCULATE_DELIVERY_DATE', 'EQUAL_TO', 'CALCULATE_EXPIRY_DATE_T1', 'CALCULATE_DELIVERY_DATE_T1')
   open psheet_crsr
    fetch psheet_crsr into @ref_id ,@operator ,@c12 ,@c21  
 while (@@sqlstatus=0)
 begin 
  IF(NOT(@c12 = 'Disabled' AND @c21  = 'Disabled'))  
  begin
    IF(@operator = 'CALCULATE_EXPIRY_DATE' OR @operator = 'CALCULATE_DELIVERY_DATE')
      insert into trade_keyword values(@ref_id, 'ExpiryDeliveryLink', 'On')    
    ELSE 
	if (@operator = 'CALCULATE_EXPIRY_DATE_T1' OR @operator = 'CALCULATE_DELIVERY_DATE_T1') 
      insert into trade_keyword values(@ref_id, 'ExpiryDeliveryLink', 'T+1') 
	ELSE
	  insert into trade_keyword values(@ref_id, 'ExpiryDeliveryLink', 'Equal') 
   end
   end
   fetch psheet_crsr into @ref_id ,@operator ,@c12 ,@c21  
 
 close psheet_crsr
deallocate cursor psheet_crsr
end

go

exec psheet_exp_del_link_migration 
go
drop procedure psheet_exp_del_link_migration
go

 
 