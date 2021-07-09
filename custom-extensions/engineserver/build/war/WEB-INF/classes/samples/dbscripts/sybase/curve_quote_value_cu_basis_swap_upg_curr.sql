/* Bug No 10229  */
/* This Script just take care of adding the source name to the basis swap quote if not present */
/* There is separate Script for Currency bug */
/* This Script wil;l only update those  */

CREATE TABLE tmp_cu_basis_swap
	(cu_id int NOT NULL,
	base_rate_index varchar(255) NULL,
	basis_rate_index varchar(255) NULL,	
	tmp_rate_index1  varchar(255) NULL,
	tmp_rate_index2  varchar(255) NULL,
	tmp_tenor1  varchar(255) NULL,
	tmp_tenor2  varchar(255) NULL,
	tmp_source1  varchar(255) NULL,
	tmp_source2  varchar(255) NULL,	
	tmp_currency1  varchar(255) NULL,
	tmp_currency2  varchar(255) NULL,		
	maturity_tenor INTEGER NULL
)
go

 

/* Assuming the case when quote_name does not contains the currency.*/ 
DELETE FROM tmp_cu_basis_swap
go

INSERT INTO tmp_cu_basis_swap(cu_id,base_rate_index,basis_rate_index,tmp_rate_index1,tmp_rate_index2,tmp_tenor1,tmp_tenor2,tmp_source1,tmp_source2,tmp_currency1,tmp_currency2,maturity_tenor)
SELECT cu_id,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,maturity_tenor FROM cu_basis_swap
go


/*****CURRENCY *******/
/*****Currency 1 *******/
UPDATE tmp_cu_basis_swap
SET tmp_currency1=substring(tmp_currency1,1,charindex('/',tmp_currency1)-1)
go

/*****Currency 2 *******/
UPDATE tmp_cu_basis_swap
SET tmp_currency2=substring(tmp_currency2,1,charindex('/',tmp_currency2)-1)
go

/*****Rate INDEX 1 *******/
/* remove the currency1 */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index1=substring(tmp_rate_index1,charindex('/',tmp_rate_index1)+1,char_length(tmp_rate_index1)-charindex('/',tmp_rate_index1))
go

/* get the rate_index1  */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index1=substring(tmp_rate_index1,1,charindex('/',tmp_rate_index1)-1)
go

/*****Rate INDEX 2 *******/
/* remove the currency2 */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index2=substring(tmp_rate_index2,charindex('/',tmp_rate_index2)+1,char_length(tmp_rate_index2)-charindex('/',tmp_rate_index2))
go


/* get the rate_index 2  */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index2=substring(tmp_rate_index2,1,charindex('/',tmp_rate_index2)-1)
go


/*****Tenor 1 *******/
/* remove the curreny  from tmp_tenor1*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substring(tmp_tenor1,charindex('/',tmp_tenor1)+1,char_length(tmp_tenor1)-charindex('/',tmp_tenor1))
go
/* remove the curreny from tmp_tenor1*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substring(tmp_tenor1,charindex('/',tmp_tenor1)+1,char_length(tmp_tenor1)-charindex('/',tmp_tenor1))
go


/* get the actual tenor*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substring(tmp_tenor1,1,charindex('/',tmp_tenor1)-1)
go

/*****Tenor 2 *******/
/* remove the curreny  from tmp_tenor2*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substring(tmp_tenor2,charindex('/',tmp_tenor2)+1,char_length(tmp_tenor2)-charindex('/',tmp_tenor2))
go

/* remove the curreny from tmp_tenor1*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substring(tmp_tenor2,charindex('/',tmp_tenor2)+1,char_length(tmp_tenor2)-charindex('/',tmp_tenor2))
go

/* get the actual tenor2*/ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substring(tmp_tenor2,1,charindex('/',tmp_tenor2)-1)
go
/*****Source 1 *******/
UPDATE tmp_cu_basis_swap
SET tmp_source1=substring(tmp_source1,charindex('/',tmp_source1)+1,char_length(tmp_source1)-charindex('/',tmp_source1))
go
UPDATE tmp_cu_basis_swap
SET tmp_source1=substring(tmp_source1,charindex('/',tmp_source1)+1,char_length(tmp_source1)-charindex('/',tmp_source1))
go
UPDATE tmp_cu_basis_swap
SET tmp_source1=substring(tmp_source1,charindex('/',tmp_source1)+1,char_length(tmp_source1)-charindex('/',tmp_source1))
go

