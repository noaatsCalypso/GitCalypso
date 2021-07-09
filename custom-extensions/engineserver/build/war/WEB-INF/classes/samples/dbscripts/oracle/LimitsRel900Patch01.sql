
alter table ers_exposure add book_name varchar(64) default ' ' not null
;

alter table ers_limit add service_class	varchar(32) default ' ' not null
;
alter table ers_limit_pending add service_class	varchar(32) default ' ' not null
;
alter table ers_limit_authorise add service_class	varchar(32) default ' ' not null
;
alter table ers_limit_authorise_reject add service_class	varchar(32) default ' ' not null
;

update ers_limit set service_class = service
;
update ers_limit set service = 'Market Risk' where service='MarketRisk'
;
update ers_limit set service = 'Credit Risk' where service='CreditRisk'
;

update ers_limit_pending set service_class = service
;
update ers_limit_pending set service = 'Market Risk' where service='MarketRisk'
;
update ers_limit_pending set service = 'Credit Risk' where service='CreditRisk'
;

update ers_limit_authorise set service_class = service
;
update ers_limit_authorise set service = 'Market Risk' where service='MarketRisk'
;
update ers_limit_authorise set service = 'Credit Risk' where service='CreditRisk'
;


update ers_limit_authorise_reject set service_class = service
;
update ers_limit_authorise_reject set service = 'Market Risk' where service='MarketRisk'
;
update ers_limit_authorise_reject set service = 'Credit Risk' where service='CreditRisk'
;

update ers_limit_report_detail set report_value = 'Market Risk' where report_key = 'service' and report_value = 'MarketRisk'
;
update ers_limit_report_detail set report_value = 'Credit Risk' where report_key = 'service' and report_value = 'CreditRisk'
;

update ers_limit set service = 'Issuer Risk' where hierarchy='Issuer'
;

DROP TABLE ers_addon
;

CREATE TABLE ers_addon
   (
	addon_setname	varchar(255)	NOT NULL,
	addon_key	varchar(255)	NOT NULL,
	addon_amount	float		NOT NULL,
	seq_id          int      	NOT NULL,
  	sheet_name      varchar(255)   NOT NULL,
	range_name      varchar(255)      	NOT NULL,
	order_id	int		NOT NULL
   ) TABLESPACE CALYPSOACTIVE

;


CREATE  INDEX IDX_ers_addon ON ers_addon(addon_setname, addon_key, seq_id) TABLESPACE CALYPSOIDX
;

CREATE TABLE ers_addon_buckets
   (
	bucket	char(3)	NOT NULL
   ) TABLESPACE CALYPSOACTIVE

;

CREATE TABLE ers_limit_reserve
   (
	trade_id	int    		NOT NULL,
	reserve_status	varchar(64)	NOT NULL,
	reserve_date	TIMESTAMP	NOT NULL,
        julian_offset   int             NOT NULL,
	reserve_timeout	int    		NOT NULL,
	modified_date	TIMESTAMP    	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;


CREATE TABLE ers_exposure_measure    
(
	julian_offset	int		NOT NULL,
	trade_id	int    		NOT NULL,
	measure 	varchar(64)	NOT NULL,
	ccy		char(3)		NOT NULL,
	base_ccy	char(3)		NOT NULL,
	amount		float		NOT NULL,
	amount_base	float		NOT NULL
) TABLESPACE CALYPSOACTIVE
;

CREATE INDEX IDX_ers_exposure_measure ON ers_exposure_measure(julian_offset, trade_id, measure) TABLESPACE CALYPSOIDX
;

CREATE TABLE ers_measure_config    
(
	service 	varchar(64)	NOT NULL,
	measure 	varchar(64)	NOT NULL,
	risk_type	varchar(64)	NOT NULL,
	display_name	varchar(64)	NOT NULL,
	is_default	int		NOT NULL
) TABLESPACE CALYPSOACTIVE

;

CREATE  INDEX IDX_ers_measure_config ON ers_measure_config(service, measure) TABLESPACE CALYPSOIDX
;

DELETE FROM ers_measure_config
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'MTM AddOn', 'Credit Risk', 'Credit Exposure', 1)
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'Notional', 'Credit Risk', 'Notional', 1)
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'Issuer', 'Issuer Risk', 'Notional', 1)
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'Settlement', 'Credit Risk', 'Settlement', 1)
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'Loan Equivalent', 'Credit Risk', 'Loan Equivalent', 1)
;
INSERT INTO ers_measure_config VALUES('CreditRisk', 'MTM', 'Credit Risk', 'MTM', 1)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'IRDelta', 'ERS Risk', 'IRDelta', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'CSDelta', 'ERS Risk', 'CSDelta', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'IRGamma', 'ERS Risk', 'IRGamma', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'IRVega', 'ERS Risk', 'IRVega', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'HistVaR', 'ERS Risk', 'HistVaR', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'ProfitLoss', 'ERS Risk', 'Profit Loss', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'Scenario', 'ERS Risk', 'Scenario', 0)
;
INSERT INTO ers_measure_config VALUES('MarketRisk', 'Scenario.Credit_View', 'ERS Risk', 'Scenario.Credit_View', 0)
;

