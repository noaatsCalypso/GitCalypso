CREATE OR REPLACE FUNCTION sp_ers_arc_result (
	dateTo IN INTEGER,
	value1 IN INTEGER)
RETURNS INT  language plpgsql
AS $BODY$
DECLARE
  errMsg varchar;
  v_errm varchar;
   
  c1_rec record;
  c2_rec record;
  
BEGIN

    LOCK TABLE ers_result_history IN EXCLUSIVE MODE NOWAIT;
	BEGIN
	FOR c1_rec in SELECT DISTINCT r.portfolio, r.analysis, r.value_date FROM ers_run r WHERE r.official = 1 AND r.value_date<=dateTo
	LOOP
		DELETE
		FROM ers_run_history
		WHERE portfolio = c1_rec.portfolio 
		AND analysis = c1_rec.analysis 
		AND value_date = c1_rec.value_date;

		DELETE 
		FROM ers_result_history 
		WHERE portfolio = c1_rec.portfolio 
		AND analysis = c1_rec.analysis 
		AND value_date = c1_rec.value_date;
	END LOOP;
	END;

	BEGIN
	FOR c2_rec in SELECT DISTINCT r.run_id FROM ers_run r WHERE r.official = 1 AND r.value_date<=dateTo
	LOOP	
		INSERT
		INTO ers_result_history 
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
		WHERE r.run_id = rr.run_id 
		and r.run_id = c2_rec.run_id  
		AND r.official = 1);

		DELETE
		FROM ers_result 
		WHERE run_id IN 
			(SELECT r.run_id 
			FROM ers_run r 
			WHERE r.run_id = c2_rec.run_id
			AND r.official = 1); 
 
		INSERT
		INTO ers_run_history 
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
		, CURRENT_TIMESTAMP
		, run_id
		FROM ers_run 
		WHERE run_id = c2_rec.run_id
		AND official = 1 );

		DELETE
		FROM ers_run 
		WHERE run_id = c2_rec.run_id
		AND official = 1; 

	END LOOP;
	END;
	
RETURN 0;

EXCEPTION
    	WHEN unique_violation THEN
		  RAISE 'Error = %, run_Id = %', sqlerrm, c2_rec.run_id;

END;
$BODY$
;


CREATE OR REPLACE FUNCTION market_risk_S_OVERWRITE_HIERARCHY_POSTGRES(
	p1_hierarchy_name varchar, p1_version int, p2_hierarchy_name varchar, p2_version int, p3_hierarchy_name varchar, p3_version int, 
	p4_hierarchy_name varchar, p4_version int, p_hierarchy_date timestamp, p4_latest_version int, p_hierarchy_type varchar, p_latest_version int, 
	p_hierarchy_name varchar, p_hierarachy_type varchar) 
RETURNS INT  language plpgsql
AS $$
DECLARE x int;
BEGIN
	delete from ers_hierarchy where hierarchy_name=p1_hierarchy_name and version=p1_version; 
	delete from ers_hierarchy_node_attribute where hierarchy_name=p2_hierarchy_name and version=p2_version; 
	select count(*) into x from ers_hierarchy_attribute where hierarchy_name=p3_hierarchy_name and version=p3_version; 
	if x=0 then 
		insert into ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type) 
			values (p4_hierarchy_name,'__ALL__',14,p4_version,p_hierarchy_date,p4_latest_version, p_hierarchy_type);
	else
		update ers_hierarchy_attribute set latest_version=p_latest_version where hierarchy_name=p_hierarchy_name and hierarchy_type like p_hierarachy_type ;       
	end if;
RETURN 0;
end $$;
;

CREATE OR REPLACE FUNCTION market_risk_DELETE_HIERARCHY_POSTGRES(
    del_hierarchy_name varchar, del_version int, del_hierarachy_type varchar, 
    ins_hierarchy_name varchar, ins_version int, ins_hierarchy_date timestamp, ins_latest_version int, ins_hierarachy_type varchar,
    upd_latest_version int, upd_hierarchy_name varchar, upd_hierarachy_type varchar)
RETURNS void language plpgsql
AS $$
BEGIN
	DELETE FROM ers_hierarchy_attribute WHERE hierarchy_name=del_hierarchy_name and version=del_version and hierarchy_type like del_hierarachy_type;
	
	INSERT INTO ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type) 
	   VALUES (ins_hierarchy_name,'__ALL__',14,ins_version,ins_hierarchy_date,ins_latest_version,ins_hierarachy_type);
	   
	UPDATE ers_hierarchy_attribute SET latest_version=upd_latest_version WHERE hierarchy_name=upd_hierarchy_name and hierarchy_type like upd_hierarachy_type;
END $$;
;


CREATE OR REPLACE FUNCTION market_risk_S_OVERWRITE_HIERARCHY_ATTRIBUTE(
	p1_hierarchy_name varchar, p1_version int, p1_hierarchy_type varchar,
	p2_hierarchy_name varchar, p2_version int, p2_hierarchy_date timestamp, p2_latest_version int, p2_hierarchy_type varchar,
	p3_latest_version int, p3_hierarchy_name varchar, p3_hierarachy_type varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    delete from ers_hierarchy_attribute where hierarchy_name=p1_hierarchy_name and version=p1_version and hierarchy_type like p1_hierarchy_type;
    insert into ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type)
	values (p2_hierarchy_name,'__ALL__',14,p2_version,p2_hierarchy_date,p2_latest_version,p2_hierarchy_type); 
    update ers_hierarchy_attribute set latest_version=p3_latest_version where hierarchy_name=p3_hierarchy_name and hierarchy_type like p3_hierarachy_type ;
RETURN 0;
END $$;