/*****Source 2 *******/
UPDATE tmp_cu_basis_swap
SET tmp_source2=substring(tmp_source2,charindex('/',tmp_source2)+1,char_length(tmp_source2)-charindex('/',tmp_source2))
go
UPDATE tmp_cu_basis_swap
SET tmp_source2=substring(tmp_source2,charindex('/',tmp_source2)+1,char_length(tmp_source2)-charindex('/',tmp_source2))
go
UPDATE tmp_cu_basis_swap
SET tmp_source2=substring(tmp_source2,charindex('/',tmp_source2)+1,char_length(tmp_source2)-charindex('/',tmp_source2))
go


print 'Tmp_cu_swap Operations Completed'
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/


/* algorithm to determine if the swap if cu_swap or cu_basis_swap */
/*1)split by / */
/*2)get the first part uppto dot. */
/*3)check if that field is contain in rate_index table... */
/* need to ADD same column in curve_quote_value for performing join... */
/****************************************************/
/* Change the logic so that it first create tmp_curve_quote_value table */
/* and will perform all the operations on it and then  */
/* copy it on main table */
/****************************************************/
CREATE TABLE tmp_crv_qt_val
	(curve_id int NOT NULL,
	curve_date _Datetime  NOT NULL,
	quote_name _LongName NOT NULL,	
	new_quote_name _LongName NULL,	
	orig_quote_name _LongName NOT NULL,	
	basis_currency VARCHAR(255) null,
	tmp_quote_name VARCHAR(255) null,
	tmp_basis_swap int null,
	tmp_basis_swap_search VARCHAR(255) null,
	tmp_rate_index1 VARCHAR(255) null,
	tmp_rate_index2 VARCHAR(255) null,
	tmp_tenor1 VARCHAR(255) null,
	tmp_tenor2 VARCHAR(255) NULL,	
	tmp_maturity_tenor int null,	
	tmp_maturity_tenorstr VARCHAR(255) null,
	tmp_currency1 VARCHAR(255) null,
	tmp_currency2 VARCHAR(50) NULL,	
	fixed_cpn_freq VARCHAR(255) null	
) 
go

DELETE FROM tmp_crv_qt_val
go
/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM curve_quote_value
print '2)Count of Table Curve_Quote_Value After Adding Temporary Columns'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/****************************************************/
/* Insert just the Swap Records here */
/* Insert zero by default in  tmp_basis_swap */
/****************************************************/
INSERT INTO tmp_crv_qt_val
(curve_id,curve_date,quote_name,tmp_quote_name,orig_quote_name,tmp_basis_swap)
SELECT curve_id,curve_date,quote_name,quote_name,quote_name,0 FROM curve_quote_value 
WHERE quote_name like 'Swap%'  and curve_id in (select distinct curve_id from curve_member) 
go


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '2)Count of Table tmp_crv_qt_val After insering all the Swap Records '
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substring(tmp_quote_name,charindex('/',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('/',tmp_quote_name) ) 
go	


SET ROWCOUNT 0
COMMIT
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
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/
UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substring(tmp_basis_swap_search,1,charindex('.',tmp_basis_swap_search)-1 ) 
WHERE charindex('.',tmp_basis_swap_search) > 0
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '5)Count of Table Curve_Quote_Value After Updating tmp_basis_swap_search 2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '6)Count of Table tmp_crv_qt_val After Updating tmp_basis_swap'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


