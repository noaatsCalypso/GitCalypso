alter table ers_scenario_rf add rf_tenor varchar(32) null
;
alter table ers_scenario_rf modify rf_index varchar(128) 
;
alter table ers_scenario_pc_map modify rf_index varchar(128) 
;
alter table ers_scenario drop constraint UNIQ_ers_scenario
;

create or replace procedure sp_upgradeERSScenario
AS
begin
declare
  cursor c1 is SELECT rf_id,rf_label from ers_scenario_rf;
  v_pos1 number;
  v_pos2 number;
  v_strTenor varchar2(32);
  v_str1 varchar2(32);
  v_str2 varchar2(32);
  v_strIndex varchar2(128);

begin
for c1_rec in c1 LOOP
    SELECT distinct rf_tenor INTO v_strTenor FROM ers_scenario WHERE rf_id=c1_rec.rf_id;
    UPDATE ers_scenario_rf set rf_tenor=v_strTenor WHERE rf_id=c1_rec.rf_id;
    v_pos1:=instr(c1_rec.rf_label,'.',1);
    v_pos2:=instr(c1_rec.rf_label,'.',v_pos1);
    v_str1 := substr(c1_rec.rf_label, 1, v_pos1-1);
    v_str2 := substr(c1_rec.rf_label, v_pos1+1, v_pos2-1);
    v_strIndex:=v_str1||'.'||v_str2;
    UPDATE ers_scenario_rf set rf_index=v_strIndex WHERE rf_id=c1_rec.rf_id AND rf_risk_type='FX';
--  dbms_output.put_line(v_str1||'          '||v_str2||'         '||v_str3);
--    dbms_output.put_line(v_sql);
--    execute immediate v_sql;
END LOOP;
commit;
end;
end sp_upgradeERSScenario;
/
begin
sp_upgradeERSScenario;
end;
/
DROP PROCEDURE sp_upgradeERSScenario
;


alter table ers_scenario DROP COLUMN rf_tenor 
;
alter table ers_scenario DROP COLUMN sid 
;
alter table ers_scenario DROP COLUMN rf_orig_value 
;
alter table ers_scenario_rf add rf_seq_id smallint default 0 not null
;
update ers_scenario_rf set rf_seq_id = rf_id
;

CREATE OR REPLACE PROCEDURE sp_ers_save_scenario (
scset_id 	 IN int ,
scenario_id  IN	int ,
scenario_label IN	varchar ,
rf_id 	IN int ,
rf_shift_value IN	FLOAT )
AS BEGIN
declare rowcnt	INTEGER;
BEGIN
	BEGIN
	rowcnt  := 0;
	UPDATE ers_scenario
	SET scenario_label = sp_ers_save_scenario.scenario_label,
	rf_shift_value = sp_ers_save_scenario.rf_shift_value
	WHERE scset_id = sp_ers_save_scenario.scset_id 
	AND scenario_id = sp_ers_save_scenario.scenario_id 
	AND rf_id = sp_ers_save_scenario.rf_id;
	rowcnt := SQL%ROWCOUNT;
	END;
	IF (rowcnt = 0) THEN
		BEGIN
		rowcnt  := 0;
		INSERT INTO ers_scenario (scset_id, 
			scenario_id, 
			scenario_label, 
			rf_id, 
			rf_shift_value)
			VALUES (sp_ers_save_scenario.scset_id, 
			sp_ers_save_scenario.scenario_id, 
			sp_ers_save_scenario.scenario_label, 
			sp_ers_save_scenario.rf_id, 
			sp_ers_save_scenario.rf_shift_value);
		rowcnt := SQL%ROWCOUNT;
		END;
	END IF;
END;
END;
/

ALTER TABLE ers_scenario ADD CONSTRAINT UNIQ_ersscenario UNIQUE (scset_id,scenario_id,rf_id) USING INDEX TABLESPACE CALYPSOIDX
;

CREATE TABLE ers_rate_archive
   (
   	scset_id 	smallint	NOT NULL,
   	block_id 	int		NOT NULL,
	sub_block  	int 	NOT NULL,
   	seq_id		smallint NOT NULL,
   	quote_name      varchar(255)    NOT NULL,
   	last_updated    TIMESTAMP	NOT NULL,
   	time_series     BLOB		NULL,
	constraint UNIQ_ersratearchive UNIQUE(scset_id,quote_name) USING INDEX TABLESPACE CALYPSOIDX
   )TABLESPACE CALYPSOACTIVE  
