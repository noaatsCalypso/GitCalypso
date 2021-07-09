/*  Bug No 11092   */
/*  This Script just take care of adding the source name to the basis swap quote if not present  */
/*  There is separate Script for Currency bug  */
/*  This Script should be ran only once */
spool output.txt
;

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
;

 

/*  Assuming the case when quote_name does not contains the currency. */ 
DELETE FROM tmp_cu_basis_swap
;

INSERT INTO tmp_cu_basis_swap(cu_id,base_rate_index,basis_rate_index,tmp_rate_index1,tmp_rate_index2,tmp_tenor1,tmp_tenor2,tmp_source1,tmp_source2,tmp_currency1,tmp_currency2,maturity_tenor)
SELECT cu_id,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,base_rate_index,basis_rate_index,maturity_tenor FROM cu_basis_swap
;


/* ****CURRENCY ****** */
/* ****Currency 1 ****** */
UPDATE tmp_cu_basis_swap
SET tmp_currency1=substr(tmp_currency1,1,instr(tmp_currency1,'/')-1)
;

/* ****Currency 2 ****** */
UPDATE tmp_cu_basis_swap
SET tmp_currency2=substr(tmp_currency2,1,instr(tmp_currency2,'/')-1)
;

/* ****Rate INDEX 1 ****** */
/*  remove the currency1  */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index1=substr(tmp_rate_index1,instr(tmp_rate_index1,'/')+1,length(tmp_rate_index1)-instr(tmp_rate_index1,'/'))
;

/*  get the rate_index1   */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index1=substr(tmp_rate_index1,1,instr(tmp_rate_index1,'/')-1)
;

/* ****Rate INDEX 2 ****** */
/*  remove the currency2  */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index2=substr(tmp_rate_index2,instr(tmp_rate_index2,'/')+1,length(tmp_rate_index2)-instr(tmp_rate_index2,'/'))
;


/*  get the rate_index 2   */ 
UPDATE tmp_cu_basis_swap
SET tmp_rate_index2=substr(tmp_rate_index2,1,instr(tmp_rate_index2,'/')-1)
;


/* ****Tenor 1 ****** */
/*  remove the curreny  from tmp_tenor1 */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substr(tmp_tenor1,instr(tmp_tenor1,'/')+1,length(tmp_tenor1)-instr(tmp_tenor1,'/'))
;
/*  remove the curreny from tmp_tenor1 */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substr(tmp_tenor1,instr(tmp_tenor1,'/')+1,length(tmp_tenor1)-instr(tmp_tenor1,'/'))
;


/*  get the actual tenor */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor1=substr(tmp_tenor1,1,instr(tmp_tenor1,'/')-1)
;

/* ****Tenor 2 ****** */
/*  remove the curreny  from tmp_tenor2 */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substr(tmp_tenor2,instr(tmp_tenor2,'/')+1,length(tmp_tenor2)-instr(tmp_tenor2,'/'))
;

/*  remove the curreny from tmp_tenor1 */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substr(tmp_tenor2,instr(tmp_tenor2,'/')+1,length(tmp_tenor2)-instr(tmp_tenor2,'/'))
;

/*  get the actual tenor2 */ 
UPDATE tmp_cu_basis_swap
SET tmp_tenor2=substr(tmp_tenor2,1,instr(tmp_tenor2,'/')-1)
;
/* ****Source 1 ****** */
UPDATE tmp_cu_basis_swap
SET tmp_source1=substr(tmp_source1,instr(tmp_source1,'/')+1,length(tmp_source1)-instr(tmp_source1,'/'))
;
UPDATE tmp_cu_basis_swap
SET tmp_source1=substr(tmp_source1,instr(tmp_source1,'/')+1,length(tmp_source1)-instr(tmp_source1,'/'))
;
UPDATE tmp_cu_basis_swap
SET tmp_source1=substr(tmp_source1,instr(tmp_source1,'/')+1,length(tmp_source1)-instr(tmp_source1,'/'))
;

