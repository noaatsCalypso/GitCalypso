drop_pk_if_exists 'liq_info'
go

begin
	declare @status int, @vsql1 varchar(200) ,@vsql3 varchar(200)
	declare @vsql2 varchar(200) , @ct_name varchar(100),@cnt int
	select @status=status from syscolumns where id=object_id('liq_info') and name='liq_info_id'
	if @status = 128 
		begin 
		exec ('select * into liq_info_back152 from liq_info')
		exec ('alter table liq_info add liq_info_id1 numeric null')
		exec ('update liq_info set liq_info_id1 = liq_info_id')
		exec ('alter table liq_info drop liq_info_id ')
		select @vsql2= 'sp_rename '||char(39)||'liq_info.liq_info_id1'||char(39)||',liq_info_id' 
		exec (@vsql2)
		exec ('alter table liq_info modify liq_info_id numeric not null')
		select @vsql3 = 'delete from calypso_seed where seed_name = '||char(39)||'LiquidationInfo'||char(39)
		exec (@vsql3)
		end
	
	if @status < 128
		begin
		select @cnt = count(*) from liq_info 
		if @cnt > 0 
		begin 
		exec ('select liq_info_id=identity(8),book_id,product_type,liq_config_id into temp2 from liq_info')
		exec ('update liq_info set liq_info.liq_info_id = temp2.liq_info_id from temp2
		where liq_info.book_id=temp2.book_id and  liq_info.product_type=temp2.product_type and liq_info.liq_config_id=temp2.liq_config_id')
		select @vsql3 = 'delete from calypso_seed where seed_name = '||char(39)||'LiquidationInfo'||char(39)
		exec (@vsql3)
		exec ('drop table temp2')
		end
		end
end
go








/* added the seed through xml */

