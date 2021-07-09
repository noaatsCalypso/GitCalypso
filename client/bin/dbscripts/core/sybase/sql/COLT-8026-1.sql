  if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'book_cash_in')
  begin 
        execute ('ALTER TABLE collateral_config ADD book_cash_in numeric NULL')
  end
  go
  
  if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'book_cash_out')
  begin 
        execute ('ALTER TABLE collateral_config ADD book_cash_out numeric NULL')
  end
  go
  
  if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'book_sec_in')
  begin 
        execute ('ALTER TABLE collateral_config ADD book_sec_in numeric NULL')
  end
  go
  
  if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'book_sec_out')
  begin 
        execute ('ALTER TABLE collateral_config ADD book_sec_out numeric NULL')
  end
  go
  
  if not exists (select 1 from sysobjects , syscolumns where sysobjects.id = syscolumns.id and sysobjects.name = 'collateral_config' and syscolumns.name = 'inv_source_book_for')
  begin 
        execute ('ALTER TABLE collateral_config ADD inv_source_book_for VARCHAR(100) NULL')
  end
  go
  
  UPDATE collateral_config SET inv_source_book_for = 'None' WHERE book_cash_in IS NULL AND book_cash_out IS NULL AND book_sec_in IS NULL AND book_cash_out IS NULL
  go
  
  UPDATE collateral_config SET collateral_config.book_cash_in = mrgcall_config.book_id, collateral_config.book_cash_out = mrgcall_config.book_id, collateral_config.book_sec_in = mrgcall_config.book_id, collateral_config.book_sec_out = mrgcall_config.book_id FROM collateral_config INNER JOIN mrgcall_config ON collateral_config.mcc_id = mrgcall_config.mrg_call_def WHERE collateral_config.book_cash_in IS NULL AND collateral_config.book_cash_out IS NULL AND collateral_config.book_sec_in IS NULL AND collateral_config.book_cash_out IS NULL
  go