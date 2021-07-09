CREATE TABLE correlation_cube (
	cube_id           INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	cube_name		  VARCHAR(32) NOT NULL,
	cube_instance	  VARCHAR(16),
	user_name         VARCHAR(32),
	comments          VARCHAR(255),
	first_axis_type   VARCHAR(32),
	second_axis_type  VARCHAR(32),
	time_zone         VARCHAR(128) NULL,
	corr_type         VARCHAR(32) NULL,
	blob_data         BLOB NULL,
	is_simple         CHAR(1) NULL,
	generator_name	  VARCHAR(255) NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime)
	)
go

CREATE NONCLUSTERED INDEX idx_cube_axis on correlation_cube (cube_datetime,first_axis_type,second_axis_type)
go

CREATE NONCLUSTERED INDEX idx_cube_axis2 on correlation_cube (first_axis_type,second_axis_type)
go

CREATE TABLE corr_cube_hist (
	cube_id           INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	cube_name		  VARCHAR(32) NOT NULL,
	cube_instance	  VARCHAR(16),
	user_name         VARCHAR(32),
	comments          VARCHAR(255),
	first_axis_type   VARCHAR(32),
	second_axis_type  VARCHAR(32),
	time_zone         VARCHAR(128) NULL,
	corr_type         VARCHAR(32) NULL,
	blob_data         BLOB NULL,
	is_simple         CHAR(1) NULL ,
	generator_name	  VARCHAR(255) NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime)
	)
go

CREATE TABLE cube_first_axis (
	cube_id		      INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	axis_id		      INTEGER NOT NULL,
	var_name	      VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_first_ax_hist (
	cube_id		      INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	axis_id		      INTEGER NOT NULL,
	var_name	      VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_second_axis (
	cube_id		      INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	axis_id		      INTEGER NOT NULL,
	var_name	      VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_secnd_ax_hist (
	cube_id		      INTEGER NOT NULL,
	cube_datetime 	  TIMESTAMP NOT NULL,
	axis_id		      INTEGER NOT NULL,
	var_name	      VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_first_tenor (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	offset			 INTEGER NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_first_ten_hist (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	offset			 INTEGER NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_second_tenor (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	offset			 INTEGER NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_secnd_ten_hist (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	offset			 INTEGER NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE corr_cube_strike (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
    strike           FLOAT NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, strike)
)
go

CREATE TABLE corr_cube_strk_hist (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
    strike           FLOAT NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, strike)
)
go

CREATE TABLE corr_cube_data (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	first_index		 INTEGER NOT NULL,
	second_index	 INTEGER NOT NULL,
	first_offset     INTEGER NOT NULL,
	second_offset    INTEGER NOT NULL,
	strike 		     FLOAT NOT NULL,
	value            FLOAT,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, first_index, second_index, first_offset, second_offset, strike)
)
go

CREATE TABLE corr_cube_data_hist (
	cube_id		     INTEGER NOT NULL,
	cube_datetime 	 TIMESTAMP NOT NULL,
	first_index		 INTEGER NOT NULL,
	second_index	 INTEGER NOT NULL,
	first_offset     INTEGER NOT NULL,
	second_offset    INTEGER NOT NULL,
	strike 		     FLOAT NOT NULL,
	value            FLOAT,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, first_index, second_index, first_offset, second_offset, strike)
	)
go


CREATE TABLE corr_cube_param (
	cube_id               INTEGER NOT NULL,
	cube_datetime         TIMESTAMP NOT NULL,
	attribute_name        VARCHAR(32) NOT NULL,
	attribute_value       VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime,attribute_name)
	)
go

CREATE TABLE corr_cube_p_hist (
	cube_id               INTEGER NOT NULL,
	cube_datetime         TIMESTAMP NOT NULL,
	attribute_name        VARCHAR(32) NOT NULL,
	attribute_value       VARCHAR(32) NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime,attribute_name)
	)
go

