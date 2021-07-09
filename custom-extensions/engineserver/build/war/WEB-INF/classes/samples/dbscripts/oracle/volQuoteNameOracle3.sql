--
-- FEED_ADDRESS TABLE
-- This first part updates the QUOTE_NAME used in Caps
-- 
--

CREATE TABLE feed_address_backup as select * from feed_address
;

update feed_address set quote_name =
  (select max(und.quote_name)
       from vol_surf_und und,  vol_surf_und_BACKUP undbackup
           where
               und.vol_surf_und_id = undbackup.vol_surf_und_id
            and
              undbackup.quote_name = feed_address.quote_name)
where
exists 
   (select quote_name from vol_surf_und_BACKUP undbackup
      where
   feed_address .quote_name = undbackup.quote_name)
;

commit
;