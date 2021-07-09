DECLARE @old_supervisor_id int,
		@new_supervisor_id int,
		@supervisor_code nvarchar(10)

SET @new_supervisor_id = 1
SET @supervisor_code = 'CFTC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 2
SET @supervisor_code = 'SEC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 3
SET @supervisor_code = 'ESMA'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 4
SET @supervisor_code = 'CA_QC_AMF'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 5
SET @supervisor_code = 'CA_ON_OSC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 6
SET @supervisor_code = 'CA_MB_MSC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 7
SET @supervisor_code = 'CA_AB_ASC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 8
SET @supervisor_code = 'CA_BC_BCSC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 9
SET @supervisor_code = 'CA_NB_FCSC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 10
SET @supervisor_code = 'CA_NL_DSS'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 11
SET @supervisor_code = 'CA_NS_NSSC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 12
SET @supervisor_code = 'CA_NT_NTSO'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 13
SET @supervisor_code = 'CA_NU_NSO'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 14
SET @supervisor_code = 'CA_PEI_OSS'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 15
SET @supervisor_code = 'CA_SK_FCAA'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 16
SET @supervisor_code = 'CA_YT_OSS'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 17
SET @supervisor_code = 'MAS'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
          /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 18
SET @supervisor_code = 'HKMA'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id  and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
    /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END

SET @new_supervisor_id = 19
SET @supervisor_code = 'ASIC'
IF EXISTS (SELECT 1 FROM tr_supervisor WHERE supervisor_id != @new_supervisor_id  and supervisor_code = @supervisor_code)
BEGIN
	SELECT @old_supervisor_id = supervisor_id 
		FROM tr_supervisor
		WHERE supervisor_code = @supervisor_code and supervisor_id != @new_supervisor_id
		
    INSERT INTO tr_supervisor (supervisor_id, supervisor_code, regulation_id, enabled)
    SELECT @new_supervisor_id, 'TMP_SUP', regulation_id, enabled
	FROM tr_supervisor
	WHERE supervisor_id != @new_supervisor_id and supervisor_code = @supervisor_code
          
    /* Step 1: update each table referencing tr_supervior */
    UPDATE tr_submission_state      SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_submission_state_hist SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime         SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
    UPDATE tr_report_regime_hist    SET supervisor_id = @new_supervisor_id WHERE supervisor_id = @old_supervisor_id
              
    /* Step 2: delete the old supervisor_id */
    DELETE tr_supervisor WHERE supervisor_id = @old_supervisor_id
              
    /* Step 3: update the supervisor_code */
    UPDATE tr_supervisor SET supervisor_code = @supervisor_code WHERE supervisor_id = @new_supervisor_id
		  
	COMMIT
END
go
