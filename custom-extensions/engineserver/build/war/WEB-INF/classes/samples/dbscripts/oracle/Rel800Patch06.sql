alter table ers_result add group_level int default 0 not null
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
WHERE r.value_date = sp_ers_arc_result.valueDate
AND r.run_id=rr.run_id  
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
WHERE value_date = sp_ers_arc_result.valueDate
AND official=1 
AND run_id>0 );

DELETE FROM ers_run 
WHERE value_date = sp_ers_arc_result.valueDate
AND official=1; 

COMMIT; 
END;
/


DELETE FROM ers_info
;
INSERT INTO ers_info(major_version,minor_version,sub_version,
       version_date,ref_time_zone,patch_version,released_b)
VALUES(8,0,0,TO_DATE('28/02/2007','DD/MM/YYYY'),'GMT','006','1')
;
