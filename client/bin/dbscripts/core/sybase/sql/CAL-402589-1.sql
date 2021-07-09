update am_widget_columns set widget_column_id = widget_id || '#' || column_name
go

CREATE PROCEDURE PWS_WIDGET_ITEMS_ORDER 
AS 
BEGIN
DECLARE @widget_id VARCHAR(255), @column_name VARCHAR(255), @item_index INT
DECLARE widget_column_cursor CURSOR 
FOR
  SELECT widget_id, column_name FROM am_widget_columns ORDER BY widget_id
  SELECT @item_index = 0

OPEN widget_column_cursor
FETCH widget_column_cursor INTO @widget_id, @column_name
WHILE (@@sqlstatus = 0)
  BEGIN
	update am_widget_columns set item_index = @item_index where widget_id = @widget_id and column_name = @column_name
	set @item_index = @item_index + 1
	FETCH widget_column_cursor INTO @widget_id, @column_name
  END	
CLOSE widget_column_cursor
DEALLOCATE CURSOR widget_column_cursor
END
go

exec sp_procxmode 'PWS_WIDGET_ITEMS_ORDER', 'anymode'
go

exec PWS_WIDGET_ITEMS_ORDER
go

IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'PWS_WIDGET_ITEMS_ORDER'
                                    AND type = 'P')
   BEGIN
     exec('drop procedure PWS_WIDGET_ITEMS_ORDER')
   END
go

