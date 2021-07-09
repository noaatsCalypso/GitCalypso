if exists (select 1 from sysobjects where name ='add_liqcolumn_if_not_exists' and type='P')
begin
exec ('drop procedure add_liqcolumn_if_not_exists')
end
go

create proc add_liqcolumn_if_not_exists 
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id 
and sysobjects.name = 'liq_external_movement' and syscolumns.name 
not in ('calypso_agent','calypso_account','calypso_processing_org','product_type', 
		'calypso_cpty',
      'calypso_book',
      'calypso_banking_prod' ,
      'other_1' ,
      'other_2' ,
      'other_3' ,
      'other_4' ,
      'other_5' ,
      'other_6' )
exec ('alter table liq_external_movement add calypso_agent varchar(128) null,
      calypso_account varchar(128) null,
      calypso_processing_org varchar(128) null,
      product_type varchar(128) null,
      calypso_cpty varchar(128) null,
      calypso_book varchar(128) null,
      calypso_banking_prod varchar(128) null,
      other_1 varchar(128) null,
      other_2 varchar(128) null,
      other_3 varchar(128) null ,
      other_4 varchar(128) null,
      other_5 varchar(128) null,
      other_6 varchar(128) null')
end
go

exec add_liqcolumn_if_not_exists
go

drop proc add_liqcolumn_if_not_exists 
go


if exists (select 1 from sysobjects where name ='merge_if_ext_mvnt_attr_exist' and type='P')
begin
exec ('drop procedure merge_if_ext_mvnt_attr_exist')
end
go

create procedure merge_if_ext_mvnt_attr_exist
as
              begin
              declare @cnt int,
              @sql varchar(500)
                             select @cnt=count(*)  FROM sysobjects WHERE sysobjects.name='liq_external_movement_attr'
                             if @cnt=1
                                           select @sql = 'update liq_external_movement set calypso_agent= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'AGENT'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)

                                           select @sql = 'update liq_external_movement set calypso_account= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'ACCOUNT'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)

                                           select @sql = 'update liq_external_movement set calypso_processing_org= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'PROCESSING_ORGANIZATION'||char(39)||' 
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set product_type= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'PRODUCT_TYPE'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set calypso_cpty= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'CALYPSO_COUNTERPARTY'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set calypso_book= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'CALYPSO_BOOK'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set calypso_banking_prod= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'CALYPSO_BANKING_PRODUCT' ||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_1= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_1'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_2= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_2'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_3= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_3'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_4= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_4'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_5= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_5'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
                                           
                                           select @sql = 'update liq_external_movement set other_6= liq_external_movement_attr.attribute_value from liq_external_movement_attr where 
                                                liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = '||char(39)||'OTHER_6'||char(39)||'
                                                          and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx'
                                           exec (@sql)
              end
go


exec merge_if_ext_mvnt_attr_exist
go 

drop proc merge_if_ext_mvnt_attr_exist 
go

/* drop table should not be written as part of the scripts so you need to remove that table from the xmls */
