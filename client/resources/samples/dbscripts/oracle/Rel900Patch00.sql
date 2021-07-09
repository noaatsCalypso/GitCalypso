
INSERT INTO domain_values (name,value,description) VALUES('scheduledTask','ERS_HOUSEKEEPING','')
;

CREATE INDEX IDX_1_ers_result_hist ON ers_result_history(analysis, portfolio, value_date) TABLESPACE CALYPSOIDX
;


CREATE OR REPLACE PROCEDURE sp_ers_arc_result 
AS 
BEGIN
	DECLARE CURSOR RptCursor is 
		SELECT DISTINCT r.portfolio, r.analysis, r.value_date FROM ers_run r WHERE r.official = 1 AND r.run_id > 0;
	BEGIN
	FOR c1_rec in RptCursor LOOP
		DELETE FROM ers_run_history
		WHERE portfolio = c1_rec.portfolio 
		AND analysis = c1_rec.analysis 
		AND value_date = c1_rec.value_date;

		DELETE FROM ers_result_history 
		WHERE portfolio = c1_rec.portfolio 
		AND analysis = c1_rec.analysis 
		AND value_date = c1_rec.value_date;
	END LOOP;
	END;

	DECLARE CURSOR RptCursor2 is 
		SELECT DISTINCT r.value_date FROM ers_run r WHERE r.official = 1;
	BEGIN
	FOR c2_rec in RptCursor2 LOOP
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
		, rr.group_level
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
		WHERE r.value_date = c2_rec.value_date
		AND r.run_id = rr.run_id  
		AND r.official = 1);

		DELETE FROM ers_result 
		WHERE run_id IN 
			(SELECT r.run_id 
			FROM ers_run r 
			WHERE r.value_date = c2_rec.value_date
			AND r.official = 1); 
 
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
		, archived
		, run_id) 

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
		, run_id
		FROM ers_run 
		WHERE value_date = c2_rec.value_date
		AND official = 1 
		AND run_id > 0 );

		DELETE FROM ers_run 
		WHERE value_date = c2_rec.value_date
		AND official = 1; 

	END LOOP;
	END;

COMMIT; 
END;
/


CREATE OR REPLACE PROCEDURE sp_ers_housekeeping (
	currentJulianDate IN INTEGER,
	currentTimestamp IN TIMESTAMP,
	adhocDays IN INTEGER,
	histSimDays IN INTEGER,
	allResultsDays IN INTEGER,
	value1 IN INTEGER,
	value2 IN INTEGER,
	value3 IN INTEGER,
	value4 IN INTEGER )
AS BEGIN
	DECLARE cutoffDateAdhoc TIMESTAMP;
			cutoffDateHistSim TIMESTAMP;
			cutoffDateAllResults TIMESTAMP;
			subAdhocDays INTEGER;
			subHistSimDays INTEGER;
			subAllResultsDays INTEGER;

BEGIN
	subAdhocDays := 0;
	IF (adhocDays > 0) THEN
		BEGIN
		subAdhocDays := adhocDays;
		END;
	END IF;

	subHistSimDays := 0;
	IF (histSimDays > 0) THEN
		BEGIN
		subHistSimDays := histSimDays;
		END;
	END IF;

	subAllResultsDays := 0;
	IF (allResultsDays > 0) THEN
		BEGIN
		subAllResultsDays := allResultsDays;
		END;
	END IF;

	cutoffDateAdhoc := currentTimestamp - subAdhocDays;
	cutoffDateHistSim := currentTimestamp - subHistSimDays;
	cutoffDateAllResults := currentTimestamp - subAllResultsDays;

	BEGIN
	IF (adhocDays > 0) THEN
		BEGIN

		DECLARE CURSOR RptCursor is 
			SELECT DISTINCT r.run_id, r.portfolio, r.analysis, r.value_date
			FROM ers_run r
			WHERE r.official != 1 AND r.run_id > 0 AND last_updated < cutoffDateAdhoc;
		BEGIN
			FOR c1_rec in RptCursor LOOP
				DELETE FROM ers_log WHERE run_id = c1_rec.run_id;
				DELETE FROM ers_result WHERE run_id = c1_rec.run_id;
				DELETE FROM ers_run_param WHERE portfolio = c1_rec.portfolio AND analysis = c1_rec.analysis AND value_date = c1_rec.value_date AND official != 1;
				DELETE FROM ers_run WHERE run_id = c1_rec.run_id;
			END LOOP;
		END;
 
		END;
	END IF;

	IF (histSimDays > 0) THEN
		BEGIN
		DELETE FROM ers_result_history WHERE value_date < (currentJulianDate - histSimDays) AND analysis like 'HistSim.%' AND element_id NOT LIKE 'g%';
		END;
	END IF;

	IF (allResultsDays > 0) THEN
		BEGIN

		DELETE FROM ers_log WHERE last_updated < cutoffDateAllResults;

		DECLARE CURSOR RptCursor2 is 
			SELECT DISTINCT r.portfolio, r.analysis, r.value_date
			FROM ers_run_history r
			WHERE value_date < (currentJulianDate - subAllResultsDays);
		BEGIN
			FOR c2_rec in RptCursor2 LOOP
				DELETE FROM ers_result_history WHERE portfolio = c2_rec.portfolio AND analysis = c2_rec.analysis AND value_date = c2_rec.value_date;
				DELETE FROM ers_run_param WHERE portfolio = c2_rec.portfolio AND analysis = c2_rec.analysis AND value_date = c2_rec.value_date;
				DELETE FROM ers_run_history WHERE portfolio = c2_rec.portfolio AND analysis = c2_rec.analysis AND value_date = c2_rec.value_date;
				DELETE FROM ers_result_drilldown WHERE portfolio = c2_rec.portfolio AND analysis = c2_rec.analysis AND value_date = c2_rec.value_date;
			END LOOP;
		END;

		DELETE FROM ers_result_drilldown WHERE value_date < (currentJulianDate - subAllResultsDays);
		END;
	END IF;
	END;

	COMMIT;
END;
END;
/



DELETE FROM ers_info
;
INSERT INTO ers_info(major_version,minor_version,sub_version,
	version_date,ref_time_zone,patch_version,released_b)
VALUES(9,0,0,TO_DATE('20/03/2007','DD/MM/YYYY'),'GMT','000','1')
;