SET ROWCOUNT 0
go
/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/
UPDATE tmp_crv_qt_val
SET tmp_basis_swap=1
WHERE tmp_basis_swap_search in ( SELECT distinct rate_index_code from rate_index)
or tmp_basis_swap_search in ( SELECT value from domain_values where name='currency')
go	



print '5)Came here in 5'
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '7)Count of Table tmp_crv_qt_val After Updating tmp_basis_swap_search'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/

/* Main logic start here */
/* Update the tmp_quote_name with original values */
UPDATE tmp_crv_qt_val
SET tmp_quote_name=quote_name
WHERE tmp_basis_swap=1
go	

SET ROWCOUNT 0
go


print '6)Came here in 6'
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



print '7)Came here in 7'
go



/* remove the first part dot */
/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/
/* Remove the Swap.  from tmp_quote_name */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('.',tmp_quote_name) ) 
WHERE  tmp_basis_swap=1
go	

/* UPDATE the maturity part tenor */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenorstr=substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name) )
	WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and tmp_maturity_tenorstr is NULL
	SELECT @cnt = @@rowcount
	commit	
	go
END	

SET ROWCOUNT 0
COMMIT
go

/* remove the second part dot */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('.',tmp_quote_name) ) 
WHERE tmp_basis_swap=1
go	

print '8)Came here in 8'
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '9)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go







/*here need to take care of currency add it if not present */
/* Update the Currency1  */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN	
	UPDATE tmp_crv_qt_val
	SET tmp_currency1=substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name)-1 ) 
	WHERE quote_name like 'Swap%' 
	AND tmp_basis_swap=1 
	AND substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name)-1 )  IN ( SELECT value FROM domain_values WHERE name='currency' )
	AND tmp_currency1 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	
SET ROWCOUNT 0




COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '10)Count of Table tmp_crv_qt_val After Updating tmp_basis_swap'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/*update here currency temporarily with TMP */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_quote_name='TMP' + '.' + tmp_quote_name
	WHERE tmp_currency1 is NULL AND quote_name like 'Swap%' AND tmp_basis_swap=1 
	AND charindex('TMP',tmp_quote_name) <= 0 
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	
SET ROWCOUNT 0

COMMIT
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '11)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
GO






/* get the currency  */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_currency1=substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1)
	WHERE quote_name like 'Swap%' AND tmp_basis_swap=1 AND tmp_currency1 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	GO	
END	

SET ROWCOUNT 0
COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '12)Count of Table tmp_crv_qt_val After Updating tmp_currency1'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/* remove the currency  */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1 ,char_length
(tmp_quote_name)-charindex('.',tmp_quote_name) ) 
WHERE tmp_basis_swap=1
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '13)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go








/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '14)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenorstr'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('Y',tmp_maturity_tenorstr)-1)) * 360
	WHERE quote_name like 'Swap%' 
	AND tmp_basis_swap=1 
	AND charindex('Y',tmp_maturity_tenorstr) > 0 
	AND tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount
	commit	   
	go	
END	
SET ROWCOUNT 0


COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '15)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenor'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('M',tmp_maturity_tenorstr)-1)) * 30
	WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and charindex('M',tmp_maturity_tenorstr) > 0 AND tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	
SET ROWCOUNT 0


COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '16)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenor 2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=convert(integer,substring(tmp_maturity_tenorstr,1,charindex('W',tmp_maturity_tenorstr)-1)) * 7
	WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and charindex('W',tmp_maturity_tenorstr) > 0 AND tmp_maturity_tenor is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	

SET ROWCOUNT 0

COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '17)Count of Table tmp_crv_qt_val After Updating tmp_maturity_tenor 2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
PRINT '18)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=CONVERT(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* get the rate index */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_rate_index1=substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1)
	WHERE tmp_basis_swap=1 AND tmp_rate_index1 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	