;

CREATE TABLE ers_office
   (
	doc_id		int    		NOT NULL,
        doc_name    	varchar(255)  	NOT NULL,
        mime		varchar(32)    	NOT NULL,
        user_name    	varchar(32)  	NOT NULL,
        version    	smallint	NOT NULL,
        updated_time	TIMESTAMP	NOT NULL,
        doc_image	BLOB		NULL,
        checksum	varchar(255)    NULL,
        lock_id		varchar(255)	NULL
   )TABLESPACE CALYPSOSTATIC  
;

alter table ers_risk_attribution add  CONSTRAINT UNIQ_ersriskattr UNIQUE (attribution_name,node_id,node_type,node_value,node_class) USING INDEX TABLESPACE CALYPSOIDX
;

alter table ers_job_exec add event_src int default 0 not null
;

alter table ers_run_param add asofdate char(1) default 0 not null
;
alter table ers_hierarchy drop CONSTRAINT PK_ers_hierarchy
;
alter table ers_hierarchy_attribute add version smallint default 1 not null
;
alter table ers_hierarchy add version smallint default 1 not null
;
alter table ers_hierarchy_attribute add hierarchy_date TIMESTAMP default TO_DATE('01/01/2006','DD/MM/YYYY') not null
;
alter table ers_hierarchy_attribute add latest_version int default 1 not null
;
alter table ers_job_exec add batch_id varchar(32) null
;
alter table ers_hierarchy ADD CONSTRAINT PK_ers_hierarchy PRIMARY KEY (hierarchy_name,version,node_id) USING INDEX TABLESPACE CALYPSOIDX
;

CREATE OR REPLACE PROCEDURE sp_ers_save_pc_map(
rfIndex 	VARCHAR2,
ccy 	CHAR ,
desc2 	VARCHAR2 )
AS BEGIN
DECLARE selcnt	INTEGER;

BEGIN
	BEGIN
	selcnt := 0;
	SELECT 1 INTO selcnt
	FROM DUAL
	WHERE EXISTS (
		SELECT  *
		FROM ers_scenario_pc_map 
		WHERE rf_ccy = sp_ers_save_pc_map.ccy 
		AND pc_item = sp_ers_save_pc_map.desc2);
        EXCEPTION
		WHEN OTHERS THEN
			selcnt := 0;
	END;
	IF selcnt != 0 THEN
	BEGIN
		IF (sp_ers_save_pc_map.rfIndex IS NULL) THEN
			BEGIN
			DELETE FROM ers_scenario_pc_map 
				WHERE rf_ccy = sp_ers_save_pc_map.ccy 
				AND pc_item = sp_ers_save_pc_map.desc2;
			END;
		ELSE
			BEGIN
			UPDATE ers_scenario_pc_map
			SET rf_index = sp_ers_save_pc_map.rfIndex
			WHERE rf_ccy = sp_ers_save_pc_map.ccy 
			AND pc_item = sp_ers_save_pc_map.desc2;
			END;
		END IF;
	END;
	ELSE
	BEGIN
		BEGIN
		INSERT INTO ers_scenario_pc_map (rf_index, 
			rf_ccy, 
			pc_item)
			VALUES (sp_ers_save_pc_map.rfIndex, 
			sp_ers_save_pc_map.ccy, 
			sp_ers_save_pc_map.desc2);
		END;
	END;
	END IF;
END;
END;
/


alter table ers_scenario_rf add scset_id smallint default 1 not null
;
alter table ers_scenario_rf_quotes add scset_id smallint default 1 not null
;

CREATE OR REPLACE PROCEDURE sp_ers_arc_result 
    (valueDate		IN  INTEGER )
AS 
BEGIN
DECLARE
  CURSOR RptCursor is 
  	SELECT r.portfolio, r.analysis FROM ers_run r WHERE r.value_date=sp_ers_arc_result.valueDate AND r.official=1 AND r.run_id>0;
	BEGIN
	FOR c1_rec in RptCursor LOOP
		DELETE FROM ers_run_history WHERE portfolio=c1_rec.portfolio AND analysis=c1_rec.analysis AND value_date=sp_ers_arc_result.valueDate;
		DELETE FROM ers_result_history WHERE portfolio=c1_rec.portfolio AND analysis=c1_rec.analysis AND value_date=sp_ers_arc_result.valueDate;
	END LOOP;
	END;

