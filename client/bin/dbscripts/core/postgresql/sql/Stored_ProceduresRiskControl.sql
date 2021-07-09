CREATE OR REPLACE FUNCTION limit_s_delete_housekeeping_postgres(p_deleteJulian1 int , p_deleteJulian2 int , 
p_deleteJulian3 int , p_deleteJulian4 int , p_deleteJulian5 int , p_deleteJulian6 int , p_deleteJulian7 int , 
p_deleteJulian8 int , p_deleteJulian9 int , p_deleteJulian10 int , p_deleteJulian11 int , p_deleteJulian12 int , p_deleteJulian13 int , p_deleteJulian14 int , p_deleteJulian15 int)

RETURNS INT  language plpgsql
AS $$
BEGIN
     delete from ers_credit_log where value_julian < p_deleteJulian1  ;
	 delete from ers_limit_log where value_julian < p_deleteJulian2  ;
	 delete from ers_limit_job where value_julian < p_deleteJulian3  ;
	 delete from ers_limit_usage where value_date_julian < p_deleteJulian4 ;
	 delete from ers_credit_exposure where julian_offset < p_deleteJulian5  ;
	 delete from ers_credit_exposure_measure where julian_offset < p_deleteJulian6;
	 delete from ers_credit_exposure_attribute where julian_offset < p_deleteJulian7  ;
	 delete from ers_settlement where value_julian < p_deleteJulian8  ;
	 delete from ers_predeal_check where julian_offset < p_deleteJulian9  ;
	 delete from ers_exposure_log where value_julian < p_deleteJulian10 ;
	 delete from ers_exposure_position_attr where julian_offset < p_deleteJulian11  ;
	 delete from ers_exp_pos_attr_drilldown where julian_offset < p_deleteJulian12  ; 
	 delete from ers_limit_regrisk_drilldown where julian_offset < p_deleteJulian13  ;
	 delete from ers_exposure_regrisk_position where julian_offset < p_deleteJulian14  ;
	 delete from ers_exposure_regrisk_measure where julian_offset < p_deleteJulian15 ;	

RETURN 0;
END $$;
;
 