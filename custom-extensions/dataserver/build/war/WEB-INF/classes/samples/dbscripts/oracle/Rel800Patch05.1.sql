
/* BUG# 38140 : Unordered shifts in HypPL causing incorrect Aggregate risk values for Vols */

DROP TABLE ers_risk_attribution_bk
;

/* Create a backup table */
CREATE TABLE ers_risk_attribution_bk
   (
	attribution_name        varchar(32)	not null,
	node_id                 smallint        not null,
	parent_id               smallint	not null,
    	seq_id                  smallint        not null,
    	node_type               smallint        not null,
    	node_class              varchar(255)    null,
	node_value              varchar(255)    not null	       
    ) TABLESPACE CALYPSOSTATIC    
;

/* Populate the backup table */
insert into ers_risk_attribution_bk select * from ers_risk_attribution
;

/* Clear the current data */
delete from ers_risk_attribution
;


insert into ers_risk_attribution values ('Aggr', 1, 0, 1, 0, '', 'Aggr')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 2, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 3, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 4, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 5, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 6, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 7, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 8, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
;
insert into ers_risk_attribution values ('Aggr', 1, 0, 9, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
;
insert into ers_risk_attribution values ('Standard', 1, 0, 1, 0, '', 'FX')
;
insert into ers_risk_attribution values ('Standard', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
;
insert into ers_risk_attribution values ('Standard', 2, 0, 2, 0, '', 'Rates')
;
insert into ers_risk_attribution values ('Standard', 2, 0, 2, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
;
insert into ers_risk_attribution values ('Standard', 3, 0, 3, 0, '', 'Credit')
;
insert into ers_risk_attribution values ('Standard', 3, 0, 3, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
;
insert into ers_risk_attribution values ('Standard', 4, 0, 4, 0, '', 'Equity')
;
insert into ers_risk_attribution values ('Standard', 4, 0, 4, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
;
insert into ers_risk_attribution values ('Standard', 5, 0, 5, 0, '', 'Vols')
;
insert into ers_risk_attribution values ('Standard', 5, 0, 5, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
;
insert into ers_risk_attribution values ('Standard', 5, 0, 6, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
;
insert into ers_risk_attribution values ('Standard', 5, 0, 7, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
;
insert into ers_risk_attribution values ('Standard', 5, 0, 8, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
;
insert into ers_risk_attribution values ('Standard', 6, 0, 9, 0, '', 'Correlation')
;
insert into ers_risk_attribution values ('Standard', 6, 0, 9, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
;
insert into ers_risk_attribution values ('AssetClass', 1, 0, 1, 0, '', 'FX')
;
insert into ers_risk_attribution values ('AssetClass', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
;
insert into ers_risk_attribution values ('AssetClass', 1, 0, 2, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
;
insert into ers_risk_attribution values ('AssetClass', 2, 0, 3, 0, '', 'Rates')
;
insert into ers_risk_attribution values ('AssetClass', 2, 0, 3, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
;
insert into ers_risk_attribution values ('AssetClass', 2, 0, 4, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
;
insert into ers_risk_attribution values ('AssetClass', 2, 0, 5, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
;
insert into ers_risk_attribution values ('AssetClass', 2, 0, 6, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
;
insert into ers_risk_attribution values ('AssetClass', 3, 0, 7, 0, '', 'Credit')
;
insert into ers_risk_attribution values ('AssetClass', 3, 0, 7, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
;
insert into ers_risk_attribution values ('AssetClass', 3, 0, 8, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
;
insert into ers_risk_attribution values ('AssetClass', 4, 0, 9, 0, '', 'Equity')
;
insert into ers_risk_attribution values ('AssetClass', 4, 0, 9, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
;



/* BUG# 37506 : Risk factor drill-down for HypPL - DB & Analysis */

CREATE TABLE ers_result_drilldown
(     
    value_date      int NOT NULL,
    portfolio       varchar(255) NULL,
    analysis        varchar(32) NOT NULL,
    element_id      varchar(32) NULL,
    official        int NOT NULL,
    seq_id          smallint NOT NULL,
    interpretation  varchar(16) NOT NULL,
    drillfactor1    varchar(64) NULL,
    drillfactor2    varchar(64) NULL,
    drillfactor3    varchar(64) NULL,
    amount_ccy      char(3) NOT NULL,
    amount          float NULL,
    base_amount     float NULL,
    shift           float NULL
) TABLESPACE CALYPSOSTATIC
;

CREATE  INDEX IDX_ers_result_drilldown ON ers_result_drilldown(official) TABLESPACE CALYPSOIDX
;


