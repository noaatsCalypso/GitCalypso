CREATE PROCEDURE sp_updateQuoteName
AS
BEGIN

CREATE TABLE t1(
quote_name varchar(255),
vol_surface_id integer,
vol_surf_und_id integer,
vol_surface_date datetime,
source varchar(255),
strike_rel_b bit
)

insert into t1 (quote_name, vol_surface_id, vol_surf_und_id, vol_surface_date, source, strike_rel_b)
SELECT und.quote_name, vsm.vol_surface_id, und.vol_surf_und_id, 
       vsm.vol_surface_date,  right(cap.rate_index, charindex('/', reverse(cap.rate_index))-1), cap.strike_rel_b
FROM   vol_surf_und und, vol_surf_und_cap cap,  vol_surface_member vsm
WHERE
       und.vol_surf_und_id = cap.vol_surf_und_id
AND    vsm.vol_surf_und_id = und.vol_surf_und_id


insert into t1 (quote_name, vol_surface_id, vol_surf_und_id, vol_surface_date, source, strike_rel_b)
SELECT und.quote_name, vsm.vol_surface_id, und.vol_surf_und_id, vsm.vol_surface_date,  
right(swp.rate_index, charindex('/', reverse(swp.rate_index))-1), 
swp.fixed_rate_rel_b
FROM vol_surf_und und, vol_surf_und_swpt swp, vol_surface_member vsm
WHERE
und.vol_surf_und_id = swp.vol_surf_und_id
AND vsm.vol_surf_und_id = und.vol_surf_und_id

CREATE TABLE t2(
quote_name varchar(255),
vol_surf_und_id integer,
source varchar(255),
strike_rel_b bit
)

insert into t2 (quote_name, vol_surf_und_id, source, strike_rel_b)
SELECT und.quote_name, und.vol_surf_und_id, right(cap.rate_index, charindex('/', reverse(cap.rate_index))-1), cap.strike_rel_b
FROM   vol_surf_und und, vol_surf_und_cap cap
WHERE
       und.vol_surf_und_id = cap.vol_surf_und_id
       
insert into t2 (quote_name, vol_surf_und_id, source, strike_rel_b)
SELECT und.quote_name, und.vol_surf_und_id, right(swp.rate_index, charindex('/', reverse(swp.rate_index))-1), 
swp.fixed_rate_rel_b
FROM vol_surf_und und, vol_surf_und_swpt swp
WHERE
und.vol_surf_und_id = swp.vol_surf_und_id

--Adaptive Server has expanded all '*' elements in the following statement
select vol_surf_und.vol_surf_und_id, vol_surf_und.vol_surf_und_type, vol_surf_und.vol_surf_und_cur, vol_surf_und.quote_name, vol_surf_und.version_num 
into vol_surf_und_BACKUP
from  vol_surf_und

DECLARE
c1 CURSOR FOR SELECT quote_name, vol_surf_und_id, source, strike_rel_b 
from t2

OPEN c1

DECLARE @qtSubString1 VARCHAR(255)
DECLARE @qtSubString2 VARCHAR(255)
DECLARE @qtNewName   VARCHAR(255)
DECLARE @quote_name   VARCHAR(255)
DECLARE @vol_surf_und_id integer
DECLARE @source VARCHAR(255)
DECLARE @strikerelb bit
DECLARE @v_sql VARCHAR(255)

FETCH c1 INTO @quote_name, @vol_surf_und_id, @source, @strikerelb
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
        
        SELECT @v_sql = 'update vol_surf_und set quote_name = '+char(39)+@qtNewName+char(39)+' where vol_surf_und_id = '+ convert(varchar, @vol_surf_und_id)
       print @v_sql
       exec (@v_sql)
       
FETCH c1 INTO @quote_name, @vol_surf_und_id, @source, @strikerelb
END
CLOSE c1
DEALLOCATE CURSOR c1

DROP TABLE t2

END 

exec sp_procxmode 'sp_updateQuoteName', 'anymode'
go
exec sp_updateQuoteName
go
DROP PROCEDURE sp_updateQuoteName
go