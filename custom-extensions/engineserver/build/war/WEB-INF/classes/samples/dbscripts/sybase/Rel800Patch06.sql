alter table ers_result add group_level int default 0 not null
go

/****** Object:  Stored Procedure dbo.sp_ers_arc_result    Script Date: 01/11/2005 12:00:00 ******/
if exists (select * from sysobjects where id = object_id('sp_ers_arc_result')  )
	drop procedure sp_ers_arc_result
GO

CREATE PROC sp_ers_arc_result

@valueDate	int
AS

DECLARE @Status int
SELECT @Status 		= 0


BEGIN

BEGIN TRANSACTION


DECLARE #RptCursor CURSOR FOR SELECT r.portfolio, r.analysis
					FROM ers_run r WHERE r.value_date=@valueDate AND r.official=1 AND r.run_id>0
FOR READ ONLY

OPEN #RptCursor

DECLARE @portfolio varchar(255)
DECLARE @analysis varchar(32)

WHILE (@Status = 0)

BEGIN

	FETCH #RptCursor INTO @portfolio,@analysis 
	SELECT @Status = @@sqlstatus
	select @Status

	IF (@Status <> 0)
		CONTINUE

	BEGIN
		DELETE FROM ers_run_history WHERE portfolio=@portfolio AND analysis=@analysis AND value_date=@valueDate
		DELETE FROM ers_result_history WHERE portfolio=@portfolio AND analysis=@analysis AND value_date=@valueDate
		
	END

END

CLOSE #RptCursor
DEALLOCATE cursor #RptCursor


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
FROM ers_result rr,ers_run r
WHERE r.value_date =@valueDate
AND r.run_id=rr.run_id
AND r.official=1

DELETE FROM ers_result WHERE run_id IN 
	(SELECT r.run_id FROM ers_run r
	WHERE r.value_date =@valueDate
	AND r.official=1)

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
WHERE value_date= @valueDate
AND official=1 AND run_id>0

DELETE FROM ers_run WHERE value_date=@valueDate AND official=1

COMMIT TRANSACTION

END

GO

sp_procxmode sp_ers_arc_result, 'anymode'
go

grant execute on sp_ers_arc_result to public
go

DELETE FROM ers_info
go
INSERT INTO ers_info(major_version,minor_version,sub_version,
       version_date,ref_time_zone,patch_version,released_b)
VALUES(8,0,0,'20070228','GMT','006',1)
go
