DECLARE
    CURSOR c_applyFx IS SELECT analysis, param_name, attribute_value
                        FROM ERS_AN_PARAM
                        WHERE attribute_name ='ApplyFXPostPL';
    
    lowerValue ERS_AN_PARAM.attribute_value%TYPE;
    ins_leg varchar(200);
    ins_products varchar(200);
BEGIN
    ins_leg := 'INSERT INTO ERS_AN_PARAM(analysis, param_name, attribute_name, attribute_value) VALUES(:1, :2, ''ApplyFXPostPLMethod'', ''Leg'')';
    ins_products := 'INSERT INTO ERS_AN_PARAM(analysis, param_name, attribute_name, attribute_value) VALUES(:1, :2, ''ApplyFXPostPLProducts'', :3)';

    FOR paramApplyFx in c_applyFx
    LOOP
        lowerValue := lower(paramApplyFx.attribute_value);
        
        IF lowerValue = 'true' THEN
            EXECUTE IMMEDIATE ins_leg USING paramApplyFx.analysis, paramApplyFx.param_name;

        ELSIF lowerValue <> 'false' THEN
            EXECUTE IMMEDIATE ins_leg USING paramApplyFx.analysis, paramApplyFx.param_name;
            EXECUTE IMMEDIATE ins_products USING paramApplyFx.analysis, paramApplyFx.param_name, paramApplyFx.attribute_value;
        END IF;
    END LOOP;
END;

