CREATE OR REPLACE PROCEDURE add_column_if_not_exists
    (tab_name IN user_tab_columns.table_name%TYPE,
     col_name IN user_tab_columns.column_name%TYPE,
     data_type IN varchar2)
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 0 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' add '||col_name||' '||data_type;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE drop_function ( proc_name IN user_tab_columns.table_name%TYPE) AS
 x number;
BEGIN
   BEGIN
   SELECT count(*) into x FROM user_objects WHERE object_name=UPPER(proc_name) and object_type= 'FUNCTION';
   exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x > 0 THEN
       EXECUTE IMMEDIATE 'drop function '|| proc_name;
    END IF;
END drop_function;
/

CREATE OR REPLACE PROCEDURE drop_column_if_exists
    (tab_name IN user_tab_columns.table_name%TYPE,
     col_name IN user_tab_columns.column_name%TYPE)
AS
    x number;
BEGIN
    begin
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x > 0 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' drop column '||col_name;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE add_domain_values (dname IN varchar2, dvalue in varchar2, ddescription in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM domain_values WHERE name= dname and value= dvalue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
        if x = 1 then
                execute immediate 'delete from domain_values where name='||chr(39)||dname||chr(39)||' and value ='||chr(39)||dvalue||chr(39);
                execute immediate 'insert into domain_values ( name, value, description )
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
        elsif x=0 THEN
	        execute immediate 'insert into domain_values ( name, value, description ) 
                VALUES ('||chr(39)||dname||chr(39)||','||chr(39)||dvalue||chr(39)||','||chr(39)||ddescription||chr(39)||')';
    END IF;
END add_domain_values;
/

CREATE OR REPLACE PROCEDURE delete_domain_values (dname IN varchar2, dvalue in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM domain_values WHERE name= dname and value= dvalue;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
        if x = 1 then
                execute immediate 'delete from domain_values where name='||chr(39)||dname||chr(39)||' and value ='||chr(39)||dvalue||chr(39);
        
    END IF;
END delete_domain_values;
/


CREATE OR REPLACE PROCEDURE drop_fk_on_table (tab_name IN varchar2) AS
BEGIN
   DECLARE cursor c1 IS 
      SELECT table_name, constraint_name FROM user_constraints WHERE constraint_type = 'R' AND table_name=UPPER(tab_name);
   v_sql varchar2(128);
   BEGIN
      FOR c1_rec IN c1 LOOP 
         v_sql := 'ALTER TABLE '||c1_rec.table_name||' DROP CONSTRAINT '||c1_rec.constraint_name;
         EXECUTE IMMEDIATE v_sql;
      END LOOP;
   END;
END;
/

CREATE OR REPLACE PROCEDURE drop_pk_if_exists (tab_name IN varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM user_constraints WHERE table_name=UPPER(tab_name) and constraint_type= 'P';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
    IF x > 0 THEN
       EXECUTE IMMEDIATE 'ALTER TABLE ' ||tab_name||' DROP PRIMARY KEY DROP INDEX';
    END IF;
END drop_pk_if_exists;
/

CREATE OR REPLACE PROCEDURE drop_uk_if_exists (tab_name IN varchar2) AS
x varchar2(100) ;
BEGIN
   BEGIN
   SELECT  c.constraint_name INTO x FROM user_constraints c, user_tables t WHERE t.table_name=UPPER(tab_name) 
   and c.constraint_type= 'U' and t.table_name=c.table_name;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:='0';
      WHEN others THEN
         null;
    END;
    IF x != '0' THEN
       EXECUTE IMMEDIATE 'ALTER TABLE ' ||tab_name||' DROP constraint '||x;
    END IF;
END drop_uk_if_exists;
/
CREATE OR REPLACE PROCEDURE drop_procedure_if_exists

    (proc_name IN user_objects.object_name%TYPE)

AS

    x number;

BEGIN

    begin

    select count(*) INTO x FROM user_objects WHERE object_name=UPPER(proc_name) and object_type = 'PROCEDURE';

    exception

        when NO_DATA_FOUND THEN

        x:=0;

        when others then

        null;

    end;

    IF x > 0 THEN

        EXECUTE IMMEDIATE 'drop procedure ' || UPPER(proc_name);

    END IF;

END drop_procedure_if_exists;

/

CREATE OR REPLACE PROCEDURE drop_uq_on_table (tab_name IN varchar2) AS
BEGIN
   DECLARE cursor c1 IS 
      SELECT table_name, constraint_name FROM user_constraints WHERE constraint_type = 'U' AND table_name=UPPER(tab_name);
   v_sql varchar2(128);
   BEGIN
      FOR c1_rec IN c1 LOOP 
         v_sql := 'ALTER TABLE '||c1_rec.table_name||' DROP CONSTRAINT '||c1_rec.constraint_name;
         EXECUTE IMMEDIATE v_sql;
      END LOOP;
   END;
END;
;

CREATE OR REPLACE PROCEDURE drop_unique_if_exists (tab_name IN varchar2) AS
constraint_name varchar2(255);
BEGIN
   BEGIN
   SELECT constraint_name INTO constraint_name FROM user_constraints WHERE table_name=UPPER(tab_name) and constraint_type= 'U';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         constraint_name := NULL;
      WHEN others THEN
         null;
    END;
    IF constraint_name IS NOT NULL THEN
       EXECUTE IMMEDIATE 'ALTER TABLE ' ||tab_name||' DROP CONSTRAINT ' || constraint_name || ' DROP INDEX';
    END IF;
END drop_unique_if_exists;
;

CREATE OR REPLACE PROCEDURE drop_table_if_exists
    (tab_name IN varchar2)
AS
    x number :=0 ;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER(tab_name) ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x > 0 THEN
EXECUTE IMMEDIATE 'drop table ' ||tab_name;
END IF;
END drop_table_if_exists;
/
CREATE OR REPLACE PROCEDURE add_pk_if_not_exists (tab_name IN varchar2, pk_name in varchar2, c_name in varchar2) AS
x number :=0 ;
BEGIN
   BEGIN
   SELECT count(*) INTO x FROM user_constraints WHERE table_name=UPPER(tab_name) and constraint_type= 'P';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         x:=0;
      WHEN others THEN
         null;
    END;
    IF x = 0 THEN
       EXECUTE IMMEDIATE 'ALTER TABLE ' ||tab_name||' add constraint '||pk_name||' primary key ('||c_name||')';
    END IF;
END add_pk_if_not_exists;
/

CREATE OR REPLACE
TYPE list_of_names_t IS  
   TABLE of VARCHAR2(100);
/
   
CREATE OR REPLACE
PROCEDURE run_query_if_tables_exist
    (tab_names IN list_of_names_t, query IN varchar2)
AS
    x number :=0 ;
    y number :=0 ;
BEGIN
	BEGIN
		select count(*) INTO x FROM table(tab_names);
		select count(*) INTO y FROM user_tables WHERE table_name in (select * from table(tab_names));
	END;
	IF x = y THEN
		EXECUTE IMMEDIATE query;
	END IF;
END run_query_if_tables_exist;
/
CREATE OR REPLACE PROCEDURE rename_column_if_exists
    (tab_name IN user_tab_columns.table_name%TYPE,
     col_name IN user_tab_columns.column_name%TYPE,
     new_col_name IN varchar2)
AS
    x number;
	y number;
BEGIN
    begin 
    select count(*) INTO x FROM user_tab_columns WHERE table_name=UPPER(tab_name) and column_name=upper(col_name);
    exception
        when NO_DATA_FOUND THEN
        x:=0;
        when others then
        null;
    end;
    IF x = 1 THEN
        EXECUTE IMMEDIATE 'alter table ' || tab_name || ' rename  column '||col_name||' to '||new_col_name;
    END IF;
END;
/