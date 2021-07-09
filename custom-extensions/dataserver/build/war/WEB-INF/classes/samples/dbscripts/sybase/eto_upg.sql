/* Bug No 10387 */ 
/* default quote name for ETO needs to include contract name rather then underlying name */
/* This Script has to be Run only once and using ISQL */
/* Also have to make sure there is one ETO Contract per Exchange */

DECLARE quote_crsr CURSOR
FOR SELECT quote_name
FROM quote_value
WHERE quote_name like 'ETOEquity.%'  
or quote_name like 'ETOEquityIndex.%'  
FOR UPDATE OF quote_name
go

open quote_crsr
declare @QuoteName VARCHAR(255)
declare @tmpQuoteName VARCHAR(255)
declare @tmpQuoteName1 VARCHAR(255)
declare @exchangeName VARCHAR(255)
declare @contractName VARCHAR(255)
declare @remaningPart VARCHAR(255)
declare @secondPart VARCHAR(255)
declare @firstPart VARCHAR(255)
declare @newQuoteName VARCHAR(255)
declare @countvar int
declare @curve_id int

declare @str1 VARCHAR(2000)
select @countvar=0

FETCH quote_crsr INTO @QuoteName

WHILE (@@sqlstatus=0)
BEGIN

	SELECT @tmpQuoteName1=@QuoteName
	print 'tmpQuoteName1'
	print @tmpQuoteName1

	SELECT @firstPart=substring(@tmpQuoteName1,1,charindex('.',@tmpQuoteName1)-1)

	print 'firstPart'
	print @firstPart


	SELECT @tmpQuoteName=substring(@QuoteName,charindex('.',@QuoteName)+1 ,char_length(@QuoteName)-charindex(@QuoteName,'.') )

	print 'tmpQuoteName'
	print @tmpQuoteName


	SELECT @tmpQuoteName1=@tmpQuoteName

	SELECT @secondPart=substring(@tmpQuoteName1,1,charindex('.',@tmpQuoteName1)-1)

	print 'secondPart'
	print @secondPart


	SELECT @remaningPart=substring(@tmpQuoteName1,charindex('.',@tmpQuoteName1)+1 ,char_length(@tmpQuoteName1)-charindex(@tmpQuoteName1,'.') )

	print 'remaningPart 1'
	print @remaningPart


	SELECT @remaningPart=substring(@remaningPart,charindex('.',@remaningPart)+1 ,char_length(@remaningPart)-charindex(@remaningPart,'.') )

	print 'remaningPart 2'
	print @remaningPart


	SELECT @tmpQuoteName=substring(@tmpQuoteName,charindex('.',@tmpQuoteName)+1 ,char_length(@tmpQuoteName)-charindex(@tmpQuoteName,'.') ) 				

	print 'tmpQuoteName '
	print @tmpQuoteName

	SELECT @exchangeName=substring(@tmpQuoteName,1,charindex('.',@tmpQuoteName)-1)

	print 'exchangeName '
	print @exchangeName


	SELECT  @contractName=contract_name From eto_contract,legal_entity  WHERE short_name=@exchangeName AND eto_contract.exchange_id=legal_entity.legal_entity_id

	print 'contractName'
	print @contractName


	SELECT @newQuoteName=@firstPart+'.'+@secondPart+'.'+@contractName+'.'+@remaningPart

	print 'newQuoteName'
	print @newQuoteName

	UPDATE quote_value
	SET quote_name=@newQuoteName
	WHERE CURRENT OF quote_crsr 

	UPDATE product_desc
	SET quote_name=@newQuoteName
	WHERE quote_name=@QuoteName
	
	FETCH quote_crsr INTO @QuoteName
	SELECT @countvar=@countvar+1
		
		
END
CLOSE quote_crsr
DEALLOCATE CURSOR quote_crsr
go
END

