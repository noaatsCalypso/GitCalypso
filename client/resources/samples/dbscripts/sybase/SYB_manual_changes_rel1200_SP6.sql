if exists (select 1 from sysobjects where name ='add_column_if_not_exists' and type='P')
begin
exec ('drop procedure add_column_if_not_exists')
end
go

create proc add_column_if_not_exists (@table_name varchar(255), @column_name varchar(255) , @datatype varchar(255))
as
begin
declare @cnt int
select @cnt=count(*) from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = @table_name and syscolumns.name = @column_name
if @cnt=0
exec ('alter table ' + @table_name + ' add '+ @column_name +' ' + @datatype)
end
go


add_column_if_not_exists 'swap_leg','sprd_calc_mtd', 'varchar (128)  NULL'
go

add_column_if_not_exists 'swap_leg','compound_stub_rule ', 'varchar (18)  NULL'
go

add_column_if_not_exists 'cu_basis_swap','fx_reset_b ', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_basis_swap','fx_reset_id ', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_basis_swap','fx_reset_leg_id ', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_basis_swap','spread_on_leg_id ', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_basis_swap','base_compound_freq_style ', 'varchar (32)  NULL'
go
add_column_if_not_exists 'cu_basis_swap','base_compound_stub', ' varchar (32)  DEFAULT ''NONE'' NULL'
go
add_column_if_not_exists 'cu_basis_swap','basis_compound_freq_style', ' varchar (32)  NULL'
go
add_column_if_not_exists 'cu_basis_swap','basis_compound_stub', 'varchar (32)  DEFAULT 'NONE' NULL'
go
add_column_if_not_exists 'cu_swap','fx_reset_b', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_swap','fx_reset_id', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_swap','fx_reset_leg_id', 'numeric DEFAULT 0 NULL'
go
add_column_if_not_exists 'cu_swap','fix_compound_freq_style', 'varchar (32)  NULL'
go
add_column_if_not_exists 'cu_swap','fix_compound_stub', 'varchar (32)  DEFAULT ''NONE'' NULL'
go
add_column_if_not_exists 'cu_swap','flt_compound_freq_style ', 'varchar (32)  NULL'
go
add_column_if_not_exists 'cu_swap','flt_compound_stub', 'varchar (32)  DEFAULT ''NONE'' NULL'
go
add_column_if_not_exists 'vol_surface' , 'vol_model', 'varchar2 (32)  DEFAULT ''Black'' NOT NULL'
go
alter table vol_surface_point_type_swap drop constraint ct_primarykey
go
alter table vol_surface_point_type_swap add constraint ct_primarykey primary key (vol_surface_id,vol_surface_date)
go

if not exists (select 1 from sysobjects where type='U' and name='cu_basis_swap_dtls')
begin
exec ('CREATE TABLE cu_basis_swap_dtls ( cu_id numeric  NOT NULL,  
leg_id numeric  NOT NULL,  
stub varchar (32) DEFAULT ''NONE'' NOT NULL,  
reset_timing varchar (18) DEFAULT ''END_PER'' NOT NULL,  
reset_avg_method varchar (18) DEFAULT ''Equal'' NOT NULL,  
avg_sample_freq varchar (12) DEFAULT ''NON'' NOT NULL,  
sample_day numeric  DEFAULT 1 NOT NULL,  interp_b numeric  DEFAULT 0 NOT NULL )')
exec ('ALTER TABLE cu_basis_swap_dtls ADD CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED ( cu_id, leg_id )')
end
go

delete from pricing_param_name where param_name = 'LGMM_CALIB_MIN_CALENDAR_DAYS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_MIN_CALENDAR_DAYS','java.lang.Integer','','If >0, the lag between the value date and the next exercise date will be at least that number of days.',0,'CALIB_MIN_CALENDAR_DAYS','0' )
go
delete from pricing_param_name where param_name = 'LGMM_CALIBRATE_TO_STD_OPTIONS'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATE_TO_STD_OPTIONS','java.lang.Boolean','true,false','if set to true, it calibrates to vanilla swaptions as specified by the point underlying swap on the volatility surface used. Note that Bermudan.',0,'CALIBRATE_TO_STD_OPTIONS','false' )
go
delete from pricing_param_name where param_name = 'LGMM_CALIBRATION_VOL_TYPE'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIBRATION_VOL_TYPE','java.lang.String','BLACK_VOL,BP_VOL','Controls how the model is parameterised and the scheme for calibration',0,'CALIBRATION_VOL_TYPE','BLACK_VOL' )
go
delete from pricing_param_name where param_name = 'DATES_TO_TENOR_THRESHOLD'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('DATES_TO_TENOR_THRESHOLD','java.lang.Double','','The number of days within which a whole year is preserved.',1,'DATES_TO_TENOR_THRESHOLD','7.0' )

go
delete from pricing_param_name where param_name = 'SWAP_REPLICATION_METHOD'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('SWAP_REPLICATION_METHOD','java.lang.String','swap_rate_offset,overlap_negative_weights','SWAP_REPLICATION_METHOD methodology',1,'SWAP_REPLICATION_METHOD','swap_rate_offset' )
go

delete from pricing_param_name where param_name = 'MAX_DAY_SPACING'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('MAX_DAY_SPACING','java.lang.Integer','','Maximum number of days between time splices in the lattice',0,'MAX_DAY_SPACING','30' )
go

delete from pricing_param_name where param_name = 'LGMM_CALIB_SWAPTION'
go

INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SWAPTION','java.lang.String','','Swaption template used to define calibration instruments',0,'CALIB_SWAPTION','' )
go

delete from pricing_param_name where param_name = 'LGMM_CALIB_SPACING'
go
INSERT INTO pricing_param_name ( param_name, param_type, param_domain, param_comment, is_global_b, display_name, default_value ) 
VALUES ('LGMM_CALIB_SPACING','java.lang.Integer','','Minimum spacing between calibration instruments',0,'CALIB_SPACING','30' )
go

add_domain_values 'CapFloor.Pricer','PricerCapFloorInflationBlack','Pricer Cap Floor Inflation Black' 
go
add_domain_values 'Swap.Pricer','PricerSwapLGMM1F','Cancellable swap pricer using sali tree to price the option and LGMM to calibrate' 
go
add_domain_values 'Swaption.Pricer','PricerSwaptionLGMM1F','LGMM1F pricer' 
go
add_domain_values 'Bond.Pricer','PricerLGMM1FSaliTree','LGMM1F Sali Tree Pricer' 
go


