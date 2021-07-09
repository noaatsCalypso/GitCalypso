CREATE OR REPLACE PROCEDURE add_column_if_not_exists
    (tab_name IN user_tab_columns.table_name%TYPE,
     col_name IN user_tab_columns.column_name%TYPE,
     data_type IN varchar2)
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' add '||col_name||' '||data_type;
    END IF;
END;
;
CREATE OR REPLACE PROCEDURE add_domain_values (dname IN varchar2, dvalue in varchar2, ddescription in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM domain_values WHERE name= dname and value= dvalue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
	if x = 1 then
		execute immediate 'delete from domain_values where name='||chr(39)||dname||chr(39)||' and value ='||chr(39)||dvalue||chr(39);
		execute immediate 'insert into domain_values ( name, value, description ) 
		VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
	elsif x = 0 THEN
		execute immediate 'insert into domain_values ( name, value, description ) 
		VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
	END IF;
END add_domain_values;
;
begin
  add_column_if_not_exists('SWAP_LEG', 'sprd_calc_mtd', 'varchar2(128)  NULL');
  add_column_if_not_exists('SWAP_LEG', 'compound_stub_rule', 'varchar2(18)  NULL');
  add_column_if_not_exists('CU_BASIS_SWAP', 'fx_reset_b', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_BASIS_SWAP', 'fx_reset_id', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_BASIS_SWAP', 'fx_reset_leg_id', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_BASIS_SWAP', 'fx_reset_leg_id', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_BASIS_SWAP','spread_on_leg_id', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_BASIS_SWAP' , 'base_compound_freq_style', 'varchar2(32)  NULL');
  add_column_if_not_exists('CU_BASIS_SWAP' , 'base_compound_stub' ,'varchar2(32) DEFAULT ''NONE'' NULL');
  add_column_if_not_exists('CU_BASIS_SWAP' , 'basis_compound_freq_style','varchar2(32)  NULL');
  add_column_if_not_exists('CU_BASIS_SWAP' , 'basis_compound_stub','varchar2(32)  DEFAULT ''NONE'' NULL');
  add_column_if_not_exists('CU_SWAP' , 'fx_reset_b','numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_SWAP' , 'fx_reset_id' ,'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_SWAP' , 'fx_reset_leg_id', 'numeric DEFAULT 0 NULL');
  add_column_if_not_exists('CU_SWAP' , 'fix_compound_freq_style', 'varchar2(32)  NULL');
  add_column_if_not_exists('CU_SWAP' , 'fix_compound_stub', 'varchar2(32) DEFAULT ''NONE'' NULL');
  add_column_if_not_exists('CU_SWAP' , 'flt_compound_freq_style','varchar2(32)  NULL');
  add_column_if_not_exists('CU_SWAP' , 'flt_compound_stub', 'varchar2(32)  DEFAULT ''NONE'' NULL');
  add_column_if_not_exists('VOL_SURFACE' , 'vol_model', 'varchar2 (32)  DEFAULT ''Black'' NOT NULL');
end;
;
alter table VOL_SURFACE_POINT_TYPE_SWAP drop primary key
;
alter table VOL_SURFACE_POINT_TYPE_SWAP add constraint pk_vol_surface_pt_ty_sw1 primary key (vol_surface_id,vol_surface_date)
;


CREATE OR REPLACE PROCEDURE add_table
    (name IN user_tables.table_NAME%TYPE)
AS
    x number;
BEGIN
    BEGIN
    SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME=UPPER(name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE cu_basis_swap_dtls ( 
cu_id numeric  NOT NULL,  
leg_id numeric  NOT NULL,  
stub varchar2 (32) DEFAULT ''NONE'' NOT NULL,  
reset_timing varchar2 (18) DEFAULT ''END_PER'' NOT NULL,  
reset_avg_method varchar2 (18) DEFAULT ''Equal'' NOT NULL,  
avg_sample_freq varchar2 (12) DEFAULT ''NON'' NOT NULL,  
sample_day numeric  DEFAULT 1 NOT NULL,  interp_b numeric  DEFAULT 0 NOT NULL )';

 EXECUTE IMMEDIATE 'ALTER TABLE cu_basis_swap_dtls ADD CONSTRAINT pk_cu_basis_swap_dtl1 PRIMARY KEY ( cu_id, leg_id )';
     
    END IF;
END add_table;
;

begin
add_table('cu_basis_swap_dtls');
end;
;

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_MIN_CALENDAR_DAYS'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIBRATE_TO_STD_OPTIONS'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIBRATION_VOL_TYPE'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' )
;
delete from Pricing_Param_Name where PARAM_NAME = 'DATES_TO_TENOR_THRESHOLD'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' )

;
delete from Pricing_Param_Name where PARAM_NAME = 'SWAP_REPLICATION_METHOD'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'MAX_DAY_SPACING'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('MAX_DAY_SPACING','java.lang.Integer','','Maximum number of days between time splices in the lattice',0,'MAX_DAY_SPACING','30' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_SWAPTION'
;

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SWAPTION','java.lang.String','','Swaption template used to define calibration instruments',0,'CALIB_SWAPTION','' )
;

delete from Pricing_Param_Name where PARAM_NAME = 'LGMM_CALIB_SPACING'
;
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SPACING','java.lang.Integer','','Minimum spacing between calibration instruments',0,'CALIB_SPACING','30' )
;
begin
add_domain_values ('CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black' );
add_domain_values ('Swap.Pricer','PricerSwapLGMM1F','Cancellable swap pricer using sali tree to price the option and LGMM to calibrate' );
add_domain_values ('Swaption.Pricer','PricerSwaptionLGMM1F','LGMM1F pricer' );
add_domain_values ('Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer' );
end;
;
