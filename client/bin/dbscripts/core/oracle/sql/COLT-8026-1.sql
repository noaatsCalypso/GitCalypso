DECLARE
	v_column_exists number := 0;
BEGIN
	select count(*) into v_column_exists from user_tab_cols where column_name = upper ('book_cash_in') and table_name = upper('collateral_config');
	if(v_column_exists < 1) then
		execute immediate 'ALTER TABLE collateral_config ADD book_cash_in NUMBER NULL';
	end if;
	
	select count(*) into v_column_exists from user_tab_cols where column_name = upper('book_cash_out') and table_name = upper('collateral_config');
	if(v_column_exists < 1) then
		execute immediate 'ALTER TABLE collateral_config ADD book_cash_out NUMBER NULL';
	end if;
	
	select count(*) into v_column_exists from user_tab_cols where column_name = upper ('book_sec_in') and table_name = upper('collateral_config');
	if(v_column_exists < 1) then
		execute immediate 'ALTER TABLE collateral_config ADD book_sec_in NUMBER NULL';
	end if;
	
	select count(*) into v_column_exists from user_tab_cols where column_name = upper('book_sec_out') and table_name = upper('collateral_config');
	if(v_column_exists < 1) then
		execute immediate 'ALTER TABLE collateral_config ADD book_sec_out NUMBER NULL';
	end if;
	
	select count(*) into v_column_exists from user_tab_cols where column_name = upper('inv_source_book_for') and table_name = upper('collateral_config');
	if(v_column_exists < 1) then
		execute immediate 'ALTER TABLE collateral_config ADD inv_source_book_for VARCHAR2(100) NULL';
	end if;

	execute immediate 'UPDATE collateral_config SET inv_source_book_for = ''None'' WHERE book_cash_in IS NULL AND book_cash_out IS NULL AND book_sec_in IS NULL AND book_cash_out IS NULL';

	execute immediate 'UPDATE (SELECT cc.book_cash_in cash_in, cc.book_cash_out cash_out, cc.book_sec_in sec_in, cc.book_sec_out sec_out, mcc.book_id default_book FROM mrgcall_config mcc, collateral_config cc WHERE mcc.mrg_call_def = cc.mcc_id AND mcc.book_id != 0 AND cc.book_cash_in IS NULL AND cc.book_cash_out IS NULL AND cc.book_sec_in IS NULL AND cc.book_sec_out IS NULL) SET cash_in = default_book, cash_out = default_book, sec_in = default_book, sec_out = default_book';

END;
/