/* ****Source 2 ****** */
UPDATE tmp_cu_basis_swap
SET tmp_source2=substr(tmp_source2,instr(tmp_source2,'/')+1,length(tmp_source2)-instr(tmp_source2,'/'))
;
UPDATE tmp_cu_basis_swap
SET tmp_source2=substr(tmp_source2,instr(tmp_source2,'/')+1,length(tmp_source2)-instr(tmp_source2,'/'))
;
UPDATE tmp_cu_basis_swap
SET tmp_source2=substr(tmp_source2,instr(tmp_source2,'/')+1,length(tmp_source2)-instr(tmp_source2,'/'))
;


print 'Tmp_cu_swap Operations Completed'
;



/* ************************************************** */
/*  Now do the Count(*) from curve_quote_value table  */
/* ************************************************** */


/*  al;rithm to determine if the swap if cu_swap or cu_basis_swap  */
/* 1)split by /  */
/* 2)get the first part uppto dot.  */
/* 3)check if that field is contain in rate_index table...  */
/*  need to ADD same column in curve_quote_value for performing join...  */
/* ************************************************** */
/*  Change the logic so that it first create tmp_curve_quote_value table  */
/*  and will perform all the operations on it and then   */
/*  copy it on main table  */
/* ************************************************** */
CREATE TABLE tmp_crv_qt_val
	(curve_id int NOT NULL,
	curve_date TimeStamp  NOT NULL,
	quote_name VARCHAR(255) NOT NULL,	
	new_quote_name VARCHAR(255) NULL,	
	orig_quote_name VARCHAR(255) NOT NULL,	
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
;



/* ************************************************** */
/*  Insert just the Swap Records here  */
/*  Insert zero by default in  tmp_basis_swap  */
/* ************************************************** */
INSERT INTO tmp_crv_qt_val
(curve_id,curve_date,quote_name,tmp_quote_name,orig_quote_name,tmp_basis_swap)
SELECT curve_id,curve_date,quote_name,quote_name,quote_name,0 FROM curve_quote_value 
WHERE quote_name like 'Swap%'  and curve_id in (select distinct curve_id from curve_member) 
;




UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substr(tmp_quote_name,instr(tmp_quote_name,'/')+1 ,length
(tmp_quote_name)-instr(tmp_quote_name,'/') ) 
;	







/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */
UPDATE tmp_crv_qt_val SET tmp_basis_swap_search=substr(tmp_basis_swap_search,1,instr(tmp_basis_swap_search,'.')-1 ) 
WHERE instr(tmp_basis_swap_search,'.') > 0
;






/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */
UPDATE tmp_crv_qt_val
SET tmp_basis_swap=1
WHERE tmp_basis_swap_search in ( SELECT distinct rate_index_code from rate_index)
or tmp_basis_swap_search in ( SELECT value from domain_values where name='currency')
;	







/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */

/*  Main logic start here  */
/*  Update the tmp_quote_name with original values  */
UPDATE tmp_crv_qt_val
SET tmp_quote_name=quote_name
WHERE tmp_basis_swap=1
;	








/*  remove the first part dot  */
/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */
/*  Remove the Swap.  from tmp_quote_name  */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1 ,length
(tmp_quote_name)-instr(tmp_quote_name,'.') ) 
WHERE  tmp_basis_swap=1
;	

/*  UPDATE the maturity part tenor  */
UPDATE tmp_crv_qt_val SET tmp_maturity_tenorstr=substr(tmp_quote_name,1 ,instr(tmp_quote_name,'.') )
WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and tmp_maturity_tenorstr is NULL
;


/*  remove the second part dot  */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1 ,length
(tmp_quote_name)-instr(tmp_quote_name,'.') ) 
WHERE tmp_basis_swap=1
;	






/* here need to take care of currency add it if not present  */
/*  Update the Currency1   */
UPDATE tmp_crv_qt_val
SET tmp_currency1=substr(tmp_quote_name,1 ,instr(tmp_quote_name,'.')-1 ) 
WHERE quote_name like 'Swap%' 
AND tmp_basis_swap=1 
AND substr(tmp_quote_name,1 ,instr(tmp_quote_name,'.')-1 )  IN ( SELECT value FROM domain_values WHERE name='currency' )
AND tmp_currency1 is NULL
;	







