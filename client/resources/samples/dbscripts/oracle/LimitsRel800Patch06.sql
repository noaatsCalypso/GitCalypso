CREATE TABLE ers_limit_report
   (
	report_id	int    		NOT NULL,
	report_type	varchar(32)	NOT NULL,
	report_name	varchar(32)	NOT NULL,
	user_name	varchar(32)	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;

CREATE TABLE ers_limit_report_detail
   (
	report_id	int    		NOT NULL,
	report_key	varchar(128)	NOT NULL,
	report_value	varchar(128)	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;

CREATE TABLE ers_limit_breach
   (
	trade_id	int		NOT NULL,
	le_name		varchar(64)	NOT NULL,
	ccy		char(3)		NOT NULL,
	product		varchar(64)	NOT NULL,
	trader_name	varchar(64)	NOT NULL,
	julian_offset	int		NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;

CREATE  INDEX IDX_ers_limit_breach ON ers_limit_breach(julian_offset,le_name) TABLESPACE CALYPSOIDX
;

