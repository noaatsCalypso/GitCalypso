declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('order_template') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'CREATE TABLE order_template (
         template_name varchar2 (256) NOT NULL,
         template_data blob  NOT NULL )';
END IF;
End ;
/
alter table order_template rename to order_template_back151
;

update entity_state set entity_type = 'AMOrder'
where entity_type = 'DecSuppOrder'
;

update entity_state set entity_type = 'AMBlockOrder'
where entity_type = 'BlockOrderImpl'
;