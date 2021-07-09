/* just initialize the seed liq_info_id change is only required to be fixed in Sybase not for oracle */


delete from calypso_seed where seed_name = 'LiquidationInfo'
;
 
/* added the seed through xml */
