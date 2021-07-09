CREATE PROCEDURE sp_quote_value_name_change
AS
BEGIN

select quote_value.quote_set_name, quote_value.quote_name, quote_value.quote_date, quote_value.bid, quote_value.ask, quote_value.open_quote, quote_value.close_quote, quote_value.quote_type, quote_value.entered_datetime, quote_value.version_num, quote_value.entered_user, quote_value.high, quote_value.low, quote_value.estimated_b, quote_value.last_quote, quote_value.known_date, quote_value.source_name
into quote_value_backup
from quote_value

update quote_value set quote_name = (
 select max(und.quote_name)
from vol_surf_und und, vol_surf_und_BACKUP undbackup
where
und.vol_surf_und_id = undbackup.vol_surf_und_id
and
undbackup.quote_name = quote_value.quote_name)
from vol_surf_und_BACKUP undbackup
where
quote_value.quote_name = undbackup.quote_name

END
exec sp_procxmode 'sp_quote_value_name_change', 'anymode'
go
exec sp_quote_value_name_change
go
DROP PROCEDURE sp_quote_value_name_change
go