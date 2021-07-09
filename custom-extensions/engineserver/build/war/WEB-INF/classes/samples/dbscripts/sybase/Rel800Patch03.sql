
CREATE TABLE ers_batch
        (
        task_id		int 		NOT NULL,
        batch_id	varchar(32)    	NOT NULL,
        analysis    	varchar(32)	NOT NULL,
        target		varchar(255) 	NOT NULL,
        target_type	varchar(32)	NOT NULL,
        param_set	varchar(32)	NULL,
        pricing_env	varchar(32)	NOT NULL,
        is_complex	bit		NOT NULL,
        is_live		bit		NOT NULL,
        trade_explode	bit		NOT NULL,
        CONSTRAINT UNIQ_ers_batch UNIQUE (batch_id,analysis,target,param_set)       
    )
GO


grant INSERT,UPDATE,SELECT,DELETE on ers_batch to public
GO

CREATE TABLE ers_job_exec ( 
 	task_id		int		NOT NULL,
        analysis    	varchar(32)	NOT NULL,
        portfolio	varchar(255) 	NOT NULL,
        param_set	varchar(32)	NULL,
        value_date	int 		NULL,
 	run_id		int    		NULL,
	exec_time    	datetime 	NULL,
    	exec_status    	smallint 	NOT NULL,
    	val_time        datetime 	NULL,
    	end_time       	datetime	NULL,
	comments  	varchar(255) 	NULL,
        user_name	varchar(32)	NULL,
    	submit_time     datetime 	NOT NULL
)

GO

grant INSERT,UPDATE,SELECT,DELETE on ers_job_exec to public
GO


CREATE TABLE ers_scenario_rf_quotes
   (
	quote_date	int			NOT NULL,
        rf_id		int			NOT NULL,
        quote_name	varchar(255)		NOT NULL,
        quote_value	double precision	NOT NULL,
        is_interpolated bit			NOT NULL,        

        CONSTRAINT PK_ersscenariorfquotes PRIMARY KEY CLUSTERED (quote_date,rf_id)        
   )

GO

grant INSERT,UPDATE,SELECT,DELETE on ers_scenario_rf_quotes to public
GO

/****** Object:  Table dbo.ers_log    Script Date: 05/07/2006 12:00:00 ******/


CREATE TABLE ers_log
   (
		run_id					int					NOT NULL,
		calc_id					int					NULL,
		msgLevel				varchar(50)				NOT NULL,
		msgCategory				varchar(50)				NOT NULL,
		msg					varchar(255)				NOT NULL,
		isException				bit					NOT NULL,
		exceptionMsg				image					NULL,
		thread					varchar(50)				NOT NULL,
		msgTime					varchar(35)				NOT NULL,
		last_updated				datetime 				NOT NULL
    )    
GO

CREATE  INDEX IDX_ers_log ON ers_log(run_id, msgTime)
GO

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
		isException				bit					NOT NULL,
		exceptionMsg				image					NULL,
		thread					varchar(50)				NOT NULL,
		msgTime					varchar(35)				NOT NULL,
		last_updated				datetime				NOT NULL
    )    
GO

CREATE  INDEX IDX_ers_log_history ON ers_log_history(value_date, analysis)
GO

ALTER TABLE ers_hierarchy_attribute DROP base_ccy
GO

CREATE TABLE ers_scenario_pc_map
    (
        rf_index    	varchar(32)	NOT NULL,
        rf_ccy		char(3) 	NOT NULL,
        pc_item		varchar(255)	NOT NULL
)

GO

grant INSERT,UPDATE,SELECT,DELETE on ers_scenario_pc_map to public
GO

ALTER TABLE ers_run_param MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_run_history MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_run MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_result_history MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_job_exec MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_grouping MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_engine MODIFY portfolio varchar(255)
GO
ALTER TABLE ers_hierarchy MODIFY node_data varchar(255)
GO

ALTER TABLE ers_run_param ADD trade_explode bit default 0 NOT NULL
GO

ALTER TABLE ers_batch ADD trade_explode bit default 0 NOT NULL
GO