CREATE OR REPLACE FUNCTION market_risk_S_INSERT_HIERARCHY_ATTRIBUTE(
	p2_hierarchy_name varchar, p2_version int, p2_hierarchy_date timestamp, p2_latest_version int, p2_hierarchy_type varchar,
	p3_latest_version int, p3_hierarchy_name varchar, p3_hierarachy_type varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    insert into ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type)
	values (p2_hierarchy_name,'__ALL__',14,p2_version,p2_hierarchy_date,p2_latest_version,p2_hierarchy_type); 
    update ers_hierarchy_attribute set latest_version=p3_latest_version where hierarchy_name=p3_hierarchy_name and hierarchy_type like p3_hierarachy_type ;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_INSERT_COMPLETED_POSTGRES(
	p1_run_id bigint, p_task_id bigint, p_analysis varchar, p_portfolio varchar, p_param_set varchar, p_value_date int, p2_run_id bigint, 
	p_exec_time timestamp, p_exec_status int, p_end_time timestamp, p_user_name varchar, p_submit_time timestamp, p_event_src int, p_batch_id varchar ) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    DELETE FROM ers_job_exec WHERE run_id= p1_run_id;
    INSERT INTO ers_job_exec (task_id,analysis,portfolio,param_set,value_date,run_id,exec_time,exec_status,end_time,user_name,submit_time,event_src,batch_id) VALUES 
    (p_task_id, p_analysis, p_portfolio, p_param_set, p_value_date, p2_run_id, p_exec_time, p_exec_status, p_end_time, p_user_name, p_submit_time, p_event_src, p_batch_id);
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_UPDATE_ERS_PROPERTY(p1_currentIntDate int, p2_currentIntDate int) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    DELETE FROM ers_property WHERE effective_date=p1_currentIntDate AND pending_user=' ';
    UPDATE ers_property SET expiration_date=p2_currentIntDate WHERE expiration_date is null AND pending_user=' ';
RETURN 0;
END $$;
;


