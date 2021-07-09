/****************************************************/
/* Bug Number 10045 */
/* No upgrade for swap quote in curve_quote and quote_value table from rel550 p3 to p9 */
/* Old Quote Name did not contains the Source Name so Script update the  the existing Quote with Quote+'.'+Source Name */
/* This Script has to be Ran only ONCE using isql */
/****************************************************/


/****************************************************/
/* Temporary Curve Underlying Swap table for playing with */
/****************************************************/
CREATE TABLE tmp_cu_swap
	(cu_id int NOT NULL,
	source_name varchar(255),
	tmp_rate_index varchar(255) null,	
	tmp_currency VARCHAR(255) null,		
	tmp_tenor VARCHAR(255) null	,
	maturity_tenor int null,
	fixed_cpn_freq VARCHAR(255) null		
) 
go

print ' Table tmp_cu_swap Created'
go


/* insert all the records from cu_swap */
INSERT INTO tmp_cu_swap(cu_id,source_name,maturity_tenor,fixed_cpn_freq) 
SELECT cu_id,rate_index,maturity_tenor,fixed_cpn_freq from cu_swap
go


/* get the currency from rate_index */
UPDATE tmp_cu_swap
SET tmp_currency=substring(source_name,1,charindex('/',source_name)-1)
go


/* decrease the rate_index remove the currency part */
UPDATE tmp_cu_swap SET source_name=substring(source_name,charindex('/',source_name)+1 ,char_length
(source_name)-charindex('/',source_name) ) 
go

/* get the rate_index  */
UPDATE tmp_cu_swap
SET tmp_rate_index=substring(source_name,1,charindex('/',source_name)-1)
go

/* decrease the source name, remove the rate_index portion from it */
UPDATE tmp_cu_swap SET source_name=substring(source_name,charindex('/',source_name)+1 ,char_length
(source_name)-charindex('/',source_name) ) 
go



/* get the tenor for swap */
UPDATE tmp_cu_swap
SET tmp_tenor=substring(source_name,1,charindex('/',source_name)-1)
go


/* remove the tenor */
UPDATE tmp_cu_swap SET source_name=substring(source_name,charindex('/',source_name)+1 ,char_length
(source_name)-charindex('/',source_name) ) 
go 

/* UPDATE the fixed_cpn_freq in format 1M,3M,6M */
UPDATE tmp_cu_swap SET fixed_cpn_freq='1W'   
WHERE fixed_cpn_freq='WK' 
go
										
UPDATE tmp_cu_swap SET fixed_cpn_freq='15D'   
WHERE fixed_cpn_freq='BIWK' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='4W'   
WHERE fixed_cpn_freq='LUN' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='1M'   
WHERE fixed_cpn_freq='MTH' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='2M'   
WHERE fixed_cpn_freq='BIM' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='3M'   
WHERE fixed_cpn_freq='QTR' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='6M'   
WHERE fixed_cpn_freq='SA' 
go

UPDATE tmp_cu_swap SET fixed_cpn_freq='1Y'   
WHERE fixed_cpn_freq='PA' 
go


print 'Tmp_cu_swap Operations Completed'
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM curve_quote_value
print '1)Count of Table Curve_Quote_Value Before Creatiing Table tmp_crv_qt_val'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/****************************************************/
/* Change the logic so that it first create tmp_curve_quote_value table */
/* and will perform all the operations on it and then  */
/* copy it on main table */
/****************************************************/
CREATE TABLE tmp_crv_qt_val
	(curve_id int NOT NULL,
	curve_date _Datetime  NOT NULL,
	quote_name _LongName NOT NULL,	
	new_quote_name _LongName  NULL,	
	tmp_quote_name _LongName  NULL,
	tmp_basis_swap_search VARChar(255) null,
	tmp_basis_swap Integer null,	
	tmp_rate_index VARCHAR(255) null,
	tmp_tenor VARCHAR(255) null,
	tmp_second_tenor VARCHAR(255) null,	
	tmp_maturity_tenor int null,	
	tmp_currency VARCHAR(255) null,	
	fixed_cpn_freq VARCHAR(255) null,
	tmp_maturity_tenorstr VARCHAR(255) null		
) 
go


/****************************************************/
/* INSERT JUST THE SWAP RECORDS IN THE TABLE  */
/* THIS would eliminate performing large scan on the Tables  */
/* CHANGE THE DATE HERE  */
/****************************************************/
INSERT INTO tmp_crv_qt_val(curve_id,curve_date,quote_name,tmp_quote_name)
SELECT curve_id,curve_date,quote_name,quote_name FROM curve_quote_value
WHERE quote_name like 'Swap.%' and curve_date > '1999-05-29 12:59:59'   
go



