update vol_surf_qtvalue set quote_name = (substr(quote_name, 0, instr(quote_name,'.',-1,3)-1) || '0' || substr(quote_name, instr(quote_name,'.',-1,3), length(quote_name))) where (substr(quote_name, 0, 4) = 'Cap.') and (substr(quote_name, instr(quote_name,'.',-1,4) , 5) in ('.001.', '.002.', '.003.', '.004.', '.005.', '.006.', '.007.', '.008.', '.009.'))
;

update quote_value set quote_name = (substr(quote_name, 0, instr(quote_name,'.',-1,3)-1) || '0' || substr(quote_name, instr(quote_name,'.',-1,3), length(quote_name))) where (substr(quote_name, 0, 4) = 'Cap.') and (substr(quote_name, instr(quote_name,'.',-1,4) , 5) in ('.001.', '.002.', '.003.', '.004.', '.005.', '.006.', '.007.', '.008.', '.009.'))
;