/* update here currency temporarily with TMP  */
UPDATE tmp_crv_qt_val SET tmp_quote_name='TMP' || '.' || tmp_quote_name
WHERE tmp_currency1 is NULL AND quote_name like 'Swap%' AND tmp_basis_swap=1 
AND instr(tmp_quote_name,'TMP') <= 0 
;	




/*  get the currency   */
UPDATE tmp_crv_qt_val
SET tmp_currency1=substr(tmp_quote_name,1,instr(tmp_quote_name,'.')-1)
WHERE quote_name like 'Swap%' AND tmp_basis_swap=1 AND tmp_currency1 is NULL
;	





/*  remove the currency   */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1 ,length
(tmp_quote_name)-instr(tmp_quote_name,'.') ) 
WHERE tmp_basis_swap=1
;


UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=TO_NUMBER(substr(tmp_maturity_tenorstr,1,instr(tmp_maturity_tenorstr,'Y')-1)) * 360
WHERE quote_name like 'Swap%' 
AND tmp_basis_swap=1 
AND instr(tmp_maturity_tenorstr,'Y') > 0 
AND tmp_maturity_tenor is NULL
;	




UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=TO_NUMBER(substr(tmp_maturity_tenorstr,1,instr(tmp_maturity_tenorstr,'M')-1)) * 30
WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and instr(tmp_maturity_tenorstr,'M') > 0 AND tmp_maturity_tenor is NULL
;	




UPDATE tmp_crv_qt_val SET tmp_maturity_tenor=TO_NUMBER(substr(tmp_maturity_tenorstr,1,instr(tmp_maturity_tenorstr,'W')-1)) * 7
WHERE quote_name like 'Swap%' and tmp_basis_swap=1 and instr(tmp_maturity_tenorstr,'W') > 0 AND tmp_maturity_tenor is NULL
;	









/*  get the rate index  */
UPDATE tmp_crv_qt_val
SET tmp_rate_index1=substr(tmp_quote_name,1,instr(tmp_quote_name,'.')-1)
WHERE tmp_basis_swap=1 AND tmp_rate_index1 is NULL
;	




/*  remove the rate index   */
UPDATE tmp_crv_qt_val SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1 ,length
(tmp_quote_name)-instr(tmp_quote_name,'.') ) 
WHERE quote_name like 'Swap%' AND tmp_basis_swap=1
;	






/*  update the tenor1  */
UPDATE tmp_crv_qt_val set tmp_tenor1=substr(tmp_quote_name,1,instr(tmp_quote_name,'/')-1)
WHERE tmp_basis_swap=1 AND tmp_tenor1 is NULL
;	






/*  Get the Second half of Quote name for getting values like tmp_currency2,tmp_rate_index2  */
UPDATE tmp_crv_qt_val 
SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'/')+1,length(tmp_quote_name)-instr(tmp_quote_name,'/'))
WHERE tmp_basis_swap=1
;	






/* here need to take care of currency add it if not present  */
/*  Update the Currency2   */
UPDATE tmp_crv_qt_val
SET tmp_currency2=substr(tmp_quote_name,1 ,instr(tmp_quote_name,'.')-1 ) 
WHERE tmp_basis_swap=1 
AND substr(tmp_quote_name,1 ,instr(tmp_quote_name,'.')-1 )  IN ( SELECT value FROM domain_values WHERE name='currency' )
AND tmp_currency2 is NULL
;	



/*  check here if it is currency 2  */
UPDATE tmp_crv_qt_val
SET tmp_currency2='TMP' 
WHERE  tmp_basis_swap=1 	AND tmp_currency2 is NULL
;	



