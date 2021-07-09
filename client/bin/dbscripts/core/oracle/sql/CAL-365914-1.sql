DECLARE
   cnt_decimal INT;
   cnt_method INT;
   cnt_rounding_decimal INT;
   cnt_rounding_method INT;
BEGIN
	SELECT COUNT(*) INTO cnt_decimal FROM user_tab_cols WHERE upper(table_name)='PRODUCT_ROUNDING_RULE' AND upper(column_name) = 'DECIMALS';
	SELECT COUNT(*) INTO cnt_method FROM user_tab_cols WHERE upper(table_name)='PRODUCT_ROUNDING_RULE' AND upper(column_name) = 'METHOD';
	SELECT COUNT(*) INTO cnt_rounding_decimal FROM user_tab_cols WHERE upper(table_name)='PRODUCT_ROUNDING_RULE' AND upper(column_name) = 'ROUNDING_DECIMALS';
	SELECT COUNT(*) INTO cnt_rounding_method FROM user_tab_cols WHERE upper(table_name)='PRODUCT_ROUNDING_RULE' AND upper(column_name) = 'ROUNDING_METHOD';
	
	-- While running execute sql, rounding_decimals column will be added if it is not there since we have modified the column name in schema base, 
	-- so we need drop that column and rename the existing column(decimals) to rounding_decimals
	IF(cnt_rounding_decimal = 1 AND cnt_decimal =1) THEN
		execute immediate 'alter table product_rounding_rule rename column rounding_decimals to rounding_decimals_bck';
	END IF;
	IF cnt_decimal = 1 THEN
		execute immediate 'alter table product_rounding_rule rename column decimals to rounding_decimals';
	END IF;
	--Similar to above, do the same thing for rounding_method column
	IF(cnt_rounding_method = 1 AND cnt_method =1) THEN
		execute immediate 'alter table product_rounding_rule rename column rounding_method to rounding_method_bck';
	END IF;
	IF cnt_method = 1 THEN
		execute immediate 'alter table product_rounding_rule rename column method to rounding_method';	
	END IF;
	
	--Finally drop the bck columns	
	IF(cnt_rounding_decimal = 1 AND cnt_rounding_method = 1 AND cnt_method = 1 AND cnt_decimal =1) THEN
		execute immediate 'alter table product_rounding_rule drop (rounding_decimals_bck , rounding_method_bck)';
	END IF;	
END;
/