DELETE FROM ers_addon
;

INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.EUR.EUR', 0.0, 0, 'ProductGroup.FX', '1Y', 0)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.USD.EUR', 0.03, 0, 'ProductGroup.FX', '1Y', 1)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.Others.EUR', 0.04, 0, 'ProductGroup.FX', '1Y', 2)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.EUR.USD', 0.03, 0, 'ProductGroup.FX', '1Y', 3)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.USD.USD', 0.0, 0, 'ProductGroup.FX', '1Y', 4)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.Others.USD', 0.04, 0, 'ProductGroup.FX', '1Y', 5)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.1Y.USD', 0.01, 0, 'Product.Swap', ' ', 0)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.3Y.USD', 0.025, 0, 'Product.Swap', ' ', 1)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.5Y.USD', 0.035, 0, 'Product.Swap', ' ', 2)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.10Y.USD', 0.045, 0, 'Product.Swap', ' ', 3)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.*.USD', 0.055, 0, 'Product.Swap', ' ', 4)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.1Y.EUR', 0.01, 0, 'Product.Swap', ' ', 5)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.3Y.EUR', 0.02, 0, 'Product.Swap', ' ', 6)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.5Y.EUR', 0.03, 0, 'Product.Swap', ' ', 7)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.10Y.EUR', 0.04, 0, 'Product.Swap', ' ', 8)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.*.EUR', 0.05, 0, 'Product.Swap', ' ', 9)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.1Y.Others', 0.02, 0, 'Product.Swap', ' ', 10)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.3Y.Others', 0.03, 0, 'Product.Swap', ' ', 11)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.5Y.Others', 0.04, 0, 'Product.Swap', ' ', 12)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.EUR.Others', 0.04, 0, 'ProductGroup.FX', '1Y', 6)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.USD.Others', 0.04, 0, 'ProductGroup.FX', '1Y', 7)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.1Y.Others.Others', 0.06, 0, 'ProductGroup.FX', '1Y', 8)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.EUR.EUR', 0.0, 0, 'ProductGroup.FX', '6M', 0)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.USD.EUR', 0.02, 0, 'ProductGroup.FX', '6M', 1)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.Others.EUR', 0.03, 0, 'ProductGroup.FX', '6M', 2)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.EUR.USD', 0.02, 0, 'ProductGroup.FX', '6M', 3)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.USD.USD', 0.0, 0, 'ProductGroup.FX', '6M', 4)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.Others.USD', 0.03, 0, 'ProductGroup.FX', '6M', 5)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.10Y.Others', 0.05, 0, 'Product.Swap', ' ', 13)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Product.Swap.*.Others', 0.06, 0, 'Product.Swap', ' ', 14)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'Default.default.default', 0.1, 0, 'Main', ' ', 0)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.EUR.Others', 0.03, 0, 'ProductGroup.FX', '6M', 6)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.USD.Others', 0.03, 0, 'ProductGroup.FX', '6M', 7)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.6M.Others.Others', 0.05, 0, 'ProductGroup.FX', '6M', 8)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.EUR.EUR', 0.0, 0, 'ProductGroup.FX', '*', 0)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.USD.EUR', 0.035, 0, 'ProductGroup.FX', '*', 1)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.Others.EUR', 0.045, 0, 'ProductGroup.FX', '*', 2)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.EUR.USD', 0.035, 0, 'ProductGroup.FX', '*', 3)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.USD.USD', 0.0, 0, 'ProductGroup.FX', '*', 4)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.Others.USD', 0.045, 0, 'ProductGroup.FX', '*', 5)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.EUR.Others', 0.045, 0, 'ProductGroup.FX', '*', 6)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.USD.Others', 0.045, 0, 'ProductGroup.FX', '*', 7)
;
INSERT INTO ers_addon(addon_setname, addon_key, addon_amount, seq_id, sheet_name, range_name, order_id)
  VALUES('default', 'ProductGroup.FX.*.Others.Others', 0.065, 0, 'ProductGroup.FX', '*', 8)