/*  Get the Currency 2 actual or TMP  */
UPDATE tmp_crv_qt_val
SET tmp_currency2=substr(tmp_quote_name,1,instr(tmp_quote_name,'.')-1) 
WHERE substr(tmp_quote_name,1,instr(tmp_quote_name,'.')-1) in (Select value from domain_values where name='currency')
AND tmp_basis_swap=1 
;	








/*  append the tmp currency if not present  */ 
UPDATE tmp_crv_qt_val
SET tmp_quote_name='TMP'||'.'|| tmp_quote_name
WHERE tmp_currency2 ='TMP' 
AND tmp_basis_swap=1 AND instr(tmp_quote_name,'TMP') =0	
;	







/*  remove the second currency where real or TMP  */
/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */
UPDATE tmp_crv_qt_val
SET tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1 ,
length(tmp_quote_name)-instr(tmp_quote_name,'.') ) 
WHERE tmp_basis_swap=1	
;	




/*  get the second rate_index  */
UPDATE tmp_crv_qt_val 
SET tmp_rate_index2=substr(tmp_quote_name,1,instr(tmp_quote_name,'.')-1)
WHERE tmp_basis_swap=1 AND tmp_rate_index2 is NULL
;	



/*  remove the second rate_index  */
/* ************************************************** */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/* ************************************************** */
UPDATE tmp_crv_qt_val set tmp_quote_name=substr(tmp_quote_name,instr(tmp_quote_name,'.')+1,
length(tmp_quote_name)-instr(tmp_quote_name,'.'))
WHERE tmp_basis_swap=1
;	




/* ************************************************** */
/*  Update tmp_tenor2 with   */
/* ************************************************** */
UPDATE tmp_crv_qt_val set tmp_tenor2=tmp_quote_name
WHERE tmp_basis_swap=1  and instr(tmp_quote_name,'.') = 0 
;	






/*  update the currency  for that case. in curve quote value table.  */
/*  for the case when base currency is different from basis currency  */
/*  COMMENTED FOR CURRENCY BUG  */
UPDATE tmp_crv_qt_val SET   
quote_name ='Swap'||'.'|| tmp_currency1 || '.' || tmp_maturity_tenorstr ||  tmp_rate_index1 ||'.'|| 
tmp_tenor1 || '/' || tmp_currency2 || '.' || tmp_rate_index2 || '.' || tmp_tenor2  
WHERE tmp_currency2 <> 'TMP' 
;








/*  for the case when base currency is same from basis currency   */
/*  TMP is there in bases currency  */
UPDATE tmp_crv_qt_val SET  
quote_name ='Swap'||'.'|| tmp_currency1 || '.' || tmp_maturity_tenorstr  || 
tmp_rate_index1 ||'.'||
tmp_tenor1 || '/'  || tmp_rate_index2 || '.' || tmp_tenor2 
WHERE tmp_currency2 = 'TMP'
;	





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
;








/*  replace the TMP with actual basis currency  */
/*  currency bug should be solved here  */
UPDATE tmp_crv_qt_val SET  
quote_name =replace(quote_name,'TMP',basis_currency)
WHERE tmp_currency1 = 'TMP' and tmp_basis_swap=1
;






/*  **************************************************  */
/*  HERE WE CANNOT APPLY ROWCOUNT stuff  */
/*  For currency Bug replace orig_quote_name with new_quote_name i.e later   */
/*  **************************************************  */
/*  Checking to tmp_tenor2 is not NULL ensure that if quote_name already contains the source name then it won't update again  */
/*  update the source name  */
UPDATE tmp_crv_qt_val SET new_quote_name=orig_quote_name || '.' || ( select tmp_source2
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
;	





/* ************************************************** */
/*  Update here original Quote Name  */
/* ************************************************** */
/*  update the source name */
/* ************************************************** */
/*  Now here we update back the Original Table curve_quote_value  */
/*  Checking to tmp_tenor2 is not NULL ensure that if quote_name already contains the source name then it won't update again  */
/*  update the source name */
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
;




DROP TABLE tmp_cu_basis_swap
;

DROP TABLE tmp_crv_qt_val
;
 
commit
;

spool off
;
