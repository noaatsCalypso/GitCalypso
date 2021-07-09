update vol_surf_qtvalue set 
quote_name = substring(quote_name, 1, (len(quote_name)- charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1))) 
|| '0' 
|| substring(quote_name, (len(quote_name)- charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1)+1), len(quote_name)) 
where (substring(quote_name, 1, 4) = 'Cap.') 
and (substring(quote_name, (len(quote_name)-(charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1)+1)-1)), 5) in ('.001.', '.002.', '.003.', '.004.', '.005.', '.006.', '.007.', '.008.', '.009.'))
go


update quote_value set 
quote_name = substring(quote_name, 1, (len(quote_name)- charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1))) 
|| '0' 
|| substring(quote_name, (len(quote_name)- charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1)+1), len(quote_name)) 
where (substring(quote_name, 1, 4) = 'Cap.') 
and (substring(quote_name, (len(quote_name)-(charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name), charindex('.', reverse(quote_name))+1)+1)+1)-1)), 5) in ('.001.', '.002.', '.003.', '.004.', '.005.', '.006.', '.007.', '.008.', '.009.'))
go

