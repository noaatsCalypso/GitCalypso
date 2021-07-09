

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('char2int')  )
	DROP PROCEDURE char2int
GO

CREATE PROCEDURE char2int
    @tab_name varchar(120),
    @col_name varchar(120),
    @isnull_name varchar(120)
AS
DECLARE @v_sql varchar(512)

BEGIN
    SELECT @v_sql = 'ALTER TABLE ' + @tab_name + ' ADD calypso_temp_col int ' + @isnull_name
    EXEC (@v_sql)
    SELECT @v_sql = 'UPDATE ' + @tab_name + ' SET calypso_temp_col = convert(int, ' + @col_name + ')'
    EXEC (@v_sql)
    SELECT @v_sql = 'ALTER TABLE ' + @tab_name + ' DROP ' + @col_name
    EXEC (@v_sql)
    SELECT @v_sql = 'ALTER TABLE ' + @tab_name + ' ADD ' + @col_name + ' int ' + @isnull_name
    EXEC (@v_sql)
    SELECT @v_sql = 'UPDATE ' + @tab_name + ' SET ' + @col_name + ' = calypso_temp_col'
    EXEC (@v_sql)
    SELECT @v_sql = 'ALTER TABLE ' + @tab_name + ' DROP calypso_temp_col'
    EXEC (@v_sql)
END
GO

BEGIN
  EXEC char2int 'ers_log','isexception', 'NULL'
END
GO

BEGIN
  EXEC char2int 'ers_result_history', 'is_packed', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run', 'is_live', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run','is_packed', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run_history','is_live', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run_history','is_packed', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run_param','trade_explode', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
    EXEC char2int 'ers_run_param','asofdate', 'DEFAULT 0 NOT NULL'
END
GO

BEGIN
	DROP PROCEDURE char2int
END
GO
