if exists (select 1 from sysobjects where name ='custom_rule_discriminator' and type='SF')
begin
exec ('drop function custom_rule_discriminator')
end
go
CREATE FUNCTION custom_rule_discriminator(@name VARCHAR(255))
RETURNS VARCHAR(255)
AS
if(patindex('%MessageRule%', @name) != 0)
BEGIN
RETURN 'MessageRule'
END
if(patindex('%TradeRule%', @name) != 0)
BEGIN
RETURN 'TradeRule'
END
if(patindex('%TransferRule%', @name) != 0)
BEGIN
RETURN 'TransferRule'
END
if(patindex('%WorkFlowRule%', @name) != 0)
BEGIN
RETURN 'WorkFlowRule'
END
RETURN 'error'
go

if exists (select 1 from sysobjects where name ='calypso_width_bucket' and type='SF')
begin
exec ('drop function calypso_width_bucket')
end
go

CREATE FUNCTION calypso_width_bucket(
	@expression FLOAT,
	@mini FLOAT,
	@maxi FLOAT,
	@num_buckets INT)
RETURNS INT
AS
DECLARE @fraction int
DECLARE @counter int
IF @expression is null
BEGIN
RETURN null
END
IF @expression < @mini
BEGIN
RETURN 0
END
ELSE IF @expression >= @maxi
BEGIN
SELECT @counter = @num_buckets + 1
RETURN @counter
END
SELECT @fraction = (@maxi - @mini) / @num_buckets
SELECT @counter = 1
WHILE @expression >= @mini + @counter * @fraction
BEGIN
SELECT @counter = @counter + 1
END
RETURN @counter
go


if exists (select 1 from sysobjects where name = 'sp_save_liq_pos'
                                    and type = 'P')
   begin
     exec('drop procedure sp_save_liq_pos')
   end
go
if exists (select 1 from sysobjects where name = 'sp_save_pl_pos'
                                    and type = 'P')
   begin
     exec('drop procedure sp_save_pl_pos')
   end
go
if exists (select 1 from sysobjects where name = 'sp_analysis_out_permp'
                                    and type = 'P')
   begin
     exec('drop procedure sp_analysis_out_permp')
   end
go
if exists (select 1 from sysobjects where name = 'sp_mcc_housekeeping
'
                                    and type = 'P')
   begin
     exec('drop procedure sp_mcc_housekeeping
')
   end
go

if exists (select 1 from sysobjects where name = 'sp_next_seed'
                                    and type = 'P')
   begin
     exec('drop procedure sp_next_seed')
   end
go

if exists (select 1 from sysobjects where name = 'sp_is_processed'
                                    and type = 'P')
   begin
     exec ('drop procedure sp_is_processed')
   end
go

if exists (select 1 from sysobjects where name = 'sp_upd_bo_transfer_status'
                                    and type = 'P')
   begin
     exec('drop procedure sp_upd_bo_transfer_status')
   end
go

 
if exists (select 1 from sysobjects where name = 'sp_save_trade'
                                    and type = 'P')
   begin
exec ('DROP PROCEDURE sp_save_trade')
end
go
if exists (select 1 from sysobjects where name = 'sp_update_trade' and type='P') 
begin 
exec('DROP PROCEDURE sp_update_trade')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_xferrule' and type='P') begin 
exec('DROP PROCEDURE sp_save_xferrule')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_proddesc' and type='P') begin 
exec('DROP PROCEDURE sp_save_proddesc')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_proddesc' and type='P') 
begin 
exec('DROP PROCEDURE sp_upd_proddesc')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_openqty' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_openqty')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_le_contact' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_le_contact')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_legent' and type='P') begin 
exec('DROP PROCEDURE sp_save_legent')
end
go
if exists (select 1 from sysobjects where name = 'sp_update_quote' and type='P') 
begin 
exec('DROP PROCEDURE sp_update_quote')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_quote' and type='P') begin 
exec('DROP PROCEDURE sp_save_quote')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_bo_task' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_bo_task')
end
go
if exists (select 1 from sysobjects where name = 'sp_update_bo_task' and type='P') 
begin 
exec('DROP PROCEDURE sp_update_bo_task')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_bo_transfer' and type='P') begin 
exec('DROP PROCEDURE sp_upd_bo_transfer')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_bo_message' and type='P') begin 
exec('DROP PROCEDURE sp_upd_bo_message')
end
go
if exists (select 1 from sysobjects where name = 'sp_next_in_sequence' and type='P') begin 
exec('DROP PROCEDURE sp_next_in_sequence')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_invsecpos' and type='P') begin 
exec('DROP PROCEDURE sp_upd_invsecpos')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_invcashpos' and type='P') begin 
exec('DROP PROCEDURE sp_upd_invcashpos')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_evtrade' and type='P') begin 
exec('DROP PROCEDURE sp_save_evtrade')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_evposting' and type='P') begin 
exec('DROP PROCEDURE sp_save_evposting')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_evtask' and type='P') begin 
exec('DROP PROCEDURE sp_save_evtask')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_bo_cre' and type='P') begin exec('DROP PROCEDURE sp_upd_bo_cre')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_stat_cre' and type='P') begin 
exec('DROP PROCEDURE sp_upd_stat_cre')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_balpos' and type='P') begin 
exec('DROP PROCEDURE sp_upd_balpos')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_balpos_fxamounts' and type='P') 
begin 
exec('DROP PROCEDURE sp_upd_balpos_fxamounts')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_mrgcashpos' and type='P') begin exec('DROP PROCEDURE sp_upd_mrgcashpos')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_mrgsecpos' and type='P') begin exec('DROP PROCEDURE sp_upd_mrgsecpos')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_evcre' and type='P') begin exec('DROP PROCEDURE sp_save_evcre')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_xfer_attr' and type='P') begin exec('DROP PROCEDURE sp_upd_xfer_attr')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_mess_attr' and type='P') begin 
exec('DROP PROCEDURE sp_upd_mess_attr')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_group_access' and type='P') begin exec('DROP PROCEDURE sp_upd_group_access')
end
go
if exists (select 1 from sysobjects where name = 'sp_upd_usr_perm' and type='P') begin 
exec('DROP PROCEDURE sp_upd_usr_perm')
end
go

