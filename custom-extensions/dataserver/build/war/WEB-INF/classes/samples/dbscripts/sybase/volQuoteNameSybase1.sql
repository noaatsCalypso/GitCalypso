CREATE PROCEDURE sp_updateQuoteName
AS
BEGIN

-- T1 is creating by VolQuoteNameSybase0

--Adaptive Server has expanded all '*' elements in the following statement
select vol_surf_qtvalue.vol_surface_id, vol_surf_qtvalue.vol_surface_date, vol_surf_qtvalue.quote_name, vol_surf_qtvalue.quote_type, vol_surf_qtvalue.bid, 
vol_surf_qtvalue.ask, vol_surf_qtvalue.bid_adjustment, vol_surf_qtvalue.ask_adjustment 
into vol_surf_qtvalue_BACKUP
from vol_surf_qtvalue



--Adaptive Server has expanded all '*' elements in the following statement
select vol_quote_adj.vol_surface_id, vol_quote_adj.vol_surface_date, vol_quote_adj.quote_name, vol_quote_adj.adj_name, vol_quote_adj.adj_value 
into vol_quote_adj_BACKUP
from vol_quote_adj

DECLARE
c1 CURSOR FOR SELECT quote_name,vol_surface_id, vol_surf_und_id, vol_surface_date, source, strike_rel_b 
from t1

OPEN c1

DECLARE @qtSubString1 VARCHAR(255)
DECLARE @qtSubString2 VARCHAR(255)
DECLARE @qtNewName    VARCHAR(255)
DECLARE @quote_name   VARCHAR(255)
DECLARE @vol_surface_id integer
DECLARE @vol_surf_und_id integer
DECLARE @vol_surface_date datetime
DECLARE @source VARCHAR(255)
DECLARE @strikerelb bit
DECLARE @v_sql VARCHAR(255)

FETCH c1 INTO @quote_name, @vol_surface_id, @vol_surf_und_id, @vol_surface_date, @source, @strikerelb
WHILE  (@@sqlstatus=0)
BEGIN
-- STRING BUILDING FOR CAP
        IF patindex('Cap.%', @quote_name) = 1 OR patindex('Floor.%', @quote_name) = 1 
        BEGIN
            SELECT @qtSubString1 =   substring(@quote_name, 1, char_length(@quote_name) - patindex('%.[D,W,M,Y][0-9]%', reverse(@quote_name))+1)
            SELECT @qtSubString2 =   substring(@quote_name, char_length(@quote_name) - patindex('%.[D,W,M,Y][0-9]%',reverse(@quote_name)) +2, 			
	 char_length(@quote_name))
            IF @strikerelb = 1
                SELECT @qtNewName = @qtSubString1+'R'+@qtSubString2+'.'+@source
            ELSE
                SELECT @qtNewName = @qtSubString1+@qtSubString2+'.'+@source
        END
        ELSE
-- STRING BUILDING FOR SAPTION
        BEGIN
            SELECT @qtSubString1 = substring(@quote_name, 1,char_length(@quote_name) - PATINDEX('%.[D,W,M,Y]%', reverse(@quote_name)))
            SELECT @qtSubString2 = substring(@quote_name, char_length(@quote_name) - PATINDEX('%.[D,W,M,Y]%', reverse(@quote_name))+2, 			
	char_length(@quote_name))
            IF @strikerelb = 1
                SELECT @qtNewName = @qtSubString1+'.'+@source+'.R'+@qtSubString2
            ELSE
                SELECT @qtNewName = @qtSubString1+'.'+@source+'.'+@qtSubString2
        END
        
          --SELECT @v_sql = 'update vol_surf_und set quote_name = '+char(39)+@qtNewName+char(39)+' where vol_surf_und_id = '+ convert(varchar, 
--@vol_surf_und_id)
--       print @v_sql
--       exec (@v_sql)

        SELECT @v_sql = 'update vol_surf_qtvalue set quote_name = '+char(39)+@qtNewName+char(39)+' where vol_surface_id = '
                                         + convert(varchar, @vol_surface_id)+  ' and quote_name = '+char(39)+@quote_name+char(39)+' and convert(varchar(19),vol_surface_date,0) = '
                                         + char(39)+convert(varchar(19), @vol_surface_date,0) +char(39)
     print @v_sql     
     exec (@v_sql) 
    
       
       SELECT @v_sql = 'update vol_quote_adj set quote_name = '+char(39)+@qtNewName+char(39)+' where vol_surface_id = '
                                         + convert(varchar, @vol_surface_id)+ ' and quote_name = '+char(39)+@quote_name+char(39)+' and convert(varchar(19),vol_surface_date,0) = '  
                                         +char(39)+convert(varchar(19), @vol_surface_date,0) +char(39)
     print @v_sql        
     exec (@v_sql)      

FETCH c1 INTO @quote_name, @vol_surface_id, @vol_surf_und_id, @vol_surface_date, @source, @strikerelb
END
CLOSE c1
DEALLOCATE CURSOR c1
DROP TABLE t1

END

exec sp_procxmode 'sp_updateQuoteName', 'anymode'
go
exec sp_updateQuoteName
go
DROP PROCEDURE sp_updateQuoteName
go