SET ROWCOUNT 0
COMMIT
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '19)Count of Table tmp_crv_qt_val After Updating tmp_rate_index1'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/* remove the rate index  */
UPDATE tmp_crv_qt_val SET tmp_quote_name=SUBSTRING(tmp_quote_name,CHARINDEX('.',tmp_quote_name)+1 ,CHAR_LENGTH
(tmp_quote_name)-CHARINDEX('.',tmp_quote_name) ) 
WHERE quote_name like 'Swap%' AND tmp_basis_swap=1
go	


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '20)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/* update the tenor1 */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val set tmp_tenor1=substring(tmp_quote_name,1,charindex('/',tmp_quote_name)-1)
	WHERE tmp_basis_swap=1 AND tmp_tenor1 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	
SET ROWCOUNT 0


COMMIT
go






/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*) FROM tmp_crv_qt_val
print '21)Count of Table tmp_crv_qt_val After Updating tmp_tenor1'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* Get the Second half of Quote name for getting values like tmp_currency2,tmp_rate_index2 */
UPDATE tmp_crv_qt_val 
SET tmp_quote_name=SUBSTRING(tmp_quote_name,CHARINDEX('/',tmp_quote_name)+1,CHAR_LENGTH(tmp_quote_name)-CHARINDEX('/',tmp_quote_name))
WHERE tmp_basis_swap=1
go	

COMMIT
go



/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '22)Count of Table Curve_Quote_Value After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/* Update the Currency 2 */


/*here need to take care of currency add it if not present */
/* Update the Currency2  */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN	
	UPDATE tmp_crv_qt_val
	SET tmp_currency2=substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name)-1 ) 
	WHERE tmp_basis_swap=1 
	AND substring(tmp_quote_name,1 ,charindex('.',tmp_quote_name)-1 )  IN ( SELECT value FROM domain_values WHERE name='currency' )
	AND tmp_currency2 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	

commit
go
/* check here if it is currency 2 */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_currency2='TMP' 
	WHERE  tmp_basis_swap=1 	AND tmp_currency2 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	GO	
END	
SET ROWCOUNT 0



COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '23)Count of Table tmp_crv_qt_val After Updating tmp_currency2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/* Get the Currency 2 actual or TMP */
UPDATE tmp_crv_qt_val
SET tmp_currency2=substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1) 
WHERE substring(tmp_quote_name,1,charindex('.',tmp_quote_name)-1) in (Select value from domain_values where name='currency')
AND tmp_basis_swap=1 
go	



COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '24)Count of Table tmp_crv_qt_val After Updating tmp_currency2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/* append the tmp currency if not present */ 
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val
	SET tmp_quote_name='TMP'+'.'+ tmp_quote_name
	WHERE tmp_currency2 ='TMP' 
	AND tmp_basis_swap=1 AND charindex('TMP',tmp_quote_name) =0	
	SELECT @cnt = @@rowcount
	COMMIT	   
	go	
END	
SET ROWCOUNT 0


COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '25)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/* remove the second currency where real or TMP */
/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/
UPDATE tmp_crv_qt_val
SET tmp_quote_name=SUBSTRING(tmp_quote_name,CHARINDEX('.',tmp_quote_name)+1 ,
CHAR_LENGTH(tmp_quote_name)-CHARINDEX('.',tmp_quote_name) ) 
WHERE tmp_basis_swap=1	
go	


COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '26)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/* get the second rate_index */
DECLARE @cnt INT
SELECT @cnt = 1
SET ROWCOUNT 20000
WHILE @cnt > 0
BEGIN
	UPDATE tmp_crv_qt_val 
	SET tmp_rate_index2=SUBSTRING(tmp_quote_name,1,CHARINDEX('.',tmp_quote_name)-1)
	WHERE tmp_basis_swap=1 AND tmp_rate_index2 is NULL
	SELECT @cnt = @@rowcount
	COMMIT	   
	GO	
