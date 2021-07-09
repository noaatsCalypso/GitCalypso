CREATE OR REPLACE FUNCTION ers_S_OVERWRITE_HIERARCHY_POSTGRES(
	p1_hierarchy_name varchar, p1_version int, p2_hierarchy_name varchar, p2_version int, p3_hierarchy_name varchar, p3_version int, 
	p4_hierarchy_name varchar, p4_version int, p_hierarchy_date timestamp, p4_latest_version int, p_hierarchy_type varchar, p_latest_version int, p_hierarchy_name varchar, p_hierarachy_type varchar) 
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

CREATE OR REPLACE FUNCTION ers_S_OVERWRITE_HIERARCHY_ATTRIBUTE(
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
;
	
CREATE OR REPLACE FUNCTION ers_S_INSERT_HIERARCHY_ATTRIBUTE(
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


CREATE OR REPLACE FUNCTION ers_INSERT_COMPLETED_POST(
	p1_runId bigint, p2_taskId bigint, p3_analysis varchar, p4_portfolio varchar, p5_paramSet varchar,
	p6_valueDate int, p7_runId bigint, p8_execTime timestamp, p9_execStatus int, p10_execTime timestamp,
	p11_userName varchar, p12_submit_time timestamp, p13_eventSrc bigint, p14_batchId varchar)
RETURNS INT  language plpgsql
AS $$
BEGIN
	DELETE FROM ers_job_exec WHERE run_id=p1_runId;
	INSERT INTO ers_job_exec (task_id,analysis,portfolio,param_set,value_date,run_id,exec_time,exec_status,end_time,user_name,submit_time,event_src,batch_id) 
	VALUES (p2_taskId,p3_analysis,p4_portfolio,p5_paramSet,p6_valueDate,p7_runId,p8_execTime,p9_execStatus,p10_execTime,p11_userName,p12_submit_time,p13_eventSrc,p14_batchId);	
RETURN 0;
END $$;
;



