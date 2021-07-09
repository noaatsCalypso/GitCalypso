
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('enrichment_context') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE enrichment_context (
         context_id numeric  NOT NULL,
         context_name varchar2 (50) NOT NULL,
         primary_key_size numeric  DEFAULT 1 NOT NULL,
         source varchar2 (100) NOT NULL,
         source_table varchar2 (25) NOT NULL,
         enrichment_table varchar2 (50) NOT NULL,
         synchronous numeric  DEFAULT 0 NOT NULL,
         trigger_events varchar2 (255) NULL,
         active numeric  DEFAULT 1 NOT NULL,
         hidden numeric  DEFAULT 0 NOT NULL 
    )';
END IF;
End ;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('audit_process_table') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE audit_process_table (
         process_name varchar2 (50) NOT NULL,
         process_config_id numeric  DEFAULT -1 NOT NULL,
         process_config_name varchar2 (50) NOT NULL,
         audit_type varchar2 (10) NOT NULL,
         audit_date timestamp  NOT NULL,
         version numeric  DEFAULT 0 NULL,
         audit_user varchar2 (32) NULL 
    )';
END IF;
End ;
/

UPDATE enrichment_context SET context_name = 'Searchable Trade Keyword' WHERE context_name = 'trade_keyword_accel'
;
UPDATE audit_process_table SET process_config_name= 'Searchable Trade Keyword' WHERE process_config_name = 'trade_keyword_accel'
;
declare 
    x number;
    y number;
BEGIN
    begin
    select count(*) INTO x FROM user_tables WHERE table_name=UPPER('attribute_config');
    select count(*) INTO y FROM user_tables WHERE table_name=UPPER('trade_keyword_conf');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    DBMS_OUTPUT.PUT_LINE('attribute:' || TO_CHAR( x ) || ' keyword:' || TO_CHAR(y));
    IF x = 1 and y = 1 THEN
        DBMS_OUTPUT.PUT_LINE('droping table attribute_config');
        execute immediate 'DROP TABLE attribute_config';
    END IF;
    
    IF y = 1 THEN
     DBMS_OUTPUT.PUT_LINE('creating attribute_config from trade_keyword_config');
    execute immediate 'CREATE TABLE attribute_config AS
     SELECT keyword_name          AS attribute_name,
      CASE searchable
        WHEN 1
        THEN '||chr(39)||'trade_keyword_accel'||chr(39)||'
        ELSE '||chr(39)||'trade_keyword'||chr(39)||'
      END AS attr_table_name,
      CASE searchable
        WHEN 1
        THEN   (SELECT enrichment_field.column_name
         FROM enrichment_field
        WHERE context_id =
        (SELECT context_id
           FROM enrichment_context
          WHERE context_name = '||chr(39)||'Searchable Trade Keyword'||chr(39)||'
        )
      AND enrichment_field.name = keyword_name
      )
        ELSE '||chr(39)||'keyword_value'||chr(39)||'
      END AS attr_column_name,
      '||chr(39)||'com.calypso.tk.core.Trade'||chr(39)||' AS source_class  ,
      keyword_class AS attribute_class,
      id                              ,
      version                         ,
      searchable                      ,
      domain_name                     ,
      entered_user
       FROM trade_keyword_conf';
 
    DBMS_OUTPUT.PUT_LINE('dropping table trade_keyword_config');
    execute immediate 'drop table trade_keyword_conf';
 
  END IF;
END;
