/* Upgrade Version */
delete from ers_info
;
/* Fix Total Risk Issuer Definition */
update ers_measure_config set measure='Issuer Market Value' where display_name='Isser Market Risk'
;