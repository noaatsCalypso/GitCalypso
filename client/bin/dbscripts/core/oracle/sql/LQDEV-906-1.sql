
update main_entry_prop set property_value='contextposition.setup.ContextPositionSetupManager' where property_value = 'configuration.split.SplitConfigurationWindow$contextposition.mo.ContextPositionBucketConfigObjectLoader'
;
update ctxt_pos_bucket_conf set ctxt_pos_type = 'FIXED_CASH' where ctxt_pos_type ='CASH'
;

CREATE OR REPLACE PROCEDURE update_if_prod_cont_pos_exists
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER('product_context_position');
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 1 THEN
    	EXECUTE IMMEDIATE 'update product_context_position set ctxt_pos_type = ''FIXED_CASH'' where ctxt_pos_type = ''CASH''';
       	COMMIT;
    END IF;
END update_if_prod_cont_pos_exists;
/

begin
update_if_prod_cont_pos_exists;
end;
/ 

update an_param_items set attribute_name = 'FIXED_CASH_CONTEXTS_TO_ADD_COUNT' where attribute_name = 'CASH_CONTEXTS_TO_ADD_COUNT' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;
update an_param_items set attribute_name = concat('FIXED_', attribute_name) where attribute_name like 'CASH_CONTEXTS_TO_ADD_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;
update an_param_items set attribute_name = 'FIXED_CASH_CONTEXTS_TO_SUBTRACT_COUNT' where attribute_name = 'CASH_CONTEXTS_TO_SUBTRACT_COUNT' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;
update an_param_items set attribute_name = concat('FIXED_', attribute_name) where attribute_name like 'CASH_CONTEXTS_TO_SUBTRACT_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;

CREATE OR REPLACE PROCEDURE updateLadderParams
AS
BEGIN
DECLARE 
  existsVar NUMBER(10);
	loadPositionVar VARCHAR2(10);
	ladderRunMode VARCHAR2(30);  
  CURSOR C1 IS 
	SELECT param.param_name param_name ,param.class_name class_name ,coalesce(fil.ctxt_pos_space,'INTRADAY_LIQUIDITY') ctxt_pos_space from an_param_items param left outer join ctxt_pos_filter fil on (to_number(param.attribute_value) = fil.cxt_pos_filter_id)
	where class_name = 'com.calypso.tk.risk.ForwardLadderParam' and attribute_name='ContextPositionFilterId' and to_number(attribute_value) > 0;
BEGIN
FOR C1_REC in C1 LOOP

   BEGIN
	  select count(1) into existsVar from an_param_items where attribute_name='FORWARD_LADDER_RUN_MODE' 
      		and class_name = 'com.calypso.tk.risk.ForwardLadderParam' and param_name = c1_rec.param_name;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         existsVar:=0;
      WHEN others THEN
         null;
    END;

  if existsVar = 0 then
    if c1_rec.ctxt_pos_space = 'INTRADAY_LIQUIDITY' then
      insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values (C1_REC.param_name,C1_REC.class_name,'FORWARD_LADDER_RUN_MODE','INTRADAY_MODE');
    else
	   BEGIN
		  select attribute_value into loadPositionVar from an_param_items a where a.param_name=c1_rec.param_name and a.class_name=c1_rec.class_name and attribute_name='LoadFuturePositions';
	   EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	         loadPositionVar:='false';
	      WHEN others THEN
	         null;
	    END;    
      if loadPositionVar = 'true' then
        ladderRunMode := 'SHORTTERM_POSITIONS_MODE';
      else
        ladderRunMode := 'SHORTTERM_TRADES_MODE';
      end if;			
      insert into an_param_items(param_name,class_name,attribute_name,attribute_value) values (C1_REC.param_name,C1_REC.class_name,'FORWARD_LADDER_RUN_MODE',ladderRunMode);
    end if;    
  end if ;
END LOOP;
	update ctxt_pos_filter set ctxt_pos_space = 'SHORT_TERM_LIQUIDITY' where ctxt_pos_space ='INTRADAY_LIQUIDITY';
	update ctxt_pos_filter set cash_ctxt_pos_config_id = -2 where cash_ctxt_pos_config_id = -4;
	update ctxt_pos_filter set sec_ctxt_pos_config_id = -1 where sec_ctxt_pos_config_id = -5;
	COMMIT;	
END;
END updateLadderParams;
/
begin
updateLadderParams;
end;
/

drop procedure updateLadderParams
/

/** bucket configurations **/
update ctxt_pos_bucket_conf set ctxt_pos_space = 'SHORT_TERM_LIQUIDITY' where ctxt_pos_space ='INTRADAY_LIQUIDITY'
;
update an_param_items set attribute_value = replace(attribute_value,'INTRADAY_LIQUIDITY.','SHORT_TERM_LIQUIDITY.') where attribute_name like '%_CONTEXTS_TO_SUBTRACT_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;
update an_param_items set attribute_value = replace(attribute_value,'INTRADAY_LIQUIDITY.','SHORT_TERM_LIQUIDITY.') where attribute_name like '%_CONTEXTS_TO_ADD_%' and class_name = 'com.calypso.tk.risk.ForwardLadderParam'
;

CREATE OR REPLACE PROCEDURE delete_old_reinit_jobs
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER('ctxt_pos_mov_attributes');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=1;
        WHEN others THEN
        x:=1;
    END;
    IF x = 0 THEN
    	delete from context_position_movements;
        delete from liq_ctxt_pos_reinit_job;
       	delete from liq_ctxt_pos_reinit_task;
       	COMMIT;
    END IF;
END delete_old_reinit_jobs;
/

begin
	delete_old_reinit_jobs;
end;
/

drop procedure delete_old_reinit_jobs
/