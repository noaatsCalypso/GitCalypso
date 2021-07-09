--
-- This first part updates the QUOTE_NAME from QUOTE_VALUE table 
-- used in CAPS
--

CREATE TABLE quote_value_backup as select * from quote_value
;

update quote_value set quote_name =
  (select max(und.quote_name)
       from vol_surf_und und,  vol_surf_und_BACKUP undbackup
           where
               und.vol_surf_und_id = undbackup.vol_surf_und_id
            and
              undbackup.quote_name = quote_value.quote_name)
where
exists 
   (select quote_name from vol_surf_und_BACKUP undbackup
      where
   quote_value.quote_name = undbackup.quote_name)
;

commit;