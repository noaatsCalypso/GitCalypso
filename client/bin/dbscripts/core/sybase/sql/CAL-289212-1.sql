if not exists (select 1 from sysobjects where name='enrichment_context' and type='U')
begin
exec ('CREATE TABLE enrichment_context (
         context_id numeric  NOT NULL,
         context_name varchar (50) NOT NULL,
         primary_key_size numeric  DEFAULT 1 NOT NULL,
         source varchar (100) NOT NULL,
         source_table varchar (25) NOT NULL,
         enrichment_table varchar (50) NOT NULL,
         synchronous numeric  DEFAULT 0 NOT NULL,
         trigger_events varchar (255) NULL,
         active numeric  DEFAULT 1 NOT NULL,
         hidden numeric  DEFAULT 0 NOT NULL 
    )')
end
go
if not exists (select 1 from sysobjects where name='audit_process_table' and type='U')
begin
exec ('CREATE TABLE audit_process_table (
         process_name varchar (50) NOT NULL,
         process_config_id numeric  DEFAULT -1 NOT NULL,
         process_config_name varchar (50) NOT NULL,
         audit_type varchar (10) NOT NULL,
         audit_date datetime  NOT NULL,
         version numeric  DEFAULT 0 NULL,
         audit_user varchar (32) NULL 
    )')
end
go

UPDATE enrichment_context SET context_name = 'Searchable Trade Keyword' WHERE context_name = 'trade_keyword_accel'
go
UPDATE audit_process_table SET process_config_name= 'Searchable Trade Keyword' WHERE process_config_name = 'trade_keyword_accel'
go
begin
declare @trd int, @att int
select  @trd=count(*) from sysobjects where name='trade_keyword_conf' and type='U'
select @att= count(*) from sysobjects where name='attribute_config' and type='U'
begin
declare @vsql varchar(1000)
if (@trd=1 and @att=1)
begin
exec ('DROP TABLE attribute_config')
end
if (@trd=1 and @att=0)
begin

select @vsql = ' SELECT 
  CASE trade_keyword_conf.searchable
    WHEN 1
    THEN  '||char(39)||'trade_keyword_accel'||char(39)||' 
    ELSE  '||char(39)||'trade_keyword'||char(39)||'
  END AS attr_table_name,
  CASE trade_keyword_conf.searchable
    WHEN 1
    THEN   (SELECT enrichment_field.column_name
     FROM enrichment_field ,trade_keyword_conf
    WHERE enrichment_field.context_id =
    (SELECT enrichment_context.context_id
       FROM enrichment_context
      WHERE enrichment_context.context_name =  '||char(39)||'Searchable Trade Keyword'||char(39)||'
    )
  AND enrichment_field.name = trade_keyword_conf.keyword_name
  )
    ELSE '||char(39)||'keyword_value'||char(39)||' 
  END AS attr_column_name ,
  trade_keyword_conf.keyword_name AS attribute_name ,
  '||char(39)||'com.calypso.tk.core.Trade'||char(39)||'  AS source_class  ,
  trade_keyword_conf.keyword_class AS attribute_class,
  trade_keyword_conf.id as id                              ,
  trade_keyword_conf.version  as version                        ,
  trade_keyword_conf.searchable  as searchable                     ,
  trade_keyword_conf.domain_name as domain_name                     ,
  trade_keyword_conf.entered_user as entered_user
   FROM trade_keyword_conf'
 exec (@vsql)
exec ('DROP TABLE trade_keyword_conf')
end
end
end
go