INSERT INTO ers_result_history 
( value_date
, portfolio
, analysis
, group_level
, is_packed
, element_id
, system_id
, version
, event_id
, seq_id
, factor1
, factor2
, factor3
, amount_ccy
, amount
, base_amount
, total_on
, packed_results) 

(SELECT r.value_date
, r.portfolio
, r.analysis
, r.group_level
, r.is_packed
, rr.element_id
, rr.system_id
, rr.version
, rr.event_id
, rr.seq_id
, rr.factor1
, rr.factor2
, rr.factor3
, rr.amount_ccy
, rr.amount
, rr.base_amount
, rr.total_on
, rr.packed_results 
FROM ers_result rr,ers_run r 
WHERE r.value_date = sp_ers_arc_result.valueDate
AND r.run_id=rr.run_id  
AND r.official=1);

DELETE FROM ers_log_history 
WHERE run_id IN 
    (SELECT DISTINCT r.run_id 
    FROM ers_run r, ers_log_history h 
    WHERE r.value_date = sp_ers_arc_result.valueDate   
    AND r.run_id=h.run_id 
    AND r.official=1 );


INSERT INTO ers_log_history 
(analysis
, portfolio
, official
, value_date
, group_level
, run_id
, calc_id
, msgLevel
, msgCategory
, msg
, isException
, thread
, msgTime
, last_updated) 

(SELECT r.analysis
, r.portfolio
, 1
, r.value_date
, r.group_level
, l.run_id
, l.calc_id
, l.msgLevel
, l.msgCategory
, l.msg
, l.isException
, l.thread  
, l.msgTime
, l.last_updated 
FROM ers_run r, ers_log l 
WHERE r.run_id IN 
    (SELECT DISTINCT r.run_id 
    FROM ers_run r 
    WHERE r.value_date = sp_ers_arc_result.valueDate
    AND r.official=1 ) 
AND r.run_id = l.run_id );

UPDATE ers_log_history h 
SET (h.exceptionMsg) = 
    (SELECT l.exceptionMsg 
     FROM ers_log l 
     WHERE h.run_id IN 
        ( SELECT DISTINCT r.run_id 
          FROM ers_run r 
          WHERE r.value_date = sp_ers_arc_result.valueDate
          AND r.official=1 ) 
    AND h.run_id=l.run_id 
    AND h.calc_id=l.calc_id 
    AND h.msgLevel=l.msgLevel 
    AND h.msgCategory=l.msgCategory 
    AND h.msg=l.msg 
    AND h.isException = 1 
    AND h.thread=l.thread 
    AND h.msgTime=l.msgTime 
    AND rownum <= 1) 
WHERE EXISTS 
(SELECT l.exceptionMsg 
FROM ers_log l 
WHERE h.run_id 
IN 
    (SELECT DISTINCT r.run_id 
    FROM ers_run r 
    WHERE r.value_date = valueDate
    AND r.official=1 ) 
AND h.run_id=l.run_id 
AND h.calc_id=l.calc_id 
AND h.msgLevel=l.msgLevel 
AND h.msgCategory=l.msgCategory 
AND h.msg=l.msg 
AND h.isException=1 
AND h.thread=l.thread 
AND h.msgTime=l.msgTime); 

DELETE FROM ers_log 
WHERE run_id IN 
    (SELECT DISTINCT r.run_id 
     FROM ers_run r 
     WHERE r.value_date = sp_ers_arc_result.valueDate
     AND r.official=1);

DELETE FROM ers_result 
WHERE run_id IN 
    (SELECT r.run_id 
     FROM ers_run r 
     WHERE r.value_date = sp_ers_arc_result.valueDate
     AND r.official=1); 
 
INSERT INTO ers_run_history 
(analysis
, portfolio
, official
, is_live
, group_level
, is_packed
, value_date
, base_ccy
, user_name
, last_updated
, archived) 

(SELECT analysis
, portfolio
, official
, is_live
, group_level
, is_packed
, value_date
, base_ccy
, user_name
, last_updated
, SYSTIMESTAMP 
FROM ers_run 
WHERE value_date = sp_ers_arc_result.valueDate
AND official=1 
AND run_id>0 );

DELETE FROM ers_run 
WHERE value_date = sp_ers_arc_result.valueDate
AND official=1; 

COMMIT; 
END;
/


