CREATE OR REPLACE PROCEDURE PSHEET_EXP_DEL_LINK_MIGRATION AS 
BEGIN
  FOR leg_link IN (select * from psheet_leg_link where strategy = 'OTB' and prop_name = 'Delivery Date' and ref_prop_name = 'Expiry Date' and
  operator IN ('CALCULATE_EXPIRY_DATE', 'CALCULATE_DELIVERY_DATE', 'EQUAL_TO', 'CALCULATE_EXPIRY_DATE_T1', 'CALCULATE_DELIVERY_DATE_T1')) LOOP
  IF(NOT(leg_link.cell1_to_cell2_link_state = 'Disabled' AND leg_link.cell2_to_cell1_link_state = 'Disabled')) THEN
    IF(leg_link.operator = 'CALCULATE_EXPIRY_DATE' OR leg_link.operator = 'CALCULATE_DELIVERY_DATE') THEN
      insert into trade_keyword values(leg_link.ref_id, 'ExpiryDeliveryLink', 'On');
    ELSIF(leg_link.operator = 'CALCULATE_EXPIRY_DATE_T1' OR leg_link.operator = 'CALCULATE_DELIVERY_DATE_T1') THEN
      insert into trade_keyword values(leg_link.ref_id, 'ExpiryDeliveryLink', 'T+1');
    ELSE
      insert into trade_keyword values(leg_link.ref_id, 'ExpiryDeliveryLink', 'Equal');
    END IF;
  END IF;
    END LOOP;
END PSHEET_EXP_DEL_LINK_MIGRATION;
/

begin
PSHEET_EXP_DEL_LINK_MIGRATION;
end;
/
drop procedure PSHEET_EXP_DEL_LINK_MIGRATION
/

