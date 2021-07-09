CREATE TABLE correlation_cube (
	cube_id           _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	cube_name		  _Name NOT NULL,
	cube_instance	  _MarketDataInstanceCode,
	user_name         _Name,
	comments          _Comment,
	first_axis_type   _Name,
	second_axis_type  _Name,
	time_zone         _TimeZone NULL,
	corr_type         VARCHAR(32) NULL,
	blob_data         _LongBinary NULL,
	is_simple         _Boolean,
	generator_name	  _LongName NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime)
	)
go

CREATE NONCLUSTERED INDEX idx_cube_axis on correlation_cube (cube_datetime,first_axis_type,second_axis_type)
go

CREATE NONCLUSTERED INDEX idx_cube_axis2 on correlation_cube (first_axis_type,second_axis_type)
go

CREATE TABLE corr_cube_hist (
	cube_id           _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	cube_name		  _Name NOT NULL,
	cube_instance	  _MarketDataInstanceCode,
	user_name         _Name,
	comments          _Comment,
	first_axis_type   _Name,
	second_axis_type  _Name,
	time_zone         _TimeZone NULL,
	corr_type         VARCHAR(32) NULL,
	blob_data         _LongBinary NULL,
	is_simple         _Boolean ,
	generator_name	  _LongName NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime)
	)
go

CREATE TABLE cube_first_axis (
	cube_id		      _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	axis_id		      _Id NOT NULL,
	var_name	      _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_first_ax_hist (
	cube_id		      _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	axis_id		      _Id NOT NULL,
	var_name	      _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_second_axis (
	cube_id		      _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	axis_id		      _Id NOT NULL,
	var_name	      _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_secnd_ax_hist (
	cube_id		      _Id NOT NULL,
	cube_datetime 	  _Datetime NOT NULL,
	axis_id		      _Id NOT NULL,
	var_name	      _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, axis_id)
	)
go

CREATE TABLE cube_first_tenor (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	offset			 int NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_first_ten_hist (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	offset			 int NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_second_tenor (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	offset			 int NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE cube_secnd_ten_hist (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	offset			 int NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, offset)
	)
go

CREATE TABLE corr_cube_strike (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
    strike           _Amount NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, strike)
)
go

CREATE TABLE corr_cube_strk_hist (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
    strike           _Amount NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, strike)
)
go

CREATE TABLE corr_cube_data (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	first_index		 _Id NOT NULL,
	second_index	 _Id NOT NULL,
	first_offset     _Id NOT NULL,
	second_offset    _Id NOT NULL,
	strike 		     _Amount NOT NULL,
	value            _Rate,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, first_index, second_index, first_offset, second_offset, strike)
)
go

CREATE TABLE corr_cube_data_hist (
	cube_id		     _Id NOT NULL,
	cube_datetime 	 _Datetime NOT NULL,
	first_index		 _Id NOT NULL,
	second_index	 _Id NOT NULL,
	first_offset     _Id NOT NULL,
	second_offset    _Id NOT NULL,
	strike 		     _Amount NOT NULL,
	value            _Rate,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime, first_index, second_index, first_offset, second_offset, strike)
	)
go


CREATE TABLE corr_cube_param (
	cube_id               _Id NOT NULL,
	cube_datetime         _Datetime NOT NULL,
	attribute_name        _Name NOT NULL,
	attribute_value       _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime,attribute_name)
	)
go

CREATE TABLE corr_cube_p_hist (
	cube_id               _Id NOT NULL,
	cube_datetime         _Datetime NOT NULL,
	attribute_name        _Name NOT NULL,
	attribute_value       _Name NOT NULL,
		CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED (cube_id, cube_datetime,attribute_name)
	)
go

