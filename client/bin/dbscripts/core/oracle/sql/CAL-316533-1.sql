/* creating temp1 table to filter for 'FX'  trades */
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('TEMP1') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
EXECUTE IMMEDIATE 'drop table temp1';
END IF;
End ;
/

create table temp1 as select * from trade_role_alloc 
where trade_id in (select t.trade_id from trade t,product_desc p 
where t.product_id=p.product_id and p.product_family='FX')
;
/* create table temp2 to filter further on keyword_name */ 
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('TEMP2') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 1 THEN
EXECUTE IMMEDIATE 'drop table temp2';
END IF;
End ;
/

create table temp2 as select ta.rel_trade_id,ta.trade_id,ta.amount ,ta.sec_amount from temp1 ta, trade_keyword tk 
where tk.keyword_name = 'NegotiatedCurrency' and tk.keyword_value = ta.settle_ccy and ta.trade_id=tk.trade_id
;

/* switch between amount & sec_amount */

UPDATE trade_role_alloc ta
set ta.amount=(select temp2.sec_amount from temp2 where ta.trade_id=temp2.trade_id and ta.rel_trade_id=temp2.rel_trade_id)
where exists ( select trade_id,rel_trade_id from temp2 where ta.trade_id=temp2.trade_id and ta.rel_trade_id=temp2.rel_trade_id)
;

UPDATE trade_role_alloc ta
set ta.sec_amount=(select temp2.amount from temp2 where ta.trade_id=temp2.trade_id and ta.rel_trade_id=temp2.rel_trade_id)
where exists (select trade_id,rel_trade_id from temp2 where ta.trade_id=temp2.trade_id and ta.rel_trade_id=temp2.rel_trade_id)
;
drop table temp1
;
drop table temp2
;
