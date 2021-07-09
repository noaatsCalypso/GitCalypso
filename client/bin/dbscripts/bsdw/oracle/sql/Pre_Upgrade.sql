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

CREATE OR REPLACE PROCEDURE drop_Uk_if_exists (tab_name IN varchar2) AS
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