END	
SET ROWCOUNT 0


COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '27)Count of Table tmp_crv_qt_val After Updating tmp_rate_index2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go




/* remove the second rate_index */
/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/****************************************************/
UPDATE tmp_crv_qt_val set tmp_quote_name=substring(tmp_quote_name,charindex('.',tmp_quote_name)+1,
char_length(tmp_quote_name)-charindex('.',tmp_quote_name))
WHERE tmp_basis_swap=1
go	

COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '28)Count of Table tmp_crv_qt_val After Updating tmp_quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/* get the second tenor */


/****************************************************/
/* Now do the Count(*) from tmp_crv_qt_val table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '29)Count of Table Curve_Quote_Value After Updating tmp_tenor2'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


/****************************************************/
/* Update tmp_tenor2 with  */
/****************************************************/
UPDATE tmp_crv_qt_val set tmp_tenor2=tmp_quote_name
WHERE tmp_basis_swap=1  and charindex('.',tmp_quote_name) = 0 
go	

UPDATE tmp_crv_qt_val set tmp_tenor2=substring(tmp_quote_name,1,
charindex('.',tmp_quote_name)-1)
WHERE tmp_basis_swap=1  and charindex('.',tmp_quote_name) <> 0 
go	

/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*) FROM tmp_crv_qt_val
print '30)Count of Table Curve_Quote_Value After Updating tmp_basis_swap'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/* update the currency  for that case. in curve quote value table. */
/* for the case when base currency is different from basis currency */
/* COMMENTED FOR CURRENCY BUG */
UPDATE tmp_crv_qt_val SET   
quote_name ='Swap'+'.'+ tmp_maturity_tenorstr  + '.' + tmp_currency1 + '.' + tmp_rate_index1 +'.'+ 
tmp_tenor1 + '/' + tmp_currency2 + '.' + tmp_rate_index2 + '.' + tmp_tenor2  
WHERE tmp_currency2 <> 'TMP' 
go


SET ROWCOUNT 0 
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '31)Count of Table Curve_Quote_Value After Updating quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go






/* for the case when base currency is same from basis currency  */
/* TMP is there in bases currency */
UPDATE tmp_crv_qt_val SET  
quote_name ='Swap'+'.'+ tmp_currency1 + '.' + tmp_maturity_tenorstr  + 
tmp_rate_index1 +'.'+
tmp_tenor1 + '/'  + tmp_rate_index2 + '.' + tmp_tenor2 
WHERE tmp_currency2 = 'TMP'
go	


SET ROWCOUNT 0
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '32)Count of Table tmp_crv_qt_val After Updating quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go


UPDATE tmp_crv_qt_val SET  basis_currency =( select tmp_cu_basis_swap.tmp_currency1 
from  tmp_cu_basis_swap,curve_member
WHERE curve_member.curve_id=tmp_crv_qt_val.curve_id
AND curve_member.curve_date=tmp_crv_qt_val.curve_date
AND   curve_member.cu_id=tmp_cu_basis_swap.cu_id
AND   tmp_crv_qt_val.tmp_rate_index1=tmp_cu_basis_swap.tmp_rate_index1
AND   tmp_crv_qt_val.tmp_rate_index2=tmp_cu_basis_swap.tmp_rate_index2
AND   tmp_crv_qt_val.tmp_tenor1=tmp_cu_basis_swap.tmp_tenor1
AND	  tmp_crv_qt_val.tmp_tenor2=tmp_cu_basis_swap.tmp_tenor2
AND   tmp_crv_qt_val.tmp_maturity_tenor=tmp_cu_basis_swap.maturity_tenor)
WHERE  tmp_basis_swap=1
go

COMMIT
go


