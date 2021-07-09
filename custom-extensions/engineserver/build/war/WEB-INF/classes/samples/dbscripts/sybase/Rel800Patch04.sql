alter table ers_scenario_rf add rf_tenor varchar(32) null
go
alter table ers_scenario_rf modify rf_index varchar(128) 
go
alter table ers_scenario_pc_map modify rf_index varchar(128) 
go
alter table ers_scenario drop constraint UNIQ_ersscenario
go


CREATE PROCEDURE sp_upgradeERSScenario
AS
DECLARE
c1 CURSOR FOR SELECT  rf_id,rf_label FROM ers_scenario_rf
FOR  update

OPEN c1

DECLARE @rf_id integer
DECLARE @rf_label varchar(255)
DECLARE @rf_tenor varchar(32)

DECLARE @idx1 integer 
DECLARE @idx2 integer 
DECLARE @str1 varchar(32)
DECLARE @str2 varchar(32)
SELECT @idx1 = 0
SELECT @idx2 = 0
FETCH c1 INTO @rf_id,@rf_label
WHILE  (@@sqlstatus=0)
BEGIN

     SELECT @rf_tenor= rf_tenor FROM ers_scenario WHERE rf_id=@rf_id 
     UPDATE ers_scenario_rf set rf_tenor=(SELECT distinct @rf_tenor) WHERE rf_id=@rf_id 
   
     SELECT @idx1 = charindex('.',@rf_label)
	 SELECT @str1 = substring(@rf_label,@idx1,
		char_length(@rf_label)-@idx1)
     SELECT @idx2 = charindex('.',@str1)
     SELECT @str2 = substring(@str1,@idx2+1,3)   
     UPDATE ers_scenario_rf set rf_index=substring(@rf_label,1,3)||'.'||@str2  WHERE rf_id=@rf_id AND rf_risk_type='FX'

     FETCH c1 INTO  @rf_id,@rf_label
END

CLOSE c1
DEALLOCATE CURSOR c1
go

exec sp_procxmode 'sp_upgradeERSScenario', 'anymode'
go

exec sp_upgradeERSScenario
go
DROP PROCEDURE sp_upgradeERSScenario
go


alter table ers_scenario drop  rf_tenor 
go
alter table ers_scenario drop  sid 
go
alter table ers_scenario drop  rf_orig_value 
go
alter table ers_scenario_rf add rf_seq_id smallint default 0 not null
go
update ers_scenario_rf set rf_seq_id = rf_id
go
if exists (select * from sysobjects where id = object_id('sp_ers_save_scenario')  )
	drop procedure sp_ers_save_scenario
GO

CREATE PROCEDURE sp_ers_save_scenario (
				   @scset_id  smallint,
				   @scenario_id int,
				   @scenario_label    varchar(32),
				   @rf_id int,
				   @rf_shift_value double precision)
AS
UPDATE ers_scenario SET 
		       scenario_label = @scenario_label,
		       rf_shift_value = @rf_shift_value
	           WHERE scset_id = @scset_id
	           AND scenario_id = @scenario_id
	           AND rf_id = @rf_id
IF (@@rowcount = 0) 
    INSERT INTO
	ers_scenario( scset_id,scenario_id,scenario_label,rf_id,rf_shift_value)
	VALUES( @scset_id,@scenario_id,@scenario_label,@rf_id,@rf_shift_value)

go

exec sp_procxmode 'sp_ers_save_scenario', 'anymode'
go

GRANT EXECUTE on sp_ers_save_scenario TO public
go

alter table ers_scenario add constraint UNIQ_ersscenario UNIQUE(scset_id,scenario_id,rf_id)
go

CREATE TABLE ers_rate_archive
   (
   	scset_id 	smallint	NOT NULL,
   	block_id 	int		NOT NULL,
	sub_block  	int 	NOT NULL,
   	seq_id		smallint NOT NULL,
   	quote_name      varchar(255)    NOT NULL,
   	last_updated    datetime	NOT NULL,
   	time_series     image		NULL,
	constraint UNIQ_ersratearchive UNIQUE(scset_id,quote_name)
   )

GO

GRANT insert,delete,select,update on ers_rate_archive TO public
go