/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '2)Count of Table tmp_crv_qt_val After Inserting Records in it'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '3)Count of Table tmp_crv_qt_val After Updating tmp_quote_name with quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* algorithm to determine if the swap if cu_swap or cu_basis_swap */
/****************************************************/
/*1)split by / */
/*2)get the first part uppto dot. */
/*3)check if that field is contain in rate_index table... */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN	
UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substring(tmp_quote_name,charindex('/',tmp_quote_name)+1 ,char_length
	(tmp_quote_name)-charindex('/',tmp_quote_name) ) 
	WHERE  tmp_basis_swap_search is  NULL
	SELECT @cnt = @@rowcount
	commit	   
	go	
END	
SET ROWCOUNT 0
go
commit	   
go	


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '4)Count of Table tmp_crv_qt_val After Updating tmp_basis_swap_search'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substring(tmp_basis_swap_search,1,charindex('.',tmp_basis_swap_search)-1 ) 
WHERE  charindex('.',tmp_basis_swap_search) > 0  
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '5)Count of Table Curve_Quote_Value After Updating tmp_basis_swap_search 2nd Time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/* Update the basis */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_basis_swap=0 WHERE tmp_basis_swap is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END		
SET ROWCOUNT 0
go
commit	   
go	



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '6)Count of Table Curve_Quote_Value After Updating tmp_basis_swap'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val
SET tmp_basis_swap=1
WHERE tmp_basis_swap_search in (SELECT distinct rate_index_code from rate_index)	
go

commit
go

/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '7)Count of Table tmp_crv_qt_val After Updating tmp_basis_swap  2nd Time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* algorithm ends here */

/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length(tmp_quote_name)-charindex('.',tmp_quote_name))
WHERE  tmp_basis_swap=0 
go	

commit
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '8)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/* UPDATE the maturity part tenor */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenorstr=substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name)-1)
	WHERE  tmp_maturity_tenorstr is NULL
	SELECT @cnt = @@rowcount
	commit
	go		
END	

SET ROWCOUNT 0
go
COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '9)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenorstr'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* assume year is 360 */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('Y',tmp_maturity_tenorstr)-1)) * 360
	WHERE  tmp_basis_swap=0 and charindex('Y',tmp_maturity_tenorstr) > 0 and tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END	
SET ROWCOUNT 0
go
COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '10)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenorstr'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('M',tmp_maturity_tenorstr)-1)) * 30
	WHERE  tmp_basis_swap=0 and charindex('M',tmp_maturity_tenorstr) > 0 and tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END		
SET ROWCOUNT 0
go
COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '11)Count of Table Curve_Quote_Value After Updating tmp_maturity_tenorstr 2nd Time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN	
UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('W',tmp_maturity_tenorstr)-1)) * 7
	WHERE tmp_basis_swap=0 and charindex('W',tmp_maturity_tenorstr) > 0 and tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount
	commit
	go	
END		
SET ROWCOUNT 0
go
COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '11)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenorstr 3rd Time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/* remove the second part dot */
/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('.',tmp_quote_name))WHERE  tmp_basis_swap=0 
go


COMMIT
go
/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '12)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* get the currency  */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_currency=substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1)
	WHERE  tmp_basis_swap=0 and tmp_currency is NULL
	SELECT @cnt = @@rowcount
	commit
	go	
END		
SET ROWCOUNT 0
go
COMMIT
go


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '13)Count of Table tmp_crv_qt_val After Updating tmp_currency'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('.',tmp_quote_name) )WHERE tmp_basis_swap=0 
go

commit
go


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print 'Count of Table tmp_crv_qt_val After removing currency from tmp_crv_qt_val'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/* get the rate index */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_rate_index=substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1)
	WHERE  tmp_basis_swap=0 and tmp_rate_index is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END		
SET ROWCOUNT 0
go
COMMIT
go




/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '14)Count of Table tmp_crv_qt_val After updating tmp_rate_index'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
/* remove the rate index */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-(charindex('.',tmp_quote_name)) ) WHERE tmp_basis_swap=0 
go

commit
go

/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '15)Count of Table tmp_crv_qt_val After removing the rate index from tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/* get the tenor */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
UPDATE tmp_crv_qt_val
SET tmp_tenor=tmp_quote_name 
WHERE  tmp_basis_swap=0 and charindex('.',tmp_quote_name) <=0 and tmp_tenor is NULL
	SELECT @cnt = @@rowcount	
	commit	   
	go
END		
SET ROWCOUNT 0
go
COMMIT
go

