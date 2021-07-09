update am_widget_columns set widget_column_id = widget_id || '#' || column_name
;

CREATE OR REPLACE PROCEDURE PWS_WIDGET_ITEMS_ORDER AS 
BEGIN

  FOR widget_record IN (SELECT widget_id, column_name, (ROW_NUMBER() OVER (PARTITION BY widget_id ORDER BY widget_id))-1 as idx FROM am_widget_columns) 
  LOOP
  update am_widget_columns set item_index=widget_record.idx where widget_id = widget_record.widget_id and column_name = widget_record.column_name;
  END LOOP;
  
END PWS_WIDGET_ITEMS_ORDER;
/

BEGIN
PWS_WIDGET_ITEMS_ORDER;
END;
/

DROP PROCEDURE PWS_WIDGET_ITEMS_ORDER
;

