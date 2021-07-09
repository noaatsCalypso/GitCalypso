/* script to find user name containing white spaces */
SET SERVEROUTPUT ON SIZE 10000
DECLARE
total INTEGER;
    BEGIN
dbms_output.put_line( 'TABLE_NAME, COLUMN_NAME' );
      FOR t IN (SELECT  table_name, column_name
                  FROM user_tab_columns
                  WHERE column_name='USER_NAME' or column_name='ENTERED_USER' ) 
		LOOP
		EXECUTE IMMEDIATE 
    'SELECT nvl(COUNT(*),0) FROM '||t.table_name||' WHERE upper('||t.column_name||') like '||chr(39)||'% '||chr(39)||' or '||
	' upper('||t.column_name||') like '||chr(39)||' %'||chr(39)
    INTO total;
           IF total > 0  THEN
          dbms_output.put_line( t.table_name ||' '||t.column_name  );
        END IF;
      END LOOP;
    END;
	/
	