BEGIN
	EXECUTE ('sp_rename collateral_config, collateral_config_back16')
	EXECUTE ('create table collateral_config (
			mcc_id  number not null ,
			account_id  number  null ,
			agency_list   varchar2(255) null  ,
			book_list   varchar2(1024) null  ,
			clearing_member_id  number  null,
			concentration_position   varchar2(16) null  ,
			concentration_side   varchar2(8) null  ,
			contract_direction   varchar2(32) null  ,
			contract_dispute_tol_amount float default 0  not null ,
			contract_dispute_tol_perc_b  number default 0 not null,
			dispute_tol_perc_basis   varchar2(24) default ''GLOBAL_REQUIRED_MARGIN'' not null ,
			accept_on_po_favor_b  number default  0 not null,
			credit_multiplier   float null ,
			exclude_from_optimizer  number default 0 not null,
			exposure_type_list  varchar2(2048) null  ,
			is_initial_margin  number default 0 not null,
			le_ia_rating_direction   varchar2(32) null  ,
			le_mta_currency    varchar2(3) null  ,
			le_rating_config  number  null ,
			le_rating_hier_config  number  null ,
			le_thres_currency    varchar2(3) null  ,
			notes   varchar2(1024) null  ,
			po_ia_rating_direction   varchar2(32) null  ,
			po_mta_currency    varchar2(3) null  ,
			po_rating_config  number  null ,
			po_rating_hier_config  number  null ,
			po_thres_currency    varchar2(3) null  ,
			position_date_type  varchar2(24) default ''POSITION_DATE_DEFAULT'' null,
			position_type   varchar2(32) default ''THEORETICAL'' null  ,
			rounding_before_mta_b  number default 1 not null,
			secured_party    varchar2(128) null ,
			substitution_context  varchar2(24) default ''Pay Margin'' null ,
			substitution_level  varchar2(48) default ''Inherited from Optimization Configuration'' not null,
			substitution_type  varchar2(24) default ''Never'' null,
			wf_product   varchar2(32) null  ,
			wf_subtype   varchar2(32) null  ,
			perimeter_type   varchar2(32) null  ,
			po_ia_direction   varchar2(8) null  ,
			le_ia_direction   varchar2(8) null  ,
			settlement_offset  number  null ,
			settlement_holidays    varchar2(1024) null  ,
			reset_allocations_type   varchar2(32) default ''If Not Fully Allocated'' not null ,
			interest_type  varchar2(16) default ''Contract''  null,
			intraday_pricing_env_name   varchar2(32) null  ,
			collateral_group  varchar2(32) null ,
			triparty_b  number default  0 not null,
			po_mta_perc_basis   varchar2(32) null  ,
			po_mta_value_basis  varchar2(32) default ''Net Value'' not null,
			le_mta_perc_basis   varchar2(32) null  ,
			le_mta_value_basis varchar2(32) default ''Net Value'' not null ,
			po_thresh_perc_basis   varchar2(32) null  ,
			po_thresh_value_basis  varchar2(32) default ''Net Value'' not null ,
			le_thresh_perc_basis   varchar2(32) null  ,
			le_thresh_value_basis  varchar2(32) default ''Net Value'' not null,
			config_adhoc_details_id  number default  0 not null ,
			val_time_offset_id  number default  0 not null ,
			holidays   varchar2(1024) null  ,
			ignore_mta_on_return_b  number default  0 not null ,
			ignore_mta_on_return_thres_b  number default  0 not null,
			quote_offset   number default 0 null ,
			val_time_seconds  number default  0 not null,
			notification_time_seconds  number default  0 not null ,
			substitution_time_seconds  number default  0 not null,
			is_independent_wf  number default  1 not null ,
			is_distribute_to_exp  number default  0 not null ,
			is_portfolio_distrib  number default  0 not null ,
			is_direction_based_inc  number default  0 not null ,
			book_cash_in  number  null ,
			book_cash_out  number  null ,
			book_sec_in  number  null ,
			book_sec_out  number  null ,
			inv_source_book_for  varchar2(100) null,
			simulation_pricing_env_name   varchar2(32) null  ,
			mandatory_agencies  number default  0 not null ,
			collateral_rehypothecation   varchar2(8) null  ,
			accept_rehypothecated   varchar2(8) null  ,
			term_settle_ccy_list   varchar2(1024) null  ,
			le_term_ccy_list   varchar2(1024) null  ,
			le_haircut_name   varchar2(32) null  ,
			po_haircut_name   varchar2(32) null  ,
			le_is_rehypothecable  number  null ,
			le_accept_rehyp   varchar2(8) null  ,
			le_collateral_rehyp   varchar2(8) null  ,
			is_asym_elig_currencies  number  default 1 null ,
			is_asym_elig_filters  number   default 1 null ,
			is_asym_elig_exclusion  number   default 1 null ,
			acadia_b  number  default 0 null ,
			is_sweep_exp_group  number  default 0 null ,
			dispute_aging_start  number  default 0 not null ,
			track_as_dispute  number  default 0 null,
			undisputed_tol_amt  float default 0 null,
			accept_undisputed_amt  number default 0  null ,
			undisputed_percentage  number default 0 null ,
			undisputed_perc_dispute_b   varchar2(24) default ''GLOBAL_REQUIRED_MARGIN'' not null )')
END
go
drop procedure check_and_create_table
go
CREATE PROCEDURE check_and_create_table as 
BEGIN
	DECLARE 
		@v_column_list varchar(2000),
		@v_insert_list varchar(2000),
		@v_select_list varchar(2000),
		@v_final_query varchar(4000),
		@next_column_name varchar(2000),
		@v_con_select_col varchar(2000),
		@v_con_select_list varchar(16384)   
	DECLARE 
		column_exists_cursor CURSOR FOR 

		select syscolumns.name from sysobjects, syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' 
		and exists (select syscolumns.name from sysobjects, syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config_back16')
		
OPEN  column_exists_cursor
                FETCH column_exists_cursor INTO @next_column_name
                while (@@sqlstatus = 0)
                BEGIN
						select CASE @next_column_name
									when 'contract_dispute_tol_amount' then isnull('contract_dispute_tol_amount', 0)
									when 'contract_dispute_tol_perc_b' then  isnull('contract_dispute_tol_perc_b', 0)
									when 'exclude_from_optimizer' then  isnull('exclude_from_optimizer', 0)
									when 'is_initial_margin' then  isnull('is_initial_margin', 0)
									when 'rounding_before_mta_b' then  isnull('rounding_before_mta_b', 1)
									when 'substitution_level' then  isnull('substitution_level', 'inherited from optimization configuration')
									else  @v_con_select_col
								end	
								
                                 select @v_column_list = @v_column_list || ', ' || @next_column_name
								 select @v_con_select_list = @v_con_select_list|| ', ' || @v_con_select_col               	

	select @v_column_list = substring(@v_column_list, 2, char_length(@v_column_list)-1)
	select @v_con_select_list = substring(@v_con_select_list, 2, char_length(@v_con_select_list)-1)
	select @v_insert_list     = 'insert into collateral_config (' || @v_column_list || ')'
	select @v_select_list     = 'select ' + @v_column_list + ' from collateral_config_back16'
	select @v_final_query     = @v_insert_list + ' ' + @v_select_list
	select @v_final_query
	fetch next column_exists_cursor into @next_column_name
	end
	close column_exists_cursor
deallocate cursor column_exists_cursor	
end
go
check_and_create_table
go