/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '33)Count of Table tmp_crv_qt_val After Updating basis_currency'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/* replace the TMP with actual basis currency */
/* currency bug should be solved here */
UPDATE tmp_crv_qt_val SET  
quote_name =stuff(quote_name,charindex('TMP',quote_name),3,basis_currency)
WHERE tmp_currency1 = 'TMP' and tmp_basis_swap=1
go





/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '34)Count of Table Curve_Quote_Value After Updating quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go





/****************************************************/
/* HERE WE CANNOT APPLY ROWCOUNT stuff */
/* For currency Bug replace orig_quote_name with new_quote_name i.e later */
/****************************************************/
/* Checking to tmp_tenor2 is not NULL ensure that if quote_name already contains the source name then it won't update again */
/* update the source name*/
UPDATE tmp_crv_qt_val SET new_quote_name=quote_name + '.' + ( select tmp_source2
from tmp_cu_basis_swap,curve_member WHERE 
curve_member.curve_id=tmp_crv_qt_val.curve_id 
AND curve_member.curve_date=tmp_crv_qt_val.curve_date
AND curve_member.cu_id=tmp_cu_basis_swap.cu_id 
AND tmp_crv_qt_val.tmp_rate_index1=tmp_cu_basis_swap.tmp_rate_index1
AND tmp_crv_qt_val.tmp_rate_index2=tmp_cu_basis_swap.tmp_rate_index2
AND tmp_crv_qt_val.tmp_tenor1=tmp_cu_basis_swap.tmp_tenor1
AND tmp_crv_qt_val.tmp_tenor2=tmp_cu_basis_swap.tmp_tenor2
AND tmp_crv_qt_val.tmp_maturity_tenor=tmp_cu_basis_swap.maturity_tenor
AND tmp_crv_qt_val.quote_name like 'Swap%' and tmp_tenor2 is not NULL)
WHERE tmp_crv_qt_val.quote_name like 'Swap%'
AND tmp_basis_swap=1 
go	




/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM tmp_crv_qt_val
print '35)Count of Table tmp_crv_qt_val After Updating quote_name'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go



/****************************************************/
/* Update here original Quote Name */
/****************************************************/
/* update the source name*/
/****************************************************/
/* Now here we update back the Original Table curve_quote_value */
/* Checking to tmp_tenor2 is not NULL ensure that if quote_name already contains the source name then it won't update again */
/* update the source name*/
UPDATE curve_quote_value SET quote_name=(SELECT new_quote_name FROM tmp_crv_qt_val
WHERE curve_quote_value.curve_id=tmp_crv_qt_val.curve_id 
AND  curve_quote_value.curve_date=tmp_crv_qt_val.curve_date
AND   curve_quote_value.quote_name=tmp_crv_qt_val.orig_quote_name 
AND tmp_crv_qt_val.tmp_basis_swap=1
AND new_quote_name is NOT NULL and tmp_tenor2 is not NULL)
WHERE EXISTS(SELECT curve_id from tmp_crv_qt_val 
WHERE curve_quote_value.curve_id=tmp_crv_qt_val.curve_id 
AND  curve_quote_value.curve_date=tmp_crv_qt_val.curve_date
AND  curve_quote_value.quote_name=tmp_crv_qt_val.orig_quote_name 
AND  tmp_basis_swap=1 
AND  new_quote_name is NOT NULL and tmp_tenor2 is not NULL)
go




/****************************************************/
/* Now do the Count(*) from curve_quote_value table */
/****************************************************/
DECLARE @curve_quote_value_count INT
DECLARE @count_quote_valuestr VARCHAR(255)
SELECT @curve_quote_value_count=count(*)  FROM curve_quote_value
print '36)Count of Table Curve_Quote_Value After Updating the Main Columns'
SELECT @count_quote_valuestr=convert(varchar,@curve_quote_value_count)
print @count_quote_valuestr
go

DROP TABLE tmp_cu_basis_swap
go

DROP TABLE tmp_crv_qt_val
go
