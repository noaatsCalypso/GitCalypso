alter table ers_run_history add run_id int default 0 not null
go

/* BUG# 38140 : Unordered shifts in HypPL causing incorrect Aggregate risk values for Vols */

if exists (select * from sysobjects where id = object_id('ers_risk_attribution_bk')  )
	drop table ers_risk_attribution_bk	
GO

/* Create a backup table */
CREATE TABLE ers_risk_attribution_bk
   (
	attribution_name        varchar(32)	not null,
	node_id                 smallint        not null,
	parent_id               smallint	not null,
    	seq_id                  smallint        not null,
    	node_type               smallint        not null,
    	node_class              varchar(255)    null,
	node_value              varchar(255)    not null,
    )    
GO

BEGIN TRANSACTION

/* Populate the backup table */
insert into ers_risk_attribution_bk select * from ers_risk_attribution

/* Clear the current data */

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

GO

/* BUG# 37506 : Risk factor drill-down for HypPL - DB & Analysis */

CREATE TABLE ers_result_drilldown (     
    value_date      int NOT NULL,
    portfolio       varchar(255) NULL,
    analysis        varchar(32) NOT NULL,
    element_id      varchar(32) NOT NULL,
    official        int NOT NULL,
    seq_id          smallint NOT NULL,
    interpretation  varchar(16) NOT NULL,
    drillfactor1    varchar(64) NOT NULL,
    drillfactor2    varchar(64) NULL,
    drillfactor3    varchar(64) NULL,
    amount_ccy      char(3) NOT NULL,
    amount          float NULL,
    base_amount     float NULL,
    shift           float NULL
    )
GO

CREATE  INDEX IDX_ers_result_drilldown ON ers_result_drilldown(official)
GO
alter table ers_result add group_level int default 0 not null
go

INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_HOUSEKEEPING','')
go

CREATE CLUSTERED INDEX IDX_1_ers_result_hist ON ers_result_history(analysis, portfolio, value_date)
GO


/****** Object:  Stored Procedure dbo.sp_ers_arc_result    Script Date: 01/11/2005 12:00:00 ******/
if exists (select * from sysobjects where id = object_id('sp_ers_arc_result')  )
	drop procedure sp_ers_arc_result
GO

CREATE PROC sp_ers_arc_result
AS

DECLARE @Status int

BEGIN

	BEGIN TRANSACTION
	BEGIN

	DECLARE #RptCursor CURSOR FOR SELECT DISTINCT r.portfolio, r.analysis, r.value_date
						FROM ers_run r WHERE r.official = 1 AND r.run_id > 0
	FOR READ ONLY

	OPEN #RptCursor

	DECLARE @portfolio varchar(255)
	DECLARE @analysis varchar(32)
	DECLARE @value_date int

	SELECT @Status = 0

	WHILE (@Status = 0)
	BEGIN

		FETCH #RptCursor INTO @portfolio, @analysis, @value_date
		SELECT @Status = @@sqlstatus
		select @Status

		IF (@Status <> 0)
			CONTINUE

		BEGIN
			DELETE FROM ers_run_history 
			WHERE portfolio = @portfolio 
			AND analysis = @analysis 
			AND value_date = @value_date

			DELETE FROM ers_result_history 
			WHERE portfolio = @portfolio 
			AND analysis = @analysis 
			AND value_date = @value_date
		END
	END
	CLOSE #RptCursor
	DEALLOCATE cursor #RptCursor


	DECLARE #RptCursor2 CURSOR FOR SELECT DISTINCT r.value_date
					FROM ers_run r WHERE r.official = 1
	FOR READ ONLY

	OPEN #RptCursor2

	DECLARE @value_date2 int
	SELECT @Status = 0

	WHILE (@Status = 0)
	BEGIN

		FETCH #RptCursor2 INTO @value_date2
		SELECT @Status = @@sqlstatus
		select @Status

		IF (@Status <> 0)
			CONTINUE

		BEGIN
			INSERT INTO ers_result_history (
				value_date,
				portfolio,
				analysis,
				group_level,
				is_packed,
				element_id,    
				system_id,    
				version,
				event_id,
				seq_id,      
				factor1,
				factor2,
				factor3,
				amount_ccy,
				amount,
				base_amount,
				total_on,
				packed_results)
			SELECT 
				r.value_date,
				r.portfolio,
				r.analysis,
				rr.group_level,
				r.is_packed,
				rr.element_id,    
				rr.system_id,    
				rr.version,
				rr.event_id,
				rr.seq_id,      
				rr.factor1,
				rr.factor2,
				rr.factor3,
				rr.amount_ccy,
				rr.amount,
				rr.base_amount,
				rr.total_on,
				rr.packed_results
			FROM ers_result rr, ers_run r
			WHERE r.value_date = @value_date2
			AND r.run_id = rr.run_id
			AND r.official = 1

			DELETE FROM ers_result WHERE run_id IN 
				(SELECT r.run_id FROM ers_run r
				WHERE r.value_date = @value_date2
				AND r.official = 1)

			INSERT INTO ers_run_history (
				analysis,
				portfolio,
				official,
				is_live,
				group_level,
				is_packed,
				value_date,
				base_ccy,
				user_name,
				last_updated,
				archived,
				run_id)
			SELECT 
				analysis,
				portfolio,
				official,
				is_live,
				group_level,
				is_packed,
				value_date,
				base_ccy,
				user_name,
				last_updated,
				getDate(),
				run_id
			FROM ers_run
			WHERE value_date = @value_date2
			AND official=1 AND run_id > 0

			DELETE FROM ers_run 
			WHERE value_date = @value_date2 
			AND official = 1
    	END
	END
	CLOSE #RptCursor2
	DEALLOCATE cursor #RptCursor2

	END
	COMMIT TRANSACTION
