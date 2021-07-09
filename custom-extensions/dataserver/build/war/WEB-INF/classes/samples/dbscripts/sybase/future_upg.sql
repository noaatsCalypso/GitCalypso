/* Bug No 10388 */
/* Old Quote Name => Future.XXX.XXXX.XX.XX  */
/* New Quote Name => Future.CURRENCY.XXX.XXXX.XX.XX  */
/* This Script has to run using iSQL */

DECLARE quote_crsr CURSOR
FOR SELECT quote_name
FROM quote_value
WHERE quote_name like 'Future.%'  
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
declare @currencyCode VARCHAR(255)
declare @countvar int

select @countvar=0

FETCH quote_crsr INTO @QuoteName

WHILE (@@sqlstatus=0)
BEGIN
	SELECT @tmpQuoteName1=@QuoteName
	SELECT @countvar=@countvar+1

	SELECT @firstPart=substring(@tmpQuoteName1,1,charindex('.',@tmpQuoteName1)-1)



	SELECT @tmpQuoteName=substring(@QuoteName,charindex('.',@QuoteName)+1 ,char_length(@QuoteName)-charindex(@QuoteName,'.') )



	SELECT @tmpQuoteName1=@tmpQuoteName
	SELECT @secondPart=substring(@tmpQuoteName1,1,charindex('.',@tmpQuoteName1)-1)



	SELECT @remaningPart=substring(@tmpQuoteName1,charindex('.',@tmpQuoteName1)+1 ,char_length(@tmpQuoteName1)-charindex(@tmpQuoteName1,'.') )


	SELECT @remaningPart=substring(@remaningPart,charindex('.',@remaningPart)+1 ,char_length(@remaningPart)-charindex(@remaningPart,'.') )


	SELECT @tmpQuoteName=substring(@tmpQuoteName,charindex('.',@tmpQuoteName)+1 ,char_length(@tmpQuoteName)-charindex(@tmpQuoteName,'.') ) 				


	SELECT @contractName=substring(@tmpQuoteName,1,charindex('.',@tmpQuoteName)-1)

	if Exists(SELECT currency_code FROM future_contract WHERE contract_name=@contractName and future_type='EquityIndex')  
	Begin
		SELECT @currencyCode=currency_code FROM future_contract WHERE contract_name=@contractName and future_type='EquityIndex'

		SELECT @newQuoteName=@firstPart+'.'+@currencyCode+'.'+@secondPart+'.'+@contractName+'.'+@remaningPart
		
		UPDATE quote_value
		SET quote_name=@newQuoteName
		WHERE CURRENT OF quote_crsr 
	
		print 'Old Quote Name '
		print @tmpQuoteName1
		print 'New Quote Name '
		print @newQuoteName
	End 

	FETCH quote_crsr INTO @QuoteName

END
CLOSE quote_crsr
DEALLOCATE CURSOR quote_crsr
go
END