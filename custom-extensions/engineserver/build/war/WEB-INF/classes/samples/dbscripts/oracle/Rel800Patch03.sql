
CREATE TABLE ers_batch
        (
        task_id		int  	NOT NULL,
        batch_id	varchar(32)    	NOT NULL,
        analysis    	varchar(32)	NOT NULL,
        target		varchar(255) 	NOT NULL,
        target_type	varchar(32)	NOT NULL,
        param_set	varchar(32)	NULL,
        pricing_env	varchar(32)	NOT NULL,
        is_complex	CHAR(1)		NOT NULL,
        is_live		CHAR(1)		NOT NULL,
        trade_explode	CHAR(1)		NOT NULL,
        CONSTRAINT UNIQ_ers_batch UNIQUE (batch_id,analysis,target,param_set) USING INDEX TABLESPACE CALYPSOIDX      
    ) TABLESPACE CALYPSOSTATIC
;

CREATE TABLE ers_job_exec ( 

 	task_id		int		NOT NULL,
        analysis    	varchar(32)	NOT NULL,
        portfolio	varchar(255) 	NOT NULL,
        param_set	varchar(32)	NULL,
        value_date	int 		NULL,
 	run_id		int    		NULL,
	exec_time    	TIMESTAMP 	NULL,
    	exec_status    	smallint 	NOT NULL,
    	val_time        TIMESTAMP 	NULL,
    	end_time       	TIMESTAMP	NULL,
	comments  	varchar(255) 	NULL,
        user_name	varchar(32)	NULL,
    	submit_time     TIMESTAMP 	NOT NULL
)TABLESPACE CALYPSOACTIVE  
;

CREATE TABLE ers_scenario_rf_quotes
   (
	quote_date	int			NOT NULL,
        rf_id		int			NOT NULL,
        quote_name	varchar(255)		NOT NULL,
        quote_value	FLOAT			NOT NULL,
        is_interpolated CHAR(1)			NOT NULL,        
        CONSTRAINT PK_ersscenariorfquotes PRIMARY KEY (quote_date,rf_id) USING INDEX TABLESPACE CALYPSOIDX
   ) TABLESPACE CALYPSOACTIVE
;



CREATE TABLE ers_log
   (
		run_id					int					NOT NULL,
		calc_id					int					NULL,
		msgLevel				varchar(50)				NOT NULL,
		msgCategory				varchar(50)				NOT NULL,
		msg					varchar(255)				NOT NULL,
		isException				CHAR(1)                                 NOT NULL,
		exceptionMsg				BLOB					NULL,
		thread					varchar(50)				NOT NULL,
		msgTime					varchar(35)				NOT NULL,
		last_updated				TIMESTAMP 				NOT NULL
 
    ) TABLESPACE CALYPSOACTIVE
;

CREATE  INDEX IDX_ers_log ON ers_log(run_id, msgTime) TABLESPACE CALYPSOIDX
;

CREATE TABLE ers_log_history
   (
		analysis				varchar(32)				NOT NULL,
		portfolio				varchar(255)				NOT NULL,
		official				int					NOT NULL,
		value_date				int					NOT NULL,
		group_level				int					NOT NULL,
		run_id					int					NOT NULL,
		calc_id					int					NULL,
		msgLevel				varchar(50)				NOT NULL,
		msgCategory				varchar(50)				NOT NULL,
		msg					varchar(255)				NOT NULL,
		isException				CHAR(1)					NOT NULL,
		exceptionMsg				BLOB					NULL,
		thread					varchar(50)				NOT NULL,
		msgTime					varchar(35)				NOT NULL,
        	last_updated				TIMESTAMP 				NOT NULL
    ) TABLESPACE CALYPSOACTIVE
;

CREATE INDEX IDX_ers_log_history ON ers_log_history(value_date, analysis) TABLESPACE CALYPSOIDX
;

ALTER TABLE ers_hierarchy_attribute DROP COLUMN base_ccy
;

CREATE TABLE ers_scenario_pc_map
    (
        rf_index    	varchar(32)	NOT NULL,
        rf_ccy		char(3) 	NOT NULL,
        pc_item		varchar(255)	NOT NULL
    )TABLESPACE CALYPSOSTATIC  
;

ALTER TABLE ers_run_param MODIFY portfolio varchar(255)
;
ALTER TABLE ers_run_history MODIFY portfolio varchar(255)
;
ALTER TABLE ers_run MODIFY portfolio varchar(255)
;
ALTER TABLE ers_result_history MODIFY portfolio varchar(255)
;
ALTER TABLE ers_job_exec MODIFY portfolio varchar(255)
;
ALTER TABLE ers_grouping MODIFY portfolio varchar(255)
;
ALTER TABLE ers_engine MODIFY portfolio varchar(255)
;
ALTER TABLE ers_hierarchy MODIFY node_data varchar(255)
;

ALTER TABLE ers_run_param ADD trade_explode CHAR(1) DEFAULT 0 NOT NULL
;
ALTER TABLE ers_batch ADD trade_explode CHAR(1) DEFAULT 0 NOT NULL
;
