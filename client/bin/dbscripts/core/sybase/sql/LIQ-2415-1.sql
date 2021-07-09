 
SELECT i.name
  FROM sysindexes i, sysobjects t
  WHERE t.name = 'ftp_cost_component_rule' AND i.id = t.id AND i.status = 2
go 


drop PROCEDURE drop_unique_if_exists
go
CREATE PROCEDURE drop_unique_if_exists(@arg_table_name VARCHAR(255))
AS
 
  DECLARE @CONSTRAINT_NAME VARCHAR(255)
  DECLARE @SQL VARCHAR(500)
 
 
declare curs cursor for 
  SELECT @CONSTRAINT_NAME = i.name
  FROM sysindexes i, sysobjects t
  WHERE t.name = @arg_table_name AND i.id = t.id AND i.status = 2
  
/* open the cursor */
open curs
 
/* fetch the first row */
fetch curs into @CONSTRAINT_NAME
while (@@sqlstatus != 2)
begin 
 /* SELECT @SQL = 'ALTER TABLE ' + @arg_table_name + ' DROP CONSTRAINT ' + @CONSTRAINT_NAME */
  /* print (@SQL) */
SELECT @SQL = ' Drop index ' + @arg_table_name + '.' + @CONSTRAINT_NAME +  char(10) + @SQL
   /* EXEC (@SQL) */
/* Select @sqlArr[@counter]=@SQL */
fetch curs into @CONSTRAINT_NAME
end
close curs
deallocate cursor curs
print @SQL
 
Execute(@SQL)
GO
 
 
 
exec drop_unique_if_exists 'ftp_cost_component_rule'
go
 
SELECT i.name
  FROM sysindexes i, sysobjects t
  WHERE t.name = 'ftp_cost_component_rule' AND i.id = t.id AND i.status = 2
go 

create index idx_ftp_cs1 on ftp_cost_component_rule(cost_comp_ccy,sd_filter_name,classification_id)
go

create unique index idx_ftp_cs2 on ftp_cost_component_rule(name ,cost_comp_ccy)
go

create unique index idx_ftp_cs3 on ftp_cost_component_rule (cost_comp_ccy,priority)
go
