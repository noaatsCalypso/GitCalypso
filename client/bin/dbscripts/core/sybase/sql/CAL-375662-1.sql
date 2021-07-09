CREATE OR REPLACE PROCEDURE APPLYFX_MIGRATION AS
BEGIN

	DECLARE c_applyFx CURSOR FOR     
					SELECT analysis, param_name, attribute_value
                    FROM ers_an_param
                    WHERE attribute_name ='ApplyFXPostPL'
                   
	DECLARE @analysis  			VARCHAR(32)
	DECLARE	@param_name 		VARCHAR(32)
	DECLARE @attribute_value 	VARCHAR(32)
	DECLARE @lower_value		VARCHAR(32)
                   
   	OPEN c_applyFx           
   	FETCH c_applyFx into @analysis, @param_name, @attribute_value
   	
   	
   	WHILE(@@sqlstatus = 0)
   		BEGIN
		   	SELECT @lower_value = lower(@attribute_value)
			
	   		IF(@lower_value = 'true')
		   		BEGIN
						INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value)
						VALUES(@analysis, @param_name, 'ApplyFXPostPLMethod', 'Leg')
		   		END
	   		ELSE IF(@lower_value != 'false')
				BEGIN
						INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value)
						VALUES(@analysis, @param_name, 'ApplyFXPostPLMethod', 'Leg')
						
						INSERT INTO ers_an_param(analysis, param_name, attribute_name, attribute_value) 
						VALUES(@analysis, @param_name, 'ApplyFXPostPLProducts', @attribute_value)
				END
				
			FETCH c_applyFx into @analysis, @param_name, @attribute_value
   		END
   	
   	
    CLOSE c_applyFx
    DEALLOCATE c_applyFx
END
GO

EXEC APPLYFX_MIGRATION
GO 

DROP PROCEDURE APPLYFX_MIGRATION
GO