/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '16)Count of Table tmp_crv_qt_val After updating tmp_tenor'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
UPDATE tmp_crv_qt_val
SET tmp_tenor=substring(tmp_quote_name,1,charindex('.',tmp_quote_name))
WHERE  tmp_basis_swap=0 and charindex('.',tmp_quote_name) > 0 
go


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '17)Count of Table tmp_crv_qt_val After updating tmp_tenor 2nd Time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* get the second part*/
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_second_tenor=substring(tmp_tenor,charindex('/',tmp_tenor)+1 ,char_length
	(tmp_tenor)-charindex('/',tmp_tenor) )WHERE  tmp_basis_swap=0 and tmp_second_tenor is NULL
	SELECT @cnt = @@rowcount
	commit
	go
END		
SET ROWCOUNT 0
go
COMMIT
go

/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '18)Count of Table tmp_crv_qt_val After updating tmp_second_tenor'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/****************************************************/
/* CANNOT USE HERE ROW COUNT STUFF */
/****************************************************/
/* remove the second tenor from tmp_tenor*/
UPDATE tmp_crv_qt_val SET tmp_tenor=substring(tmp_quote_name,1,charindex('/',tmp_quote_name)-1)
WHERE tmp_basis_swap=0 
go



/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '19)Count of Table tmp_crv_qt_val After updating tmp_tenor second time'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val 
	SET fixed_cpn_freq=substring(tmp_second_tenor,1,2) 
	WHERE tmp_basis_swap=0 and fixed_cpn_freq is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END		
SET ROWCOUNT 0
go
COMMIT
go

/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '20)Count of Table tmp_crv_qt_val After updating fixed_cpn_freq'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/* UPDATE the quote_name field right  */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET new_quote_name= quote_name + ( select '.' + source_name
	from tmp_cu_swap,curve_member WHERE 
	 curve_member.cu_id=tmp_cu_swap.cu_id
	AND curve_member.curve_id=tmp_crv_qt_val.curve_id 
	AND  curve_member.curve_date=tmp_crv_qt_val.curve_date
	AND tmp_crv_qt_val.tmp_rate_index=tmp_cu_swap.tmp_rate_index
	AND tmp_crv_qt_val.tmp_currency=tmp_cu_swap.tmp_currency
	AND tmp_crv_qt_val.tmp_tenor=tmp_cu_swap.tmp_tenor
	AND tmp_crv_qt_val.tmp_maturity_tenor=tmp_cu_swap.maturity_tenor
	AND tmp_crv_qt_val.fixed_cpn_freq=tmp_cu_swap.fixed_cpn_freq)
	WHERE tmp_basis_swap=0  AND charindex('.',tmp_crv_qt_val.tmp_quote_name) <= 0 and new_quote_name is NULL
	SELECT @cnt = @@rowcount	
	commit
	go
END		
SET ROWCOUNT 0
go
COMMIT
go

/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table and curve_quote_value */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM curve_quote_value
print '21)Count of Table curve_quote_value BEFORE Updating the ACTUAL Quote Name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '22)Count of Table tmp_crv_qt_val BEFORE Updating the ACTUAL Quote Name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/****************************************************/
/* Now here we update back the Original Table curve_quote_value */
/****************************************************/

UPDATE curve_quote_value SET quote_name=(SELECT new_quote_name FROM tmp_crv_qt_val
WHERE curve_quote_value.curve_id=tmp_crv_qt_val.curve_id 
AND  curve_quote_value.curve_date=tmp_crv_qt_val.curve_date
AND   curve_quote_value.quote_name=tmp_crv_qt_val.quote_name
AND tmp_crv_qt_val.tmp_basis_swap=0
AND new_quote_name is NOT NULL)
WHERE EXISTS(SELECT curve_id from tmp_crv_qt_val 
WHERE curve_quote_value.curve_id=tmp_crv_qt_val.curve_id 
AND  curve_quote_value.curve_date=tmp_crv_qt_val.curve_date
AND   curve_quote_value.quote_name=tmp_crv_qt_val.quote_name 
AND  tmp_basis_swap=0 
AND new_quote_name is NOT NULL)
go

/*SET ROWCOUNT 0*/
/*go*/
/*COMMIT*/
/*go*/


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table and curve_quote_value After updating the main column */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM curve_quote_value
print '22)Count of Table curve_quote_value AFTER Updating the ACTUAL Quote Name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '23)Count of Table tmp_crv_qt_val AFTER Updating the ACTUAL Quote Name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go

COMMIT
go

DROP TABLE tmp_cu_swap
go
DROP TABLE tmp_crv_qt_val
go
COMMIT
go