;

DELETE FROM ers_addon_buckets
;
INSERT INTO ers_addon_buckets VALUES('1M')
;
INSERT INTO ers_addon_buckets VALUES('2M')
;
INSERT INTO ers_addon_buckets VALUES('3M')
;
INSERT INTO ers_addon_buckets VALUES('4M')
;
INSERT INTO ers_addon_buckets VALUES('5M')
;
INSERT INTO ers_addon_buckets VALUES('6M')
;
INSERT INTO ers_addon_buckets VALUES('7M')
;
INSERT INTO ers_addon_buckets VALUES('8M')
;
INSERT INTO ers_addon_buckets VALUES('9M')
;
INSERT INTO ers_addon_buckets VALUES('10M')
;
INSERT INTO ers_addon_buckets VALUES('11M')
;
INSERT INTO ers_addon_buckets VALUES('12M')
;
INSERT INTO ers_addon_buckets VALUES('13M')
;
INSERT INTO ers_addon_buckets VALUES('14M')
;
INSERT INTO ers_addon_buckets VALUES('15M')
;
INSERT INTO ers_addon_buckets VALUES('16M')
;
INSERT INTO ers_addon_buckets VALUES('17M')
;
INSERT INTO ers_addon_buckets VALUES('18M')
;
INSERT INTO ers_addon_buckets VALUES('1Y')
;
INSERT INTO ers_addon_buckets VALUES('2Y')
;
INSERT INTO ers_addon_buckets VALUES('3Y')
;
INSERT INTO ers_addon_buckets VALUES('4Y')
;
INSERT INTO ers_addon_buckets VALUES('5Y')
;
INSERT INTO ers_addon_buckets VALUES('6Y')
;
INSERT INTO ers_addon_buckets VALUES('7Y')
;
INSERT INTO ers_addon_buckets VALUES('8Y')
;
INSERT INTO ers_addon_buckets VALUES('9Y')
;
INSERT INTO ers_addon_buckets VALUES('10Y')
;
INSERT INTO ers_addon_buckets VALUES('11Y')
;
INSERT INTO ers_addon_buckets VALUES('12Y')
;
INSERT INTO ers_addon_buckets VALUES('13Y')
;
INSERT INTO ers_addon_buckets VALUES('14Y')
;
INSERT INTO ers_addon_buckets VALUES('15Y')
;
INSERT INTO ers_addon_buckets VALUES('16Y')
;
INSERT INTO ers_addon_buckets VALUES('17Y')
;
INSERT INTO ers_addon_buckets VALUES('18Y')
;
INSERT INTO ers_addon_buckets VALUES('19Y')
;
INSERT INTO ers_addon_buckets VALUES('20Y')
;
INSERT INTO ers_addon_buckets VALUES('25Y')
;
INSERT INTO ers_addon_buckets VALUES('30Y')
;
INSERT INTO ers_addon_buckets VALUES('*')
;



