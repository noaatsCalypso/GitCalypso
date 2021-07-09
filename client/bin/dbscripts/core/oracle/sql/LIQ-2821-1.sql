create or replace
PROCEDURE addCtxtPosMovAttributes
AS  
  begin
    DECLARE 
  	x number;
BEGIN

  begin
    select count(1) into x from user_tables where table_name=upper('liq_domain_attributes');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;    
  end;
  
  if x > 0 then
  	begin
    EXECUTE IMMEDIATE 'select count(*) FROM liq_domain_attributes WHERE name like ''LIQUIDITY_MOVEMENT_ATTRIBUTE_%'' ' into x;   
    exception
          when NO_DATA_FOUND THEN
          x:=0;
          when others then
          null;
    end;
    begin
      IF x = 0 THEN
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_1'',''-1'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_2'',''-2'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_3'',''-3'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_4'',''-5'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_5'',''-6'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_6'',''-8'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_7'',''-11'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_8'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_9'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_10'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_11'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_12'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_13'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_14'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_15'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_16'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_17'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_18'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_19'',''0'',''system'',1)';
        EXECUTE IMMEDIATE 'insert into liq_domain_attributes (name,value,user_name,version) values (''LIQUIDITY_MOVEMENT_ATTRIBUTE_20'',''0'',''system'',1)';
        commit;    
      END IF;
      exception 
       WHEN others then
        rollback;
    END;
  end if;
END;
end addCtxtPosMovAttributes;
/

begin
addCtxtPosMovAttributes;
end;
/

create or replace
PROCEDURE CtxtPosMovementUpgrade
AS  
  begin
    DECLARE 
  	x number;
BEGIN
	begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('context_position_movements') and column_name=UPPER('attrib_1');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    IF x = 0 THEN
      execute immediate 'alter table context_position_movements add (attrib_1 varchar2(64), attrib_2 varchar2(64),attrib_3 varchar2(64),attrib_4 varchar2(64),attrib_5 varchar2(64),attrib_6 varchar2(64),attrib_7 varchar2(64) ,attrib_8 varchar2(64) ,attrib_9 varchar2(64) ,attrib_10 varchar2(64),attrib_11 varchar2(64),attrib_12 varchar2(64) ,attrib_13 varchar2(64),attrib_14 varchar2(64) ,attrib_15 varchar2(64),attrib_16 varchar2(64) ,attrib_17 varchar2(64),attrib_18 varchar2(64) ,attrib_19 varchar2(64),attrib_20 varchar2(64)) ';
      dbms_output.put_line(' Added attribute columns '); 
    end if;          
  end;
  begin
    execute immediate 'select count(1) INTO x FROM ctxt_pos_mov_attributes' INTO x ;
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;    
    IF x > 0 THEN   
       execute immediate 'update context_position_movements set (attrib_1,attrib_2,attrib_3,attrib_4,attrib_5,attrib_6,attrib_7,attrib_8,attrib_9,attrib_10,attrib_11,attrib_12,attrib_13,attrib_14,attrib_15,attrib_16,attrib_17,attrib_18,attrib_19,attrib_20) =
       										(select attrib_1,attrib_2,attrib_3,attrib_4,attrib_5,attrib_6,attrib_7,attrib_8,attrib_9,attrib_10,attrib_11,attrib_12,attrib_13,attrib_14,attrib_15,attrib_16,attrib_17,attrib_18,attrib_19,attrib_20 from ctxt_pos_mov_attributes where ctxt_pos_mov_attributes.movement_id = context_position_movements.movement_id) 
						   where exists (select 1 from  ctxt_pos_mov_attributes where ctxt_pos_mov_attributes.movement_id=context_position_movements.movement_id)';
       commit;
       execute immediate 'truncate table ctxt_pos_mov_attributes ';
    end if;
  end;  
   exception 
    WHEN others then
      rollback;
      x:=0;     
END;
end CtxtPosMovementUpgrade;
/


begin
CtxtPosMovementUpgrade;
end;
/

create or replace PROCEDURE CtxtPosBlockUpgrade
AS  
  begin
    DECLARE 
  	x number;
    minProdId number;
    maxProdId number;
    startIndex number;
    endIndex number;
BEGIN

  begin
    select count(1) into x from user_tables where table_name=upper('product_context_position');
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;    
  end;
  IF x = 1 THEN
    execute immediate 'truncate table product_context_position';
    execute immediate 'truncate table ctxt_pos_mov_product_map';
  END if; 
  BEGIN
      begin
	      	select count(1) into x from product_desc where product_type='ContextPosition';
	      	IF x > 0 THEN
            	select min(product_id),max(product_id) INTO minProdId,maxProdId FROM product_desc where product_type='ContextPosition';
            	startIndex := minProdId;
            	loop
	              endIndex := startIndex + 1000;              
	              delete from settle_position_change where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex);
	              delete from settle_position where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex);
	              delete from settle_position_snapshot where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex);

	              delete from position where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex);
		      delete from position_snapshot where product_id in (select product_id from product_desc where product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex);
	              delete from product_desc where  product_type='ContextPosition' and product_id >= startIndex and product_id <= endIndex ;
	              commit;
	              startIndex := endIndex +1;
    	          EXIT WHEN endIndex > maxProdId;
        	    end loop; 	      	
	      	end if;
 
         exception 
            WHEN others then
              rollback;
              x:=0;
      end;
  END ;
END;
end CtxtPosBlockUpgrade;
/

begin
CtxtPosBlockUpgrade;
end;
/
