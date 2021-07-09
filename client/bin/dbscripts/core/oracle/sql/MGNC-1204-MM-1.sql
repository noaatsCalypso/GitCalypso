/* For Margin Calculator Migration to Calculation Set we will drop all the result and */
DECLARE
    vCount INTEGER;
BEGIN
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_result' and lower(C.CONSTRAINT_NAME) = 'fk_cm_result_calcsum';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_result drop constraint fk_cm_result_calcsum';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_result' and lower(C.CONSTRAINT_NAME) = 'fk_cm_result_account';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_result drop constraint fk_cm_result_account';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_result_node' and lower(C.CONSTRAINT_NAME) = 'fk_cm_result_node_tree';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_result_node drop constraint fk_cm_result_node_tree';
    END IF;
	SELECT count(a.table_name) INTO vCount FROM USER_CONS_COLUMNS  A, USER_CONSTRAINTS C where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME and lower(a.table_name) = 'cm_result_errors' and lower(C.CONSTRAINT_NAME) = 'fk_cm_result_errors_tree';
    IF (vCount = 1) THEN
        EXECUTE IMMEDIATE 'alter table cm_result_errors drop constraint fk_cm_result_errors_tree';
    END IF;
END;
/
truncate table cm_calculation_summary
;
truncate table cm_calculation_summary_hist
;
truncate table cm_result
;
truncate table cm_result_errors
;
truncate table cm_result_node
;
truncate table cm_result_hist
;
truncate table cm_result_errors_hist
;
truncate table cm_result_node_hist
;