CREATE TABLE ers_office
   (
	doc_id		int    		NOT NULL,
        doc_name    	varchar(255)  	NOT NULL,
        mime		varchar(32)    	NOT NULL,
        user_name    	varchar(32)  	NOT NULL,
        version    	smallint	NOT NULL,
        updated_time	datetime	NOT NULL,
        doc_image	image		NULL,
        checksum	varchar(255)    NULL,
        lock_id		varchar(255)	NULL
   )
GO

GRANT insert, delete, select, update on ers_office TO public
go

alter table ers_risk_attribution add  CONSTRAINT UNIQ_ersriskattr UNIQUE (attribution_name,node_id,node_type,node_value,node_class)
GO

CREATE  INDEX IDX_ers_scenario_2 ON ers_scenario(scset_id,scenario_id,rf_id)
GO

alter table ers_job_exec add event_src int default 0 not null
GO

alter table ers_run_param add asofdate bit default 0 not null
go

alter table ers_hierarchy drop CONSTRAINT PK_ers_hierarchy
go
alter table ers_hierarchy ADD CONSTRAINT PK_ers_hierarchy PRIMARY KEY (hierarchy_name,version,node_id)
go
alter table ers_hierarchy_attribute add version smallint default 1 not null
go
alter table ers_hierarchy add version smallint default 1 not null
go
alter table ers_hierarchy_attribute add hierarchy_date datetime default '2006-01-01' not null
go
    
alter table ers_hierarchy_attribute drop CONSTRAINT PK_ers_hierarchyattr 
go
alter table ers_hierarchy_attribute add CONSTRAINT PK_ers_hierarchyattr PRIMARY KEY (hierarchy_name,version)
go


alter table ers_hierarchy_attribute add latest_version int default 1 not null
go

alter table ers_job_exec add batch_id varchar(32) null
go


if exists (select * from sysobjects where id = object_id('sp_ers_save_pc_map')  )
	drop procedure sp_ers_save_pc_map
GO

CREATE PROCEDURE sp_ers_save_pc_map (
			@rfIndex  varchar(128),
                   	@ccy     char(3),
			@desc varchar(255))
AS
IF EXISTS (SELECT * FROM ers_scenario_pc_map WHERE rf_ccy = @ccy AND pc_item = @desc)
BEGIN
    if (@rfIndex is null)
        DELETE FROM ers_scenario_pc_map WHERE rf_ccy = @ccy AND pc_item = @desc
    ELSE
        UPDATE ers_scenario_pc_map SET rf_index = @rfIndex WHERE rf_ccy = @ccy AND pc_item = @desc
END
ELSE
    BEGIN
        INSERT INTO	ers_scenario_pc_map (rf_index,rf_ccy,pc_item) VALUES(@rfIndex,@ccy,@desc)
    END

GO

exec sp_procxmode 'sp_ers_save_pc_map', 'anymode'
go

grant execute on sp_ers_save_pc_map to public
go

alter table ers_scenario_rf add scset_id smallint default 1 not null
GO
alter table ers_scenario_rf_quotes add scset_id smallint default 1 not null
GO

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
        r.group_level,
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

DELETE FROM ers_log_history WHERE run_id IN
    (
        SELECT DISTINCT r.run_id
        FROM ers_run r, ers_log_history h
        WHERE r.value_date =@valueDate
        AND r.run_id=h.run_id
        AND r.official=1
    )

INSERT INTO ers_log_history (
        analysis,
        portfolio,
        official,
        value_date,
        group_level,
        run_id,
        calc_id,
        msgLevel,
        msgCategory,
        msg,
        isException,
        exceptionMsg,
        thread,
        msgTime,
        last_updated)
SELECT  
        r.analysis,
        r.portfolio,
        1,
        r.value_date,
        r.group_level,
        l.run_id,
        l.calc_id,
        l.msgLevel,
        l.msgCategory,
        l.msg,
        l.isException,
        l.exceptionMsg,
        l.thread,
        l.msgTime,
        l.last_updated
FROM ers_run r, ers_log l
WHERE r.run_id IN 
    (
        SELECT DISTINCT r.run_id
        FROM ers_run r
        WHERE r.value_date =@valueDate
        AND r.official=1
    )
AND r.run_id = l.run_id


DELETE FROM ers_log WHERE run_id IN
    (
        SELECT DISTINCT r.run_id
        FROM ers_run r
        WHERE r.value_date = @valueDate
        AND r.official=1
    )


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
        archived)

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
	getDate()
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

