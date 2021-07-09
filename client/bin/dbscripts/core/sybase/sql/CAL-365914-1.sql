DECLARE
   @cnt_decimal INT, @cnt_method INT,@cnt_rounding_decimal INT,@cnt_rounding_method INT
BEGIN
	SELECT @cnt_decimal=COUNT(*) FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'product_rounding_rule'  AND syscolumns.name =  'decimals'
	SELECT @cnt_method=COUNT(*) FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'product_rounding_rule'  AND syscolumns.name = 'method'
	SELECT @cnt_rounding_decimal=COUNT(*) FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'product_rounding_rule'  AND syscolumns.name =  'rounding_decimals'
	SELECT @cnt_rounding_method=COUNT(*) FROM sysobjects, syscolumns WHERE sysobjects.id = syscolumns.id AND sysobjects.name = 'product_rounding_rule'  AND syscolumns.name =  'rounding_method'
	
	-- While running execute sql, rounding_decimals column will be added if it is not there since we have modified the column name in schema base, 
	-- so we need drop that column and rename the existing column(decimals) to rounding_decimals
	IF(@cnt_rounding_decimal = 1 AND @cnt_decimal =1)
		exec('alter table product_rounding_rule rename column rounding_decimals to rounding_decimals_bck')
	IF @cnt_decimal = 1 
		exec('alter table product_rounding_rule rename column decimals to rounding_decimals')
	--Similar to above, do the same thing for rounding_method column
	IF(@cnt_rounding_method = 1 AND @cnt_method =1)
		exec('alter table product_rounding_rule rename column rounding_method to rounding_method_bck')
	IF @cnt_method = 1 
		exec('alter table product_rounding_rule rename column method to rounding_method')
	
	--Finally drop the bck columns	
	IF(@cnt_rounding_decimal = 1 AND @cnt_rounding_method = 1 AND @cnt_method = 1 AND @cnt_decimal =1)
		exec('alter table product_rounding_rule drop (rounding_decimals_bck , rounding_method_bck)')
END
go
