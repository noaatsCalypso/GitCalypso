declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('ers_info') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table ers_info (
		major_version number not null,
		minor_version number not null,
		sub_version number not null,
		version_date timestamp,
		ref_time_zone varchar2(128) ,
		patch_version  varchar2(32)  ,
		patch_date timestamp)';
END IF;
End ;
/
delete from ers_info
;
UPDATE ers_measure_config SET display_name = 'PV01' WHERE service = 'CreditRisk' AND measure = 'PV01' AND display_name = 'Delta'
;
delete from ERS_ANALYSIS_CONFIGURATION where analysis='HistSim' and config_name='groupings'
;
UPDATE ers_measure_config SET display_name = 'PercNotional' WHERE service = 'CreditRisk' AND measure = 'Loan Equivalent' AND display_name = 'Loan Equivalent'
;