CREATE OR REPLACE FUNCTION market_risk_S_DELETE_PENDING_POSTGRES(p1_hierarchy_name varchar, p1_user_name varchar, p1_hierarchy_type varchar,
			p2_hierarchy_name varchar, p2_user_name varchar, p3_hierarchy_name varchar, p3_user_name varchar ) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    DELETE FROM ers_h_attribute_pending WHERE hierarchy_name= p1_hierarchy_name and user_name= p1_user_name and hierarchy_type like p1_hierarchy_type;
    DELETE FROM ers_h_pending WHERE hierarchy_name = p2_hierarchy_name and user_name= p2_user_name;
    DELETE FROM ers_h_node_attribute_pending WHERE hierarchy_name = p3_hierarchy_name and user_name=p3_user_name;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_OVERWRITE_HIERARCHY_PENDING_POSTGRES(p1_hierarchy_name varchar, p1_user_name varchar, p1_hierarchy_type varchar,
			p2_hierarchy_name varchar, p2_user_name varchar, p3_hierarchy_name varchar, p3_user_name varchar,
			p4_hierarchy_name varchar, p4_modified_date timestamp, p4_hierarchy_type varchar, p4_user_name varchar, p4_action_type varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	call market_risk_S_DELETE_PENDING_POSTGRES(p1_hierarchy_name, p1_user_name, p1_hierarchy_type,p2_hierarchy_name, p2_user_name, p3_hierarchy_name, p3_user_name);
    INSERT INTO ers_h_attribute_pending (hierarchy_name,modified_date,hierarchy_type,user_name,action_type) VALUES (p4_hierarchy_name, p4_modified_date, p4_hierarchy_type, p4_user_name, p4_action_type);
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_ATTRIBUTE(p1_version int, p1_hierarchy_date timestamp, p1_latest_version int, 
			p2_hierarchy_name varchar, p2_user_name varchar, p3_latest_version int, p3_hierarchy_name varchar, p3_hierarchy_type varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
    INSERT INTO ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type) 
	SELECT hierarchy_name,'__ALL__',14,p1_version, p1_hierarchy_date, p1_latest_version,hierarchy_type 
	FROM ers_h_attribute_pending WHERE hierarchy_name=p2_hierarchy_name AND user_name=p2_user_name;
	UPDATE ers_hierarchy_attribute SET latest_version=p3_latest_version WHERE hierarchy_name=p3_hierarchy_name and hierarchy_type like p3_hierarchy_type;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_OVERWRITE_TRANSFER_ATTRIBUTE( 
	p1_hierarchy_name varchar, p1_version int, p1_hierarchy_type varchar,
	p2_hierarchy_name varchar, p2_version int, 
	p3_hierarchy_name varchar, p3_version int, 
	p4_version int, p4_hierarchy_date timestamp, p2_latest_version int,
	p5_hierarchy_name varchar, p5_user_name varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
		DELETE FROM ers_hierarchy_attribute WHERE hierarchy_name=p1_hierarchy_name and version=p1_version and hierarchy_type like p1_hierarchy_type;
		DELETE FROM ers_hierarchy WHERE hierarchy_name=p2_hierarchy_name AND version=p2_version;
		DELETE FROM ers_hierarchy_node_attribute WHERE hierarchy_name=p3_hierarchy_name and version=p3_version;		
		INSERT INTO ers_hierarchy_attribute (hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type)
		SELECT hierarchy_name,'__ALL__',14,p4_version,p4_hierarchy_date,p2_latest_version,hierarchy_type
		FROM ers_h_attribute_pending
		WHERE hierarchy_name=p5_hierarchy_name AND user_name=p5_user_name;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_OVERWRITE_UPDATELASTVERSION_TRANSFER_ATTRIBUTE( 
	p1_hierarchy_name varchar, p1_version int, p1_hierarchy_type varchar,
	p2_hierarchy_name varchar, p2_version int, 
	p3_hierarchy_name varchar, p3_version int, 
	p4_version int, p4_hierarchy_date timestamp, p2_latest_version int,
	p5_hierarchy_name varchar, p5_user_name varchar,
	p6_version int, p6_hierarchy_name varchar, p6_hierarchy_type varchar) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	call market_risk_S_OVERWRITE_TRANSFER_ATTRIBUTE(
	p1_hierarchy_name, p1_version, p1_hierarchy_type,
	p2_hierarchy_name, p2_version, 
	p3_hierarchy_name, p3_version, 
	p4_version, p4_hierarchy_date, p2_latest_version,
	p5_hierarchy_name, p5_user_name);
	UPDATE ers_hierarchy_attribute SET latest_version=p6_version WHERE hierarchy_name=p6_hierarchy_name and hierarchy_type like p6_hierarchy_type;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_INSERT_RUNINFO_POSTGRESQL( 
	p_isToday int, p1_newRunId bigint, p2_newRunId bigint, p1_portfolio varchar, 
	p1_runId bigint, p3_newRunId bigint, p2_portfolio varchar, p4_newRunId bigint, p2_runId bigint,
	p_analysis varchar, p3_portfolio varchar, p_valDate int, p4_portfolio varchar, p_runId_1 bigint 
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	IF p_isToday>0 THEN 
			BEGIN
				DELETE FROM ers_run WHERE run_id=p1_newRunId;
				INSERT INTO ers_run(run_id, analysis, portfolio, official, group_level, is_live, is_packed, value_date, base_ccy, user_name, last_updated)
				(SELECT p2_newRunId, analysis, p1_portfolio, 1, group_level, is_live, is_packed, value_date, base_ccy, user_name, last_updated
				FROM ers_run where run_id = p1_runId);
			END;
	ELSE 
			BEGIN
				DELETE FROM ers_run_history WHERE run_id=p3_newRunId;
				INSERT INTO ers_run_history(analysis, portfolio, official, group_level, is_live, is_packed, value_date, base_ccy, user_name, last_updated, archived, run_id)
				(SELECT analysis, p2_portfolio, 1, group_level, is_live, is_packed, value_date, base_ccy, user_name, last_updated, CURRENT_TIMESTAMP, p4_newRunId
				FROM ers_run where run_id = p2_runId);
			END;
	END IF;
	DELETE FROM ers_run_param WHERE analysis=p_analysis and portfolio=p3_portfolio and value_date=p_valDate and official=1;
	INSERT INTO ers_run_param(analysis, portfolio, value_date, param_set, pricing_env, value_time, official, trade_explode, asofdate, create_drilldown_results)
	(SELECT analysis, p4_portfolio, value_date, param_set, pricing_env, value_time, 1, trade_explode, asofdate, create_drilldown_results
	FROM ers_run_param WHERE official = p_runId_1);
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_DELETE_ADHOC_RESULT_POSTGRES( 
	p1_runId int,p2_runId int,p3_runId int,p4_officialId int,p5_officialId int,p6_runId int,p7_runId int
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
		DELETE FROM ers_run WHERE run_id=p1_runId;
		DELETE FROM ers_log WHERE run_id=p2_runId;
		DELETE FROM ers_result WHERE run_id=p3_runId;
		DELETE FROM ers_result_drilldown WHERE official=p4_officialId;
		DELETE FROM ers_run_param WHERE official=p5_officialId;
		DELETE FROM ers_scenario_rule_audit WHERE event_src=p6_runId;
		DELETE FROM ers_result_rf WHERE run_id=p7_runId;
RETURN 0;
END $$;
;


CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_PENDING_POSTGRES( 
	p_pendingUser varchar
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	DELETE FROM rms_scenario_measure WHERE comments is null or comments not like 'Auto Generated%';
	INSERT INTO rms_scenario_measure(measure_id,session_id,risk_analysis,risk_measure,scen_name,grouping,is_scenario,formula,comments,category)
	SELECT measure_id,session_id,risk_analysis,risk_measure,scen_name,grouping,is_scenario,formula,comments,category
	FROM rms_scenario_measure_pending
	WHERE user_name= p_pendingUser
	AND (action_type<>3	OR measure_id in (SELECT distinct measure_id from rms_pos_risk_stress));
	
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_RISK_POSTGRES( 
	p1_riskType varchar, p2_riskType varchar, p_pendingUser varchar
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
		DELETE FROM ers_risk_attribution WHERE attribution_name=p1_riskType;
		INSERT INTO ers_risk_attribution (attribution_name, node_id, parent_id, seq_id, node_type, node_class, node_value)
		SELECT attribution_name, node_id, parent_id, seq_id, node_type, node_class, node_value
		FROM ers_risk_attribution_pending
		WHERE attribution_name=p1_riskType AND user_name=p_pendingUser;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_DELETE_ARCHIVE_ITEMS_POSTGRES( 
	p_user varchar, p1_liquiditySetId int, p2_liquiditySetId int, p3_liquiditySetId int
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
		INSERT INTO ers_a_liquidity_period (audit_date, audit_user, product_type, product_name, threshold, liquidity_period , bidask_spread, liquidity_set_id )
		SELECT current_timestamp, p_user, product_type, product_name, threshold, liquidity_period, bidask_spread, p1_liquiditySetId  FROM ers_liquidity_period where liquidity_set_id = p2_liquiditySetId ;
		DELETE FROM ers_liquidity_period where liquidity_set_id = p3_liquiditySetId; 
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_DELETE_ITEMS_ANDUPDATE_POSTGRES( 
	p1_batchName varchar, p_indDate int, p_indDate_1 int, p2_batchName varchar
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
		delete from ers_batch where batch_id=p1_batchName AND effective_date=p_indDate ; 
		UPDATE ers_batch SET expiration_date=p_indDate WHERE batch_id=p2_batchName AND expiration_date is null;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_RESULT_POSTGRES( 
	p1_toArchive int, p2_outputPortfolio varchar, p3_version int, p4_outputPortfolioLike varchar, p5_datetimeInt int, p6_groupLevel int, p7_toCleanup int, 
	p8_outputPortfolio varchar, p9_version int, p10_datetimeInt int, p11_outputPortfolioLike varchar, p12_groupLevel int, p13_outputPortfolio varchar, 
	p14_version int, p15_datetimeInt int, p16_outputPortfolio varchar, p17_groupLevel int)
RETURNS INT  language plpgsql
AS $$
BEGIN
	IF p_toArchive=0 THEN
		BEGIN
			INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
			(SELECT r.value_date, p2_outputPortfolio, r.analysis, 0, r.is_packed, rr.element_id, rr.system_id, CASE group_level WHEN 1 THEN p3_version ELSE version END, rr.event_id, rr.seq_id, rr.factor1, rr.factor2, rr.factor3, rr.amount_ccy, rr.amount,rr.base_amount,rr.total_on, rr.packed_results
			FROM ers_result rr, ers_run r
			WHERE rr.run_id=r.run_id AND r.official=1
			AND r.portfolio like p4_outputPortfolioLike AND r.value_date=p5_datetimeInt AND rr.group_level=p6_groupLevel
			);
		END;
	ELSE
		BEGIN
			IF p7_toCleanup=0 THEN
				BEGIN
					UPDATE ers_result_history
					SET portfolio=p8_outputPortfolio, version=CASE group_level WHEN 1 THEN p9_version ELSE version END
					WHERE value_date=p10_datetimeInt
					AND portfolio like p11_outputPortfolioLike AND group_level=p12_groupLevel;
				END;
			ELSE 
				BEGIN
					INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
					SELECT value_date,p13_outputPortfolio,analysis,group_level,is_packed,element_id,system_id,CASE group_level WHEN 1 THEN p14_version ELSE version END,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results
					FROM ers_result_history
					WHERE value_date=p15_datetimeInt
					AND portfolio like p16_outputPortfolio AND group_level=p17_groupLevel;
				END; 
			END IF;
		END;
	END IF;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_MAKE_OFFICIAL_SINGLE_TRADE_POSTGRESQL( 
	p1_runId int, p2_runId int, p3_valueDate int, p4_analysis varchar, p5_portfolio varchar, p6_tradeId varchar, p7_runId int, 
	p8_tradeId varchar, p9_analysis varchar, p10_tradeId varchar, p11_portfolio varchar, p12_analysis varchar, p13_tradeId varchar, p14_portfolio varchar,
	p15_portfolio varchar, p16_runId int, p17_tradeId varchar)
RETURNS INT  language plpgsql
AS $$
DECLARE x int; x_valuedate int; x_runid int;
BEGIN
	SELECT count(*) into x FROM ers_result WHERE run_id=p1_runId;
	IF x>0 THEN
		BEGIN
			SELECT value_date into x_valuedate FROM ers_run WHERE run_id=p2_runId;
			IF x_valuedate > p3_valueDate THEN
				BEGIN
					SELECT run_id into x_runid FROM ers_run WHERE official=1 AND analysis=p4_analysis AND value_date=x_valuedate AND portfolio=p5_portfolio;
					IF (x_runid IS NOT NULL) THEN
						BEGIN
							DELETE FROM ers_result WHERE element_id=p6_tradeId AND run_id=x_runid;
							INSERT INTO ers_result (run_id,element_id,group_level,system_id ,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
							(SELECT x_runid,element_id,group_level,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results
            				FROM ers_result WHERE run_id=p7_runId AND element_id=p8_tradeId);
						END;
					END IF;
				END;
			ELSE
				BEGIN
					INSERT INTO ers_a_result_history (audit_date,value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
					SELECT current_timestamp,rh.value_date,rh.portfolio,rh.analysis,rh.group_level,rh.is_packed,rh.element_id,rh.system_id,rh.version,rh.event_id,rh.seq_id,rh.factor1,rh.factor2,rh.factor3,rh.amount_ccy,rh.amount,rh.base_amount,rh.total_on,rh.packed_results
					FROM ers_result_history rh WHERE rh.value_date =x_valuedate and rh.analysis=p9_analysis AND rh.element_id=p10_tradeId AND rh.portfolio=p11_portfolio;
					DELETE from ers_result_history WHERE value_date=x_valuedate and analysis=p12_analysis AND element_id=p13_tradeId AND portfolio=p14_portfolio;
            		INSERT into ers_result_history (value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
            		(SELECT r.value_date,p15_portfolio,r.analysis,rr.group_level,r.is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results
            		FROM ers_result rr,ers_run r where r.run_id=p16_runId and rr.run_id=r.run_id and rr.element_id=p17_tradeId);
				END;
			END IF;
		END;
	END IF;
RETURN 0;
END $$;
;


CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_RESULT_POSTGRES( 
	p1_datetimeInt int, p2_outputPortfolio varchar, p3_curAffectedAnalysesStr varchar, p4_toArchive int,
	p5_outputPortfolio varchar, p6_tempRequestId int, p7_datetimeInt int, p8_toCleanup int, p9_outputPortfolio varchar,
	p10_datetimeInt int, p11_tempRequestId int, p12_outputPortfolio varchar, p13_datetimeInt int, p14_tempRequestId int
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	DELETE FROM ers_result_history WHERE value_date=p1_datetimeInt AND portfolio=p2_outputPortfolio AND analysis in (p3_curAffectedAnalysesStr) ;
	IF p4_toArchive=0 THEN
		BEGIN
			INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
			(SELECT r.value_date, p5_outputPortfolio, r.analysis, 0, r.is_packed, rr.element_id, rr.system_id, rr.version, rr.event_id, rr.seq_id, rr.factor1, rr.factor2, rr.factor3, rr.amount_ccy, rr.amount,rr.base_amount,rr.total_on, rr.packed_results
			FROM ers_result rr, ers_run r
			WHERE rr.run_id=r.run_id AND r.official=1 AND rr.group_level=0
			AND rr.element_id in ( select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p6_tempRequestId ) AND r.value_date=p7_datetimeInt
			); 
		END;
	ELSE
		BEGIN
			IF p8_toCleanup=0 THEN
				BEGIN
					UPDATE ers_result_history
					SET portfolio=p9_outputPortfolio
					WHERE group_level=0 AND value_date=p10_datetimeInt
					AND element_id in ( select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p11_tempRequestId );
				END;
			ELSE
				BEGIN
					INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
					SELECT value_date,p12_outputPortfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results
					FROM ers_result_history
					WHERE group_level=0 AND value_date=p13_datetimeInt
					AND element_id in ( select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p14_tempRequestId);
				END;
			END IF;
		END;
	END IF;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_TRANSFER_RESULT_POSTGRES( 
	p1_datetimeInt int, p2_outputPortfolio varchar, p3_tempRequestId int, p4_analysesStr varchar,
	p5_toArchive int, p6_outputPortfolio varchar, p7_tempRequestId int, p8_datetimeInt int,
	p9_inputPortfolio varchar, p10_toCleanup int, p11_outputPortfolio varchar, p12_datetimeInt int,
	p13_inputPortfolio varchar, p14_tempRequestId int, p15_outputPortfolio varchar, p16_datetimeInt int,
	p17_inputPortfolio varchar, p18_tempRequestId int
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	DELETE FROM ers_result_history WHERE value_date=p1_datetimeInt AND portfolio=p2_outputPortfolio AND ((group_level=0 AND element_id in (select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p3_tempRequestId)) OR (group_level<>0)) AND analysis in (p4_analysesStr); 
	IF p5_toArchive=0 THEN 
	    BEGIN 
		INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results) 
		(SELECT r.value_date, p6_outputPortfolio, r.analysis, 0, r.is_packed, rr.element_id, rr.system_id, rr.version, rr.event_id, rr.seq_id, rr.factor1, rr.factor2, rr.factor3, rr.amount_ccy, rr.amount,rr.base_amount,rr.total_on, rr.packed_results 
		FROM ers_result rr, ers_run r 
		WHERE rr.run_id=r.run_id AND r.official=1 AND rr.group_level=0 
		AND rr.element_id in (select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p7_tempRequestId) AND r.value_date=p8_datetimeInt AND r.portfolio=p9_inputPortfolio); 
	    END; 
	ELSE 
	    BEGIN 
		IF p10_toCleanup=0 THEN 
		    BEGIN 
			UPDATE ers_result_history 
			SET portfolio=p11_outputPortfolio 
			WHERE group_level=0 AND value_date=p12_datetimeInt AND portfolio=p13_inputPortfolio AND element_id in (select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p14_tempRequestId); 
		    END; 
		ELSE 
		    BEGIN 
			INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results) 
			SELECT value_date,p15_outputPortfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results 
			FROM ers_result_history 
			WHERE group_level=0 AND value_date=p16_datetimeInt AND portfolio=p17_inputPortfolio AND element_id in (select ers_tempid_table.ref_id_str from ers_tempid_table where request_id = p18_tempRequestId); 
		    END; 
		END IF; 
	    END; 
	END IF;
RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION market_risk_S_MAKE_OFFICIAL_POSTGRESQL( 
	p1_runId bigint, p2_runId bigint, p3_valueDate int, p4_portfolio varchar, p5_analysis varchar,
	p6_runId bigint, p7_portfolio varchar, p8_analysis varchar, p9_runId bigint, p10_portfolio varchar,
	p11_analysis varchar, p12_portfolio varchar, p13_analysis varchar, p14_runId bigint, p15_runId bigint,
	p16_runId bigint, p17_portfolio varchar, p18_analysis varchar, p19_runId_1 bigint
) 
RETURNS INT  language plpgsql
AS $$
declare x int; x_valuedate int;
BEGIN			 
	SELECT count(*) into x FROM ers_run WHERE run_id=p1_runId and official<>1;
	IF x > 0 THEN 
		BEGIN 
			SELECT value_date into x_valuedate FROM ers_run WHERE run_id=p2_runId; 
		    	IF x_valuedate >= p3_valueDate THEN 
		    		BEGIN 
		    			DELETE FROM ers_run WHERE portfolio=p4_portfolio AND analysis=p5_analysis AND value_date=x_valuedate AND official=1; 
		    			UPDATE ers_run SET official=1 WHERE run_id=p6_runId; 
				END; 
			ELSE 
				BEGIN 
					DELETE FROM ers_run_history WHERE portfolio=p7_portfolio AND analysis=p8_analysis AND value_date=x_valuedate AND official=1; 
					INSERT INTO ers_run_history (analysis,portfolio,official,is_live,group_level,is_packed,value_date,base_ccy,user_name,last_updated,archived,run_id) 
					SELECT analysis,portfolio,1,is_live,group_level,is_packed,value_date,base_ccy,user_name,last_updated,(select sysdate from dual),run_id FROM ers_run WHERE run_id=p9_runId; 
					INSERT INTO ers_a_result_history (audit_date,value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results) 
					SELECT (select sysdate from dual),rh.value_date,rh.portfolio,rh.analysis,rh.group_level,rh.is_packed,rh.element_id,rh.system_id,rh.version,rh.event_id,rh.seq_id,rh.factor1,rh.factor2,rh.factor3,rh.amount_ccy,rh.amount,rh.base_amount,rh.total_on,rh.packed_results 
					FROM ers_result_history rh WHERE rh.value_date=x_valuedate AND rh.portfolio=p10_portfolio AND rh.analysis=p11_analysis;
					DELETE FROM ers_result_history WHERE value_date=x_valuedate AND portfolio=p12_portfolio AND analysis=p13_analysis; 
					INSERT INTO ers_result_history (value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results) 
					SELECT r.value_date,r.portfolio,r.analysis,rr.group_level,r.is_packed,rr.element_id,rr.system_id,rr.version,rr.event_id,rr.seq_id,rr.factor1,rr.factor2,rr.factor3,rr.amount_ccy,rr.amount,rr.base_amount,rr.total_on,rr.packed_results 
					FROM ers_result rr,ers_run r WHERE r.run_id=rr.run_id AND r.run_id=p14_runId; 
					DELETE FROM ers_run WHERE run_id=p15_runId; 
					DELETE FROM ers_result WHERE run_id=p16_runId; 
				END; 
			END IF;
			DELETE FROM ers_run_param WHERE portfolio=p17_portfolio AND analysis=p18_analysis AND value_date=x_valuedate AND official=1; 
			UPDATE ers_run_param SET official=1 WHERE official=p19_runId_1; 
		END;
	END IF;
RETURN 0;
END $$;
;



CREATE OR REPLACE FUNCTION market_risk_S_INSERTUPDATE_RUNINFO_POSTGRES( 
	p1_isNewId int, p2_base_ccy varchar, p3_runId int, p4_runId int, p5_analysisName varchar,
	p6_outputPortfolio varchar, p7_datetimeInt int, p8_base_ccy varchar, p9_user_name varchar, p10_runId int,
	p11_analysisName varchar, p12_outputPortfolio varchar, p13_paramInfo varchar, p14_datetimeInt int, p15_runId int,
	p16_value_time timestamp, p17_analysisName varchar, p18_outputPortfolio varchar, p19_datetimeInt int, p20_paramInfo varchar, p21_paramInfo int,
	p22_paramInfo int, p23_paramInfo int, p24_analysisName varchar, p25_outputPortfolio varchar, p26_datetimeInt int, p27_analysisName varchar,
	p28_outputPortfolio varchar, p29_datetimeInt int, p30_paramInfo varchar, p31_paramInfo varchar, p32_paramInfo int,
	p33_paramInfo int, p34_paramInfo int, p35_runId int, p36_msg varchar
) 
RETURNS INT  language plpgsql
AS $$
	DECLARE auditdate timestamp; x int;
BEGIN
	SELECT current_timestamp INTO auditdate;
	IF p1_isNewId=0 THEN
		BEGIN
			UPDATE ers_run_history
			SET base_ccy=p2_base_ccy, last_updated=auditdate, archived=auditdate
			WHERE run_id=p3_runId;

			UPDATE ers_job_exec
			SET batch_id='TransferHierarchy',  exec_status=100, end_time=auditdate, submit_time=auditdate, comments='Completed on Transfer'
			WHERE run_id=p4_runId;
		END;
	ELSE
		BEGIN
			INSERT INTO ers_run_history (analysis,portfolio,official,group_level,is_live,is_packed,value_date,base_ccy,user_name,last_updated,archived,run_id)
			VALUES(p5_analysisName, p6_outputPortfolio, 1, 0, 0, 0, p7_datetimeInt, p8_base_ccy, p9_user_name, auditdate, auditdate, p10_runId);

			INSERT INTO ers_job_exec (task_id,event_src,batch_id,analysis,portfolio,param_set,value_date,run_id,exec_time,exec_status,val_time,end_time,comments,user_name,submit_time)
			VALUES (0, -1, 'TransferHierarchy', p11_analysisName, p12_outputPortfolio, p13_paramInfo, p14_datetimeInt, p15_runId, auditdate,100, p16_value_time, auditdate, 'Completed on Transfer', '', auditdate);
		END;
	END IF;

	SELECT count(*) into x FROM ers_run_param WHERE analysis=p17_analysisName  AND portfolio=p18_outputPortfolio AND value_date=p19_datetimeInt AND official=1;

	IF x>0 THEN
		BEGIN
			UPDATE ers_run_param SET pricing_env=p20_paramInfo, trade_explode=p21_paramInfo, asofdate=p22_paramInfo, create_drilldown_results=p23_paramInfo
			WHERE analysis=p24_analysisName AND portfolio=p25_outputPortfolio AND value_date=p26_datetimeInt AND official=1;
		END;
	ELSE
		BEGIN
			INSERT INTO ers_run_param(analysis, portfolio, value_date, param_set, pricing_env, value_time, official, trade_explode, asofdate, create_drilldown_results)
			VALUES(p27_analysisName, p28_outputPortfolio, p29_datetimeInt, p30_paramInfo, p31_paramInfo, p32_paramInfo, 1, p33_paramInfo, p34_paramInfo);
		END;
	END IF;

	INSERT INTO ers_log(run_id,calc_id,msg,thread,last_updated,msglevel,msgcategory,isexception,msgtime,exceptionmsg) VALUES(p35_runId, '', p36_msg, '-1', auditdate, 'INFO', 'ERS', 0, auditdate, '');
RETURN 0;
END; $$
;

CREATE OR REPLACE FUNCTION market_risk_S_CLEAN_INPUTRESULT_POSTGRES( 
	p1_toArchive int, p2_datetime int,  p3_portfolios varchar[]
) 
RETURNS INT  language plpgsql
AS $$
DECLARE auditdate timestamp; x int;
BEGIN
IF p1_toArchive=0 THEN
	BEGIN 
		DELETE FROM ers_result
		WHERE run_id in (SELECT run_id FROM ers_run WHERE portfolio = ANY(p3_portfolios) AND value_date=p2_datetime AND official=1);

		DELETE FROM ers_run WHERE portfolio = ANY(p3_portfolios) AND value_date=p2_datetime AND official=1;
	END;
ELSE
	BEGIN
		DELETE FROM ers_run_history WHERE portfolio = ANY(p3_portfolios) AND value_date=p2_datetime AND official=1;
		DELETE FROM ers_result_history WHERE portfolio = ANY(p3_portfolios) AND value_date=p2_datetime;
	END;
END IF;
DELETE FROM ers_run_param WHERE portfolio = ANY(p3_portfolios) AND value_date=p2_datetime AND official=1;

RETURN 0;
END; $$
;

CREATE OR REPLACE FUNCTION market_risk_S_INSERTUPDATE_RUNINFO_TODAY_POSTGRES( 
	p1_isNewId int, p2_base_ccy varchar, p3_runId int, p4_runId int, p5_analysisName varchar,
	p6_outputPortfolio varchar, p7_datetimeInt int, p8_base_ccy varchar, p9_user_name varchar, p10_runId int,
	p11_analysisName varchar, p12_outputPortfolio varchar, p13_paramInfo varchar, p14_datetimeInt int, p15_runId int,
	p16_value_time timestamp, p17_analysisName varchar, p18_outputPortfolio varchar, p19_datetimeInt int, p20_paramInfo varchar, p21_paramInfo int,
	p22_paramInfo int, p23_paramInfo int, p24_analysisName varchar, p25_outputPortfolio varchar, p26_datetimeInt int, p27_analysisName varchar,
	p28_outputPortfolio varchar, p29_datetimeInt int, p30_paramInfo varchar, p31_paramInfo varchar, p32_paramInfo int,
	p33_paramInfo int, p34_paramInfo int, p35_runId int, p36_msg varchar
) 
RETURNS INT  language plpgsql
AS $$
	DECLARE auditdate timestamp; x int;
BEGIN
	SELECT CURRENT_TIMESTAMP INTO auditdate;

 	IF p1_isNewId=0 THEN
		BEGIN
			UPDATE ers_run SET base_ccy=p2_base_ccy, last_updated=auditdate WHERE run_id=p3_runId;
			UPDATE ers_job_exec SET batch_id='TransferHierarchy',  exec_status=100, end_time=auditdate, submit_time=auditdate, comments='Completed on Transfer' WHERE run_id=p4_runId;
		 END;
	ELSE
		BEGIN
			INSERT INTO ers_run (analysis,portfolio,official,group_level,is_live,is_packed,value_date,base_ccy,user_name,last_updated,run_id)
			VALUES(p5_analysisName, p6_outputPortfolio, 1, 0, 0, 0, p7_datetimeInt, p8_base_ccy, p9_user_name, auditdate, p10_runId);

			INSERT INTO ers_job_exec (task_id,event_src,batch_id,analysis,portfolio,param_set,value_date,run_id,exec_time,exec_status,val_time,end_time,comments,user_name,submit_time)
			VALUES (0, -1, 'TransferHierarchy', p11_analysisName, p12_outputPortfolio, p13_paramInfo, p14_datetimeInt, p15_runId, auditdate,100, p16_value_time, auditdate, 'Completed on Transfer', '', auditdate);
		END;
	END IF;

	SELECT count(*) into x FROM ers_run_param WHERE analysis=p17_analysisName AND portfolio=p18_outputPortfolio AND value_date=p19_datetimeInt AND official=1;

	IF x>0 THEN
		BEGIN
			UPDATE ers_run_param SET pricing_env=p20_paramInfo, trade_explode=p21_paramInfo, asofdate=p22_paramInfo, create_drilldown_results=p23_paramInfo
			WHERE analysis=p24_analysisName AND portfolio=p25_outputPortfolio AND value_date=p26_datetimeInt AND official=1;
		END;
	ELSE
		BEGIN
			INSERT INTO ers_run_param(analysis, portfolio, value_date, param_set, pricing_env, value_time, official, trade_explode, asofdate, create_drilldown_results)
			VALUES(p27_analysisName, p28_outputPortfolio, p29_datetimeInt, p30_paramInfo, p31_paramInfo, p32_paramInfo, 1, p33_paramInfo, p34_paramInfo);
		END;
	END IF;

	INSERT INTO ers_log(run_id,calc_id,msg,thread,last_updated,msglevel,msgcategory,isexception,msgtime,exceptionmsg) VALUES( p35_runId, '', p36_msg, '-1', auditdate, 'INFO', 'ERS', 0, auditdate, '');
	RETURN 0;
END; $$
;


CREATE OR REPLACE FUNCTION market_riskS_TRANSFER_SAME_TODAY_POSTGRES( 
	p1_analysis varchar[], p2_datetime int,  p3_portfolios varchar[], p4_portfolioCopyBV varchar[]
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	DELETE FROM ers_result 
	WHERE run_id IN (
		SELECT run_id FROM ers_run
		WHERE portfolio = ANY (p3_portfolios)
		AND analysis = ANY (p1_analysis)
		AND value_date= p2_datetime AND official=1);

	DELETE FROM ers_run 
	WHERE portfolio = ANY (p3_portfolios)
	AND analysis = ANY (p1_analysis)
	AND value_date=p2_datetime AND official=1;
	
	UPDATE ers_run 
	SET portfolio=portfolio || '_COPY'
	WHERE portfolio = ANY (p4_portfolioCopyBV)
		AND analysis = ANY (p1_analysis)
		AND value_date=p2_datetime AND official=1;
		RETURN 0;
END; $$
;


CREATE OR REPLACE FUNCTION market_riskS_TRANSFER_SAME_POSTGRES( 
	p1_analysis varchar[], p2_datetime int,  p3_portfolios varchar[], p4_toCleanup int
) 
RETURNS INT  language plpgsql
AS $$
	DECLARE auditdate timestamp; x int;
BEGIN
	SELECT CURRENT_TIMESTAMP INTO auditdate;
	DELETE FROM ers_run_history
	WHERE portfolio = ANY(p3_portfolios)
	AND analysis = ANY (p1_analysis)
	AND value_date = p2_datetime;
	
	DELETE FROM ers_result_history
	WHERE portfolio = ANY (p3_portfolios)
		AND analysis = ANY ( p1_analysis)
		AND value_date = p2_datetime;

	INSERT INTO ers_result_history(value_date,portfolio,analysis,group_level,is_packed,element_id,system_id,version,event_id,seq_id,factor1,factor2,factor3,amount_ccy,amount,base_amount,total_on,packed_results)
	(SELECT p2_datetime, r.portfolio, r.analysis, rr.group_level, r.is_packed, rr.element_id, rr.system_id, rr.version,
		rr.event_id, rr.seq_id, rr.factor1, rr.factor2, rr.factor3, rr.amount_ccy, rr.amount,rr.base_amount,rr.total_on, rr.packed_results 
	FROM ers_result rr, ers_run r 
	WHERE rr.run_id=r.run_id AND r.official=1 
	AND r.value_date=p2_datetime AND r.portfolio = ANY(p1_analysis));

	INSERT INTO ers_run_history (analysis,portfolio,official,group_level,is_live,is_packed,value_date,base_ccy,user_name,last_updated,archived,run_id) 
	(SELECT analysis,portfolio,official,group_level,is_live,is_packed,value_date,base_ccy,user_name,last_updated,auditdate,run_id 
	FROM ers_run WHERE portfolio = ANY(p1_analysis) AND value_date=p2_datetime AND official=1);

	IF p4_toCleanup=1 THEN
	    BEGIN
		DELETE FROM ers_result
		WHERE run_id in (SELECT run_id FROM ers_run WHERE portfolio = ANY(p1_analysis) AND value_date=p2_datetime AND official=1);
		
		DELETE FROM ers_run WHERE portfolio = ANY(p1_analysis) AND value_date=p2_datetime AND official=1;
	    END;
	END IF;
	RETURN 0;
END; $$
;

CREATE OR REPLACE FUNCTION market_riskS_REMOVE_ANALYSES_POSTGRES( 
	p1_analysis varchar[], p2_analysis varchar[] 
) 
RETURNS INT  language plpgsql
AS $$
BEGIN
	UPDATE ers_analysis_configuration SET inuse=0 WHERE analysis = ANY(p1_analysis) AND inuse <> 2;
	DELETE FROM ers_analysis_configuration WHERE analysis = ANY(p2_analysis);
	DELETE FROM ers_an_param WHERE analysis = ANY(p2_analysis);
	RETURN 0;
END $$;
;

CREATE OR REPLACE FUNCTION equalsOrNull(factorA varchar, factorB varchar)
RETURNS BOOLEAN language plpgsql
AS $$
BEGIN
    IF factorA is null  and factorB is null THEN
        RETURN TRUE;
    END IF;
    
    IF factorA=factorB THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END $$
;
	
CREATE OR REPLACE FUNCTION audit_hierarchy_table(p1_hierarchyName varchar, p2_hierarchyType varchar, p3_version int)
RETURNS void language plpgsql
AS $$
BEGIN
	INSERT INTO ers_a_hierarchy_attribute (audit_date,hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type)
	SELECT now(),hierarchy_name,underlying_id,underlying_type,version,hierarchy_date,latest_version, hierarchy_type
	FROM ers_hierarchy_attribute WHERE hierarchy_name=p1_hierarchyName AND hierarchy_type=p2_hierarchyType AND version=p3_version; 
	
	INSERT INTO ers_a_hierarchy (audit_date,hierarchy_name,node_id,parent_id,node_name,node_data,node_key,version,node_type,node_action)
	SELECT now(),hierarchy_name,node_id,parent_id,node_name,node_data,node_key,version,node_type,node_action
	FROM ers_hierarchy WHERE hierarchy_name=p1_hierarchyName AND version=p3_version; 
	
	INSERT INTO ers_a_hierarchy_node_attribute (audit_date,hierarchy_name, version, node_id, attribute_name, attribute_value)
	SELECT now(),hierarchy_name, version, node_id, attribute_name, attribute_value
	FROM ers_hierarchy_node_attribute WHERE hierarchy_name=p1_hierarchyName AND version=p3_version; 
END $$;
;


create or replace function sf_ers_run_param(p_analysis varchar, p_portfolio varchar,p_value_date int , p_official bigint ,p_param_set varchar,p_pricing_env varchar,p_value_time varchar,p_trade_explode int ,p_asofdate int , p_create_drilldown_results int )
RETURNS INT  language plpgsql
AS $$
declare x int; 
begin 
select count(*) INTO x FROM ers_run_param WHERE analysis=p_analysis AND portfolio=p_portfolio AND value_date= p_value_date AND official=p_official;  
IF x>0 THEN 
UPDATE ers_run_param SET param_set=p_param_set,pricing_env=p_pricing_env,value_time=p_value_time  WHERE analysis=p_analysis AND portfolio=p_portfolio AND value_date=p_value_date AND official=p_official; 
ELSE 
INSERT INTO ers_run_param (analysis,portfolio,value_date,param_set,pricing_env,value_time,official,trade_explode,asofdate,create_drilldown_results) 
VALUES (p_analysis,p_portfolio,p_value_date,p_param_set,p_pricing_env,p_value_time,p_official,p_trade_explode,p_asofdate,p_create_drilldown_results); 
END IF;
RETURN 0;
END; 
$$;
;
create or replace function sf_ers_gui_config(p_config_name varchar , p_attribute_name varchar, p_attribute_value varchar)
RETURNS INT  language plpgsql
AS $$
declare x int; 
begin 
	DELETE FROM ers_gui_configuration WHERE config_name=p_config_name and attribute_name=p_attribute_name; 
	INSERT INTO ers_gui_configuration(config_name, attribute_name, attribute_value) VALUES (p_config_name, p_attribute_name ,p_attribute_value ); 
	return 0;
END;
$$;
;