END

GO

grant execute on sp_ers_arc_result to public
GO

sp_procxmode sp_ers_arc_result, 'anymode'
GO

/****** Object:  Stored Procedure dbo.sp_ers_housekeeping    Script Date: 07/03/2007 12:00:00 ******/

if exists (select * from sysobjects where id = object_id('sp_ers_housekeeping')  )
	drop procedure sp_ers_housekeeping
GO

CREATE PROC sp_ers_housekeeping
	@currentJulianDate int = 0,
	@currentTimestamp datetime = 0,
	@adhocDays int = 0,
	@histSimDays int = 0,
	@allResultsDays int = 0,
	@value1 int = 0,
	@value2 int = 0,
	@value3 int = 0,
	@value4 int = 0
AS

DECLARE @cutoffDateAdhoc datetime
DECLARE @cutoffDateHistSim datetime
DECLARE @cutoffDateAllResults datetime
DECLARE @Status int

DECLARE @subAdhocDays int
DECLARE @subHistSimDays int
DECLARE @subAllResultsDays int

BEGIN

/* the passed julian date should be the current working day's julian date */

/* set the sign of the input values, so that they can be used in date calculations properly */

SELECT @subAdhocDays = 0
IF (@adhocDays > 0)
BEGIN
	SELECT @subAdhocDays = @adhocDays * -1
END

SELECT @subHistSimDays = 0
IF (@histSimDays > 0)
BEGIN
	SELECT @subHistSimDays = @histSimDays * -1
END

SELECT @subAllResultsDays = 0
IF (@allResultsDays > 0)
BEGIN
	SELECT @subAllResultsDays = @allResultsDays * -1
END


SELECT @cutoffDateAdhoc = DATEADD(day, @subAdhocDays, @currentTimestamp)
SELECT @cutoffDateHistSim = DATEADD(day, @subHistSimDays, @currentTimestamp)
SELECT @cutoffDateAllResults = DATEADD(day, @subAllResultsDays, @currentTimestamp)



BEGIN TRANSACTION

IF (@adhocDays > 0)
BEGIN

	SELECT @Status = 0

	DECLARE #RptCursor CURSOR FOR SELECT DISTINCT r.run_id, r.portfolio, r.analysis, r.value_date
								FROM ers_run r WHERE r.official != 1 AND r.run_id > 0 AND r.last_updated < @cutoffDateAdhoc
	FOR READ ONLY

	OPEN #RptCursor

	DECLARE @run_id_Adhoc int
	DECLARE @portfolio_Adhoc varchar(255)
	DECLARE @analysis_Adhoc varchar(32)
	DECLARE @value_date_Adhoc int

	WHILE (@Status = 0)
	BEGIN

		FETCH #RptCursor INTO @run_id_Adhoc, @portfolio_Adhoc, @analysis_Adhoc, @value_date_Adhoc
		SELECT @Status = @@sqlstatus
		SELECT @Status

		IF (@Status <> 0)
			CONTINUE

		DELETE FROM ers_log WHERE run_id = @run_id_Adhoc
		DELETE FROM ers_result WHERE run_id = @run_id_Adhoc
		DELETE FROM ers_run_param WHERE portfolio = @portfolio_Adhoc AND analysis = @analysis_Adhoc AND value_date = @value_date_Adhoc AND official != 1
		DELETE FROM ers_run WHERE run_id = @run_id_Adhoc

	END

	CLOSE #RptCursor
	DEALLOCATE CURSOR #RptCursor
END

IF (@histSimDays > 0)
BEGIN
	DELETE FROM ers_result_history WHERE value_date < (@currentJulianDate - @histSimDays) AND analysis like 'HistSim.%' AND element_id NOT LIKE 'g%'
END

IF (@allResultsDays > 0)
BEGIN

	DELETE FROM ers_log WHERE last_updated < @cutoffDateAllResults

	SELECT @Status = 0

	DECLARE #RptCursorAll CURSOR FOR SELECT DISTINCT r.portfolio, r.analysis, r.value_date
								FROM ers_run_history r WHERE r.value_date < (@currentJulianDate - @allResultsDays)
	FOR READ ONLY

	OPEN #RptCursorAll

	DECLARE @portfolio_All varchar(255)
	DECLARE @analysis_All varchar(32)
	DECLARE @value_date_All int

	WHILE (@Status = 0)
	BEGIN

		FETCH #RptCursorAll INTO @portfolio_All, @analysis_All, @value_date_All
		SELECT @Status = @@sqlstatus
		SELECT @Status

		IF (@Status <> 0)
			CONTINUE

		DELETE FROM ers_result_history WHERE portfolio = @portfolio_All AND analysis = @analysis_All AND value_date = @value_date_All
		DELETE FROM ers_run_param WHERE portfolio = @portfolio_All AND analysis = @analysis_All AND value_date = @value_date_All
		DELETE FROM ers_run_history WHERE portfolio = @portfolio_All AND analysis = @analysis_All AND value_date = @value_date_All
		DELETE FROM ers_result_drilldown WHERE portfolio = @portfolio_All AND analysis = @analysis_All AND value_date = @value_date_All

	END
	CLOSE #RptCursorAll
	DEALLOCATE CURSOR #RptCursorAll

	DELETE FROM ers_result_drilldown WHERE value_date < (@currentJulianDate - @allResultsDays)
END

COMMIT TRANSACTION

END

GO

grant execute on sp_ers_housekeeping to public
GO

sp_procxmode sp_ers_housekeeping, 'anymode'
GO


DELETE FROM ers_info
go
INSERT INTO ers_info(major_version,minor_version,sub_version,
		version_date,ref_time_zone,patch_version,released_b)
VALUES(9,0,0,'20070320','GMT','000',1)
go
