if  exists (select 1 from sysobjects where name='liq_domain_attributes')
begin
print 'table found'
declare @x int ,@sql1 varchar(500),@sql2 varchar(500),@sql3 varchar(500),@sql4 varchar(500),@sql5 varchar(500),@sql6 varchar(500),@sql7 varchar(500),
@sql8 varchar(500),@sql9 varchar(500),@sql10 varchar(500),@sql11 varchar(500),@sql12 varchar(500),@sql13 varchar(500),@sql14 varchar(500),
@sql15 varchar(500),@sql16 varchar(500),@sql17 varchar(500),@sql18 varchar(500),@sql19 varchar(500),@sql20 varchar(500),@sql21 varchar(500)

select @sql1 = 'select @x = count(name) FROM liq_domain_attributes WHERE name like '||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_%'||char(39)
exec (@sql1)
if (@x = 0)
begin
	print 'table has no data'

	select @sql3 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_2'||char(39)||','||char(39)||'-2'||char(39)||','||char(39)||'system'||char(39)||',1)'	
    select @sql4 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_3'||char(39)||','||char(39)||'-3'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql5 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_4'||char(39)||','||char(39)||'-5'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql6 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_5'||char(39)||','||char(39)||'-6'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql7 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_6'||char(39)||','||char(39)||'-8'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql8 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_7'||char(39)||','||char(39)||'-11'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql9 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_8'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql10 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_9'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql11 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_10'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql12 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_11'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql13 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_12'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'	
    select @sql14 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_13'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql15 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_14'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql16 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_15'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
	select @sql17 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_16'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql18 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_17'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql19 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_18'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql20 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_19'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
    select @sql21 = 'insert into liq_domain_attributes (name,value,user_name,version) values ('||char(39)||'LIQUIDITY_MOVEMENT_ATTRIBUTE_20'||char(39)||','||char(39)||'0'||char(39)||','||char(39)||'system'||char(39)||',1)'
	exec (@sql3)
	exec (@sql4)
    exec (@sql5)
    exec (@sql6)
	exec (@sql7)
	exec (@sql8)
	exec (@sql9)
	exec (@sql10)
	exec (@sql11)
    exec (@sql12)
	exec (@sql13)
	exec (@sql14)
	exec (@sql15)
	exec (@sql16)
    exec (@sql17)
	exec (@sql18)
	exec (@sql19)
	exec (@sql20)
	exec (@sql21)

end
else 
begin
	print 'table has data'
end

end

begin
print 'table not found'
end
go


if exists  (select 1 from sysobjects where name ='context_position_movements')
begin
if  not exists (select 1 from sysobjects o, syscolumns c where o.name='context_position_movements' and c.name='attrib_1' and o.id=c.id)
begin
DECLARe @x numeric, @sql1 varchar(1000), @sql2 varchar(500),@sql3 varchar(500), @sql4 varchar(500)
print 'column doesnt exist'
    select @sql1= 'alter table context_position_movements add attrib_1 varchar(64) null, attrib_2 varchar(64) null,
	attrib_3 varchar(64) null,attrib_4 varchar(64) null,attrib_5 varchar(64) null,attrib_6 varchar(64) null,attrib_7 varchar(64) null,
	attrib_8 varchar(64) null ,attrib_9 varchar(64) null,attrib_10 varchar(64) null,attrib_11 varchar(64) null,attrib_12 varchar(64) null ,
	attrib_13 varchar(64) null,attrib_14 varchar(64) null,attrib_15 varchar(64) null,attrib_16 varchar(64) null,attrib_17 varchar(64) null,
	attrib_18 varchar(64) null,attrib_19 varchar(64) null,attrib_20 varchar(64) null'
    exec (@sql1) 
	print 'column added'

end          
end
go

if exists (select 1 from sysobjects where name = 'ctxt_pos_mov_attributes')
begin
DECLARe @x numeric, @sql1 varchar(1000), @sql2 varchar(500),@sql3 varchar(500), @sql4 varchar(500)	
select 'table doesnt exist'
select @sql2 = 'select @x = count(1) FROM ctxt_pos_mov_attributes'
exec (@sql2)
 IF @x > 0    
begin
	select 'table is not empty' 
   select @sql3 = 'update context_position_movements set  attrib_1=ctxt_pos_mov_attributes.attrib_1 ,attrib_2=ctxt_pos_mov_attributes.attrib_2,attrib_3=ctxt_pos_mov_attributes.attrib_3,attrib_4=ctxt_pos_mov_attributes.attrib_4,attrib_5=ctxt_pos_mov_attributes.attrib_5,attrib_6=ctxt_pos_mov_attributes.attrib_6,attrib_7=ctxt_pos_mov_attributes.attrib_7,attrib_8=ctxt_pos_mov_attributes.attrib_8,attrib_9=ctxt_pos_mov_attributes.attrib_9,attrib_10=ctxt_pos_mov_attributes.attrib_10,attrib_11=ctxt_pos_mov_attributes.attrib_11,attrib_12=ctxt_pos_mov_attributes.attrib_12,attrib_13=ctxt_pos_mov_attributes.attrib_13,attrib_14=ctxt_pos_mov_attributes.attrib_14,attrib_15=ctxt_pos_mov_attributes.attrib_15,attrib_16=ctxt_pos_mov_attributes.attrib_16,attrib_17=ctxt_pos_mov_attributes.attrib_17,attrib_18=ctxt_pos_mov_attributes.attrib_18,attrib_19=ctxt_pos_mov_attributes.attrib_19,attrib_20=ctxt_pos_mov_attributes.attrib_20 from ctxt_pos_mov_attributes where ctxt_pos_mov_attributes.movement_id = context_position_movements.movement_id'
    exec (@sql3)
   select @sql4= 'truncate table ctxt_pos_mov_attributes' 
	exec (@sql4)
end  
end
go

if exists  (select 1 from sysobjects where name='product_context_position')
begin
 truncate table product_context_position 
  truncate table ctxt_pos_mov_product_map 
 
end
go
create procedure update_context_pos
as
begin
declare @minProdId numeric , @startIndex  numeric , @maxProdId numeric , @endIndex numeric
 
 select @minProdId = min(product_id),@maxProdId = max(product_id) FROM product_desc where product_type='ContextPosition' 
 select @startIndex =  @minProdId 
 
 while (@startIndex <= @maxProdId)
 begin
 select @endIndex = @startIndex + 1000              
 delete from settle_position_change where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex) 
 delete from settle_position where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex)
 delete from settle_position_snapshot where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex)
 delete from position where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex)
 delete from position_snapshot where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex)
 delete from product_desc where  product_type='ContextPosition' and product_id >= @startIndex and product_id <= @endIndex  
 select @startIndex = @endIndex +1
  end

end
go

exec update_context_pos
go


