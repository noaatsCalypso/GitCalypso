
CREATE OR REPLACE PROCEDURE recreate_ers_margin_sen
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('ers_margin_sensitivity') and column_name=upper('valuation_date');
    
	exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'create table ers_margin_sensitivity_back as select * from ers_margin_sensitivity';
		EXECUTE IMMEDIATE 'drop table ers_margin_sensitivity';
		EXECUTE IMMEDIATE 'create table ers_margin_sensitivity( run_id number not null ,
							execution_time timestamp null ,
							valuation_date timestamp not null ,
							portfolio_id varchar2(60) not null ,
							party_id varchar2(60) not null ,
							cp_id varchar2(60) not null ,
							margin_agreement_name varchar2(60) not null ,
							im_model varchar2(20) not null ,
							risk_type varchar2(20) not null ,
							qualifier varchar2(20) not null ,
							bucket number null ,
							label1 varchar2(20)  null ,
							label2 varchar2(20)  null ,
							amount float null ,
							amount_ccy varchar2(3) not  null ,
							amount_base float null ,
							source varchar2(60) null,
							pricing_env varchar2(120) not null,
							product_class varchar2(20) not null)';
END IF;
END;
/

begin
recreate_ers_margin_sen;
end;
/

CREATE OR REPLACE PROCEDURE recreate_ers_margin_ccy_column
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER('ers_margin_ccy_to_level') and column_name=upper('ccy') and data_length=3;
    
	exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table ers_margin_ccy_to_level rename column ccy to ccy_old';
        EXECUTE IMMEDIATE 'alter table ers_margin_ccy_to_level add ccy varchar2(3)';
        EXECUTE IMMEDIATE 'update ers_margin_ccy_to_level SET ccy = ccy_old';
        EXECUTE IMMEDIATE 'alter table ers_margin_ccy_to_level drop column ccy_old';
END IF;
END;
/

begin
recreate_ers_margin_ccy_column;
end;
/