if exists (select 1 from sysobjects where name = 'sp_upd_book_products' and type='P') begin 
exec('DROP PROCEDURE sp_upd_book_products')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evmessage' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evmessage')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evtrade' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evtrade')
end
go
if exists (select 1 from sysobjects where name = 'sp_save_evxfer' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evxfer')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evcre' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evcre')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evposting' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evposting')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evtask' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evtask')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_evtinmes' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_evtinmes')
end
go

if exists (select 1 from sysobjects where name = 'sp_save_pl_pos' and type='P') 
begin 
exec('DROP PROCEDURE sp_save_pl_pos')
end
go



CREATE PROCEDURE sp_upd_bo_transfer(
        @transfer_id      		numeric,
        @event_type			varchar(64),
        @transfer_status	 	varchar(32),
        @trade_id			numeric,
        @product_id			numeric,
        @product_family		 	varchar(32),
        @product_type		 	varchar(32),
        @transfer_type		        varchar(32),
        @amount				float,
        @amount_ccy			 varchar(3),
        @trade_ccy			 varchar(3),
        @payreceive_type	         varchar(16),
        @value_date			 datetime,
        @settle_date		 datetime,
        @ext_le_id 		numeric,
        @ext_le_role 		varchar(32),
        @ext_sdi		numeric,
        @ext_agent_le_id		numeric,
        @ext_sdi_status		varchar(32),
        @int_sdi	numeric,
        @int_agent_le_id	numeric,
        @int_sdi_status	varchar(32),
        @gl_account_id			numeric,
        @netting_key                     varchar(32),
        @delivery_type 			varchar(8),
        @start_time_limit  		 numeric,
        @other_amount			float,
        @book_id				numeric,
        @available			numeric,
        @trade_date			datetime,
        @netted_transfer                 numeric,
        @netted_transfer_id              numeric,
        @bundle_id			 numeric,
        @int_le_id 		numeric,
        @int_le_role 		varchar(32),
        @xfer_action				varchar(32),
        @real_settle_amount		float,
        @is_known			numeric,
        @settlement_method		varchar(32),
        @is_fixed			numeric,
        @is_return			numeric,
        @is_payment			numeric,
        @cash_account_id		numeric,
        @avail_date			datetime,
        @int_cash_sdi			numeric,
        @ext_cash_sdi			numeric,
        @real_cash_amount		 float,
        @linked_id			numeric,
        @description                    VARCHAR(255),
        @orig_cpty_id                   numeric,
        @manual_sdi                     numeric,
        @manual_cash_sdi                numeric,
        @trade_version    numeric,
        @int_sdi_version      numeric,
        @ext_sdi_version   numeric,
        @nominal_amount float,
        @version_num numeric,
	@booking_date datetime,
	@netted_trade_id   numeric,
		@callable_date datetime,
		@int_cash_agent_le_id       numeric,
	@sub_sec_account_id       numeric,
	@sub_cash_account_id       numeric,
	@old_version_num numeric )
AS

UPDATE  bo_transfer SET
        event_type=@event_type,
        transfer_status=@transfer_status,
        trade_id	=@trade_id	,
        product_id=@product_id,
        product_family=@product_family,
        product_type=@product_type,
        transfer_type=@transfer_type,
        amount	=@amount	,
        amount_ccy=@amount_ccy,
        trade_ccy=@trade_ccy,
        payreceive_type=@payreceive_type,
        value_date=@value_date,
        settle_date=@settle_date,
        ext_le_id=@ext_le_id,
        ext_le_role=@ext_le_role,
        ext_sdi=@ext_sdi,
        ext_agent_le_id=@ext_agent_le_id,
        ext_sdi_status=@ext_sdi_status,
        int_sdi=@int_sdi,
        int_agent_le_id=@int_agent_le_id,
        int_sdi_status=@int_sdi_status,
        gl_account_id=@gl_account_id,
        netting_key=@netting_key,
        delivery_type=@delivery_type,
        start_time_limit=@start_time_limit,
        other_amount=@other_amount,
        book_id=@book_id,
        available=@available,
        trade_date=@trade_date,
        netted_transfer=@netted_transfer,
        netted_transfer_id=@netted_transfer_id,
        bundle_id=@bundle_id,
        int_le_id=@int_le_id,
        int_le_role=@int_le_role,
        xfer_action=@xfer_action,
        real_settle_amount=@real_settle_amount,
        is_known=@is_known,
        settlement_method=@settlement_method,
        is_fixed = @is_fixed,
        is_return = @is_return,
        is_payment = @is_payment,
        cash_account_id = @cash_account_id,
        avail_date=@avail_date,
        int_cash_sdi = @int_cash_sdi,
        ext_cash_sdi = @ext_cash_sdi,
        real_cash_amount = @real_cash_amount,
        linked_id = @linked_id,
        description=@description,
        orig_cpty_id=@orig_cpty_id,
        manual_sdi=@manual_sdi,
        manual_cash_sdi=@manual_cash_sdi ,
        trade_version=@trade_version,
        int_sdi_version=@int_sdi_version ,
        ext_sdi_version=@ext_sdi_version ,
        nominal_amount=@nominal_amount,
        version_num=@version_num,
	booking_date=@booking_date,
		netted_trade_id=@netted_trade_id,
		callable_date=@callable_date,
		int_cash_agent_le_id=@int_cash_agent_le_id,
sub_sec_account_id=@sub_sec_account_id,
	sub_cash_account_id=@sub_cash_account_id
	 
WHERE 	transfer_id =@transfer_id AND
	version_num=@old_version_num
if (@@rowcount != 1 )
begin
      raiserror 20001 'Bad transfer version. Transfer Id=%1!',@transfer_id
       return  1
end
return  0
go

exec sp_procxmode 'sp_upd_bo_transfer', 'anymode'
go





CREATE PROCEDURE sp_next_in_sequence(@result numeric(22) output,
                              @seed_name varchar(32),
                              @count_seed numeric)
AS
BEGIN TRAN
UPDATE calypso_seed SET last_id = last_id + @count_seed
    WHERE seed_name=@seed_name
IF (@@rowcount = 0)
   BEGIN
      INSERT INTO calypso_seed (last_id,seed_name) VALUES (1000,@seed_name)
      UPDATE calypso_seed SET last_id = last_id + @count_seed
          WHERE seed_name=@seed_name
   END

SELECT @result = (SELECT last_id from calypso_seed WHERE seed_name=@seed_name)
COMMIT TRAN
go

exec sp_procxmode 'sp_next_in_sequence', 'anymode'
go






CREATE PROCEDURE sp_upd_balpos(
        @account_id        numeric,
        @currency_code     varchar(3),
        @date_type         varchar(16),
        @position_date     datetime,
        @total_amount       float,		
        @change             float,
		@fx_amount          float,
		@fx_change          float,
        @security_id        numeric)
AS
UPDATE balance_position
SET total_amount = @total_amount,change = @change,fx_amount = @fx_amount,fx_change = @fx_change 
WHERE position_date = @position_date AND
        account_id = @account_id AND
        date_type= @date_type AND
        currency_code = @currency_code

IF (@@rowcount = 0)
    INSERT INTO  balance_position(account_id ,date_type,position_date,
        currency_code,total_amount,change,fx_amount,fx_change,security_id)
    VALUES(@account_id ,@date_type,@position_date,
        @currency_code,@total_amount,@change,@fx_amount,@fx_change,@security_id)
go

exec sp_procxmode 'sp_upd_balpos', 'anymode'
go

CREATE PROCEDURE sp_upd_group_access(@group_name VARCHAR(255),
                                   @access_id numeric,
                                   @access_value VARCHAR(255),
                                   @read_only_b	numeric)

AS



UPDATE group_access
       SET group_name=@group_name,
       read_only_b=@read_only_b
       WHERE group_name=@group_name
       AND access_id=@access_id
       AND access_value=@access_value

IF (@@rowcount = 0)
Begin
        INSERT INTO group_access(group_name,access_id,access_value,read_only_b)
        VALUES(@group_name,@access_id,@access_value,@read_only_b)
End
go

exec sp_procxmode 'sp_upd_group_access', 'anymode'
go


CREATE PROCEDURE sp_upd_usr_perm(@user_name VARCHAR(255),
                                   @version_num numeric,
                                   @auto_logout numeric)

AS


UPDATE  usr_access_perm
       SET user_name=@user_name,version_num=@version_num, auto_logout=@auto_logout

IF (@@rowcount = 0)
INSERT INTO  usr_access_perm(user_name,version_num, auto_logout)
 VALUES(@user_name,@version_num, @auto_logout)

go

exec sp_procxmode 'sp_upd_usr_perm', 'anymode'
go














CREATE PROCEDURE sp_upd_bo_transfer_status(@arg_transfer_status varchar(32),
                                           @arg_xfer_action varchar(32),
                                           @arg_version_num numeric,
                                           @arg_transfer_id numeric,
                                           @arg_old_version_num numeric)

AS
   UPDATE bo_transfer SET transfer_status=@arg_transfer_status,
                          xfer_action=@arg_xfer_action,
                          version_num=@arg_version_num
   WHERE transfer_id=@arg_transfer_id AND version_num=@arg_old_version_num
   IF (@@rowcount != 1)
   BEGIN
       raiserror 20001 'Bad transfer version. Transfer Id=%1!',@arg_transfer_id
   END
go

exec sp_procxmode 'sp_upd_bo_transfer_status', 'anymode'
go





if exists (select 1 from sysobjects where name='rate_index_string_value' and type='SF')
begin
exec ('drop function rate_index_string_value')
end
go

if exists (select 1 from sysobjects where name='rate_index_string_value' and type='V')
begin
exec ('drop view rate_index_string_value')
end
go

create view rate_index_string_value as select rate_index_id, 
str_replace(substring(quote_name, charindex('.', quote_name) + 1, len(quote_name)), '.', '/') string_value 
from rate_index 
go

CREATE PROCEDURE sp_upd_balpos_fxamounts(
        @account_id          numeric,        
        @date_type           varchar(16),
        @position_date       datetime,
		@currency_code       varchar(3),
        @amount              float,		
        @change              float,
		@from_currency_code  varchar(3))
AS
UPDATE balance_pos_fxamounts
SET amount = @amount,change = @change
WHERE position_date = @position_date AND
        account_id = @account_id AND
        date_type= @date_type AND
        currency_code = @currency_code AND
		from_currency_code = @from_currency_code

IF (@@rowcount = 0)
    INSERT INTO  balance_pos_fxamounts(account_id ,date_type,position_date,
        currency_code,amount,change,from_currency_code )
    VALUES(@account_id ,@date_type,@position_date,
        @currency_code,@amount,@change,@from_currency_code)
go

exec sp_procxmode 'sp_upd_balpos_fxamounts', 'anymode'
go


if exists (select 1 from sysobjects where name = 'sp_trunc_temp_tables' and type = 'P')
begin
    exec ('DROP PROCEDURE sp_trunc_temp_tables')
end
go
create procedure sp_trunc_temp_tables
as
begin
exec ('DELETE FROM trade_filter_page')
exec ('DELETE FROM tf_temp_table')
end
go
exec sp_procxmode 'sp_trunc_temp_tables', 'anymode'

go

create  procedure sp_analysis_out_permp (@id numeric)
as 
begin
declare @rnum numeric
declare @page_id numeric 
declare c1 cursor  
for 
select page_id  from analysis_output_perm_pages where id = @id order by page_id
select @rnum = 0 
open c1
fetch c1 into @page_id
while (@@sqlstatus != 2)
begin    

update analysis_output_perm_pages
set page_number = @rnum where analysis_output_perm_pages.page_id = @page_id and analysis_output_perm_pages.id = @id
set @rnum = @rnum + 1

fetch c1 into @page_id
end
close c1
deallocate cursor c1
end
go

exec sp_procxmode 'sp_analysis_out_permp', 'anymode'
go
if exists (select 1 from sysobjects where name = 'sp_insert_official_pl_bucket'
                                    and type = 'P')
   begin
     exec('drop procedure sp_insert_official_pl_bucket')
   end
go
CREATE procedure sp_insert_official_pl_bucket
     ( 
        @pl_bucket_id        numeric,                
        @leg                  varchar(64),                  
        @location             varchar(64), 
        @strip_date           datetime, 
        @subproduct_id         numeric, 
        @subproduct_type       varchar(64),                
        @subproduct_sub_type   varchar(64),                
        @subproduct_extended_type   varchar(64),              
        @existing_pl_bucket_id        numeric output              
     ) 
AS 

BEGIN  
	select @existing_pl_bucket_id = pl_bucket_id
			from   	official_pl_bucket
			where (leg = @leg or ((leg is null) and (@leg is null)))
			and		(location = @location or ((location is null) and (@location is null)))
			and		(strip_date = @strip_date or ((strip_date is null) and (@strip_date is null)))
			and		(subproduct_id = @subproduct_id or ((subproduct_id is null) and (@subproduct_id is null)))
			and		(subproduct_type = @subproduct_type or ((subproduct_type is null) and (@subproduct_type is null)))
			and		(subproduct_sub_type = @subproduct_sub_type or ((subproduct_sub_type is null) and (@subproduct_sub_type is null)))
			and		(subproduct_extended_type = @subproduct_extended_type or ((subproduct_extended_type is null) and (@subproduct_extended_type is null)))
    if (@existing_pl_bucket_id is null) 
    begin
    	exec ('insert into official_pl_bucket 
    		(pl_bucket_id,leg,location,strip_date,
    		subproduct_id,subproduct_type,subproduct_sub_type,subproduct_extended_type) 
    	values 
    		(@pl_bucket_id,@leg,@location,@strip_date,
    		@subproduct_id,@subproduct_type,@subproduct_sub_type,@subproduct_extended_type) ')
        
        select @existing_pl_bucket_id=@pl_bucket_id
	end
			
END 
go
exec sp_procxmode 'sp_insert_official_pl_bucket', 'anymode'
go

if exists (select 1 from sysobjects where name = 'sp_insert_official_pl_unit'
                                    and type = 'P')
   begin
     exec('drop procedure sp_insert_official_pl_unit')
   end
go
create procedure sp_insert_official_pl_unit
     ( 
        @pl_unit_id         numeric ,                
        @book_id            numeric ,                  
        @strategy            varchar(32), 
        @trader              varchar(32), 
        @desk                varchar(32), 
        @currency            varchar(3),                
        @currency_pair       varchar(7),                
        @po_id               numeric,                
        @is_by_trade         numeric,
		 @existing_pl_unit_id  numeric output
     ) 
	 
	 as 

begin  

	select  
              @existing_pl_unit_id = pl_unit_id
        from   	official_pl_unit
          where 	(book_id = @book_id or ((book_id is null) and (@book_id is null)))
          and		(strategy = @strategy or ((strategy is null) and (@strategy is null)))
          and		(trader = @trader or ((trader is null) and (@trader is null)))
          and		(desk = @desk or ((desk is null) and (@desk is null)))
          and  		currency = @currency
          and		(currency_pair = @currency_pair or ((currency_pair is null) and (@currency_pair is null)))
          and		po_id = @po_id
          and		is_by_trade = @is_by_trade

	if (@existing_pl_unit_id is null)
	begin
		exec ('insert into official_pl_unit 
			(pl_unit_id,book_id,strategy,trader,desk,
			currency,currency_pair,po_id,is_by_trade) 
		values 
			(@pl_unit_id,@book_id,@strategy,@trader,@desk,
			@currency,@currency_pair,@po_id,@is_by_trade)')
		
		select @existing_pl_unit_id = @pl_unit_id
	end

END 
go


exec sp_procxmode 'sp_insert_official_pl_unit', 'anymode'
go



