CREATE OR REPLACE PROCEDURE add_liqcolumn_if_not_exists
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('liq_external_movement') and column_name not in('calypso_agent','calypso_account','calypso_processing_org','product_type', 
		'calypso_cpty',
      'calypso_book',
      'calypso_banking_prod' ,
      'other_1' ,
      'other_2' ,
      'other_3' ,
      'other_4' ,
      'other_5' ,
      'other_6' );
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table liq_external_movement add calypso_agent varchar2(128) null,
      calypso_account varchar2(128) null,
      calypso_processing_org varchar2(128) null,
      product_type varchar2(128) null,
      calypso_cpty varchar2(128) null,
      calypso_book varchar2(128) null,
      calypso_banking_prod varchar2(128) null,
      other_1 varchar2(128) null,
      other_2 varchar2(128) null,
      other_3 varchar2(128) null ,
      other_4 varchar2(128) null,
      other_5 varchar2(128) null,
      other_6 varchar2(128) null';
    END IF;
END;
/

begin
 add_liqcolumn_if_not_exists;
end;
/

CREATE OR REPLACE PROCEDURE merge_if_ext_mvnt_attr_exist
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('liq_external_movement_attr');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 1 THEN
                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''AGENT'' 
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_agent= liq_external_movement_attr.attribute_value';   

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''ACCOUNT''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_account= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on  
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''PROCESSING_ORGANIZATION'' 
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_processing_org= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''PRODUCT_TYPE''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set product_type= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''CALYPSO_COUNTERPARTY''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_cpty= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on  
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''CALYPSO_BOOK''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_book= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''CALYPSO_BANKING_PRODUCT'' 
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set calypso_banking_prod= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_1''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx) 
                                                WHEN MATCHED THEN update set other_1= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_2''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set other_2= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_3''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set other_3= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on 
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_4''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set other_4= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_5''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set other_5= liq_external_movement_attr.attribute_value';

                                EXECUTE immediate  'merge into liq_external_movement using liq_external_movement_attr  on
                                                (liq_external_movement.ext_ref_id=liq_external_movement_attr.ext_ref_id and liq_external_movement_attr.attribute_name = ''OTHER_6''
                                                and liq_external_movement.movement_idx=liq_external_movement_attr.movement_idx)
                                                WHEN MATCHED THEN update set other_6= liq_external_movement_attr.attribute_value';
                                commit;
    END IF;
END merge_if_ext_mvnt_attr_exist;
/

begin
 merge_if_ext_mvnt_attr_exist;
end;
/
/* drop table should not be written as part of the scripts so you need to remove that table from the xmls */
