CREATE OR REPLACE PROCEDURE update_dtcc_supervisor_id (p_supervisor_id IN int, p_supervisor_code IN varchar)
AS
BEGIN
	DECLARE p_supervisor_tmp_code varchar(10):= 'TMP_SUP';
        p_old_supervisor_id int;
		p_count int;
	BEGIN
		SELECT count(*) 
			INTO p_count 
			FROM tr_supervisor
			WHERE supervisor_code = p_supervisor_code and supervisor_id != p_supervisor_id;
			  
		IF p_count > 0 THEN
			SELECT supervisor_id 
			INTO p_old_supervisor_id 
			FROM tr_supervisor
			WHERE supervisor_code = p_supervisor_code and supervisor_id != p_supervisor_id;
			
			BEGIN
				INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
				SELECT p_supervisor_id, p_supervisor_tmp_code, regulation_id, enabled
				FROM tr_supervisor where supervisor_id = p_old_supervisor_id;
				  
				/* Step 1: update each table referencing tr_supervior */
				UPDATE tr_submission_state      SET supervisor_id = p_supervisor_id WHERE supervisor_id = p_old_supervisor_id;
				UPDATE tr_submission_state_hist SET supervisor_id = p_supervisor_id WHERE supervisor_id = p_old_supervisor_id;
				UPDATE tr_report_regime         SET supervisor_id = p_supervisor_id WHERE supervisor_id = p_old_supervisor_id;
				UPDATE tr_report_regime_hist    SET supervisor_id = p_supervisor_id WHERE supervisor_id = p_old_supervisor_id;
				  
				/* Step 2: delete the old supervisor_id */
				DELETE tr_supervisor WHERE supervisor_id = p_old_supervisor_id;
					
				/* Step 3: update the supervisor_code */
				UPDATE tr_supervisor SET supervisor_code = p_supervisor_code WHERE supervisor_id = p_supervisor_id;
				
				COMMIT;
			END;
		END IF;
	END;
END;
