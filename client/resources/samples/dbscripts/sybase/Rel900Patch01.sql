
/* BZ 41065 : Run parameter to specifiy risk factor drilldown */

alter table ers_run_param add create_drilldown_results bit default 0 not null
go

alter table ers_batch add create_drilldown_results bit default 0 not null
go


delete from ers_risk_attribution

COMMIT TRANSACTION
GO

insert into ers_risk_attribution values ('Aggr', 1, 0, 1, 0, '', 'Aggr')
insert into ers_risk_attribution values ('Aggr', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
insert into ers_risk_attribution values ('Aggr', 1, 0, 2, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
insert into ers_risk_attribution values ('Aggr', 1, 0, 3, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
insert into ers_risk_attribution values ('Aggr', 1, 0, 4, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
insert into ers_risk_attribution values ('Aggr', 1, 0, 5, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
insert into ers_risk_attribution values ('Aggr', 1, 0, 6, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
insert into ers_risk_attribution values ('Aggr', 1, 0, 7, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
insert into ers_risk_attribution values ('Aggr', 1, 0, 8, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
insert into ers_risk_attribution values ('Aggr', 1, 0, 9, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
insert into ers_risk_attribution values ('Aggr', 1, 0, 10, 1, 'tk.risk.sim.ShiftItemCurveInflation', 'Inflation')

insert into ers_risk_attribution values ('Standard', 1, 0, 1, 0, '', 'FX')
insert into ers_risk_attribution values ('Standard', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
insert into ers_risk_attribution values ('Standard', 2, 0, 2, 0, '', 'Rates')
insert into ers_risk_attribution values ('Standard', 2, 0, 2, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
insert into ers_risk_attribution values ('Standard', 3, 0, 3, 0, '', 'Credit')
insert into ers_risk_attribution values ('Standard', 3, 0, 3, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
insert into ers_risk_attribution values ('Standard', 4, 0, 4, 0, '', 'Equity')
insert into ers_risk_attribution values ('Standard', 4, 0, 4, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
insert into ers_risk_attribution values ('Standard', 5, 0, 5, 0, '', 'Vols')
insert into ers_risk_attribution values ('Standard', 5, 0, 5, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
insert into ers_risk_attribution values ('Standard', 5, 0, 6, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
insert into ers_risk_attribution values ('Standard', 5, 0, 7, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
insert into ers_risk_attribution values ('Standard', 5, 0, 8, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
insert into ers_risk_attribution values ('Standard', 6, 0, 9, 0, '', 'Correlation')
insert into ers_risk_attribution values ('Standard', 6, 0, 9, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
insert into ers_risk_attribution values ('Standard', 7, 0, 10, 0, '', 'Inflation')
insert into ers_risk_attribution values ('Standard', 7, 0, 10, 1, 'tk.risk.sim.ShiftItemCurveInflation', 'Inflation')

insert into ers_risk_attribution values ('AssetClass', 1, 0, 1, 0, '', 'FX')
insert into ers_risk_attribution values ('AssetClass', 1, 0, 1, 1, 'tk.risk.sim.ShiftItemFX', 'FX')
insert into ers_risk_attribution values ('AssetClass', 1, 0, 2, 1, 'tk.risk.sim.ShiftItemFXVolatilitySurface', 'FX Vols')
insert into ers_risk_attribution values ('AssetClass', 2, 0, 3, 0, '', 'Rates')
insert into ers_risk_attribution values ('AssetClass', 2, 0, 3, 1, 'tk.risk.sim.ShiftItemCurveZero', 'Rates')
insert into ers_risk_attribution values ('AssetClass', 2, 0, 4, 1, 'tk.risk.sim.ShiftItemVolatilitySurface3D', 'Vols')
insert into ers_risk_attribution values ('AssetClass', 2, 0, 5, 1, 'tk.risk.sim.ShiftItemCap', 'Vols')
insert into ers_risk_attribution values ('AssetClass', 2, 0, 6, 1, 'tk.risk.sim.ShiftItemFloor', 'Vols')
insert into ers_risk_attribution values ('AssetClass', 3, 0, 7, 0, '', 'Credit')
insert into ers_risk_attribution values ('AssetClass', 3, 0, 7, 1, 'tk.risk.sim.ShiftItemCurveProbability', 'Credit')
insert into ers_risk_attribution values ('AssetClass', 3, 0, 8, 1, 'tk.risk.sim.ShiftItemCorrelationSurface', 'CorrelationSkew')
insert into ers_risk_attribution values ('AssetClass', 4, 0, 9, 0, '', 'Equity')
insert into ers_risk_attribution values ('AssetClass', 4, 0, 9, 1, 'tk.risk.sim.ShiftItemEquity', 'Equity')
insert into ers_risk_attribution values ('AssetClass', 5, 0, 10, 0, '', 'Inflation')
insert into ers_risk_attribution values ('AssetClass', 5, 0, 10, 1, 'tk.risk.sim.ShiftItemCurveInflation', 'Inflation')

GO

DELETE FROM ers_info
go
INSERT INTO ers_info(major_version,minor_version,sub_version,
		version_date,ref_time_zone,patch_version,released_b)
VALUES(9,0,0,'20070515','GMT','001',1)
go
