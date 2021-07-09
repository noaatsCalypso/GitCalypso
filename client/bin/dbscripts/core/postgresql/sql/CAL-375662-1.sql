CREATE or replace PROCEDURE APPLYFX_MIGRATION()
LANGUAGE PLPGSQL
AS $$
declare
    c_applyFx cursor for
    			SELECT analysis, param_name, attribute_value
                FROM ers_an_param
                WHERE attribute_name ='ApplyFXPostPL';
  	analysis  			VARCHAR(32);
	param_name 		VARCHAR(32);
	attribute_value 	VARCHAR(32);
	lower_value		VARCHAR(32);

begin
	open c_applyFx;

	loop
		fetch c_applyFx into analysis, param_name, attribute_value;
	
		exit when not found;
	
		lower_value := lower(attribute_value);
	
		if lower_value = 'true' then
				INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value)
				VALUES(analysis, param_name, 'ApplyFXPostPLMethod', 'Leg');
		elsif lower_value != 'false' then
				INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value)
				VALUES(analysis, param_name, 'ApplyFXPostPLMethod', 'Leg');
						
				INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value) 
				VALUES(analysis, param_name, 'ApplyFXPostPLProducts', attribute_value);
		end if;
		
	end loop;

	close c_applyFx;

END; 
$$;

call APPLYFX_MIGRATION();

drop procedure APPLYFX_MIGRATION;
