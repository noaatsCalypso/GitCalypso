/*  FEED_ADDRESS TABLE  */

/*  This first part updates the QUOTE_NAME used in Caps */


CREATE PROCEDURE sp_feed_address_name_change
WITH RECOMPILE
AS

BEGIN

select feed_address.quote_name, feed_address.quote_type, feed_address.feed_name, feed_address.feed_address, feed_address.mult_coef, feed_address.add_coef, feed_address.bid_name, feed_address.ask_name, feed_address.open_name, feed_address.close_name, feed_address.high_name, feed_address.low_name, feed_address.version_num, feed_address.last_name
into feed_address_backup
from feed_address


update feed_address set quote_name = (
 select max(und.quote_name)
from vol_surf_und und, vol_surf_und_BACKUP undbackup
where
und.vol_surf_und_id = undbackup.vol_surf_und_id
and
undbackup.quote_name = feed_address.quote_name)
from vol_surf_und_BACKUP undbackup
where
feed_address.quote_name = undbackup.quote_name


END

exec sp_procxmode 'sp_feed_address_name_change', 'anymode'
go
exec sp_feed_address_name_change
go
DROP PROCEDURE sp_feed_address_name_change
go