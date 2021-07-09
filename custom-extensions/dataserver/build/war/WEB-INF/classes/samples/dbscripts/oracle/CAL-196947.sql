
/* this part of sql is to fix what went wrong in the earlier sql file
create table main_entry_prop_bkgfx14 as select * from main_entry_prop
;
drop table main_entry_prop
;

create table main_entry_prop as select * from main_entry_prop_back14
;


create or replace procedure mainent_schd
as 
  begin
  declare
  v_sql varchar2(512);

  v_prefix_code varchar(16);
  cursor c1 is
  select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskTreeFrame';
  begin
  for c1_rec in c1 LOOP
  
v_prefix_code := substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);
v_sql := 'delete from main_entry_prop
      where user_name = '||chr(39)||c1_rec.user_name||chr(39)||'and property_name like '||chr(39)||chr(37)||v_prefix_code||chr(37)||chr(39); 
                                
execute immediate v_sql;           
                
end loop;
end;
end;
/

begin
mainent_schd;
end;
/
create or replace procedure mainent_schd_new
as 
  begin
  declare
  v_sql varchar(512);
  v_prefix_code varchar(16);
  cursor c1 is
select property_name, user_name,substr(property_name,1,instr(property_name, 'Action')-1),
  property_value from main_entry_prop where property_value = 'refdata.ScheduledTaskWindow';
  begin
  for c1_rec in c1 LOOP
      v_prefix_code := substr(c1_rec.property_name,1,instr(c1_rec.property_name,'Action')-1);

                   v_sql := 'update main_entry_prop set property_value='||chr(39)||'scheduling'||chr(46)||'ScheduledTaskListWindow'||chr(39)||'
      where user_name='||chr(39)||c1_rec.user_name||chr(39)||' and property_value='||chr(39)||c1_rec.property_value||chr(39)||' and property_name IN ('
        ||chr(39)||v_prefix_code||'Action'||chr(39)||','
                                ||chr(39)||v_prefix_code||'Image'||chr(39)||','
                                ||chr(39)||v_prefix_code||'Label'||chr(39)||','
        ||chr(39)||v_prefix_code||'Accelerator'||chr(39)||','
                                ||chr(39)||v_prefix_code||'Mnemonic'||chr(39)||','
                                ||chr(39)||v_prefix_code||'Tooltip'||chr(39)||')';
execute immediate v_sql;
                
       
end loop;
end;
end;
/
begin
mainent_schd_new;
end;
/
drop procedure mainent_schd
;
drop procedure mainent_schd_new
;

/* end */
/* cosmatic changes removing the left over traces of old scheduling engine */

create table me_temp1 (prop_name varchar2(200), user_name varchar2(200))
;
create or replace procedure mainent_submenu
is 
begin
declare 
cursor c1 is 
select user_name,substr(property_name,1,instr(property_name, 'Action')-1) as pro_name from main_entry_prop_back14 where property_value = 'refdata.ScheduledTaskTreeFrame';
pro_name varchar2(200);
v_sql varchar2(500);
begin 
 for c1_rec in c1 LOOP 
 v_sql := 'insert into me_temp1 select property_value , user_name from main_entry_prop_back14 where (property_value like '||chr(39)||c1_rec.pro_name||chr(37)||chr(39)||' or property_value like '||chr(39)||chr(37)|| c1_rec.pro_name ||chr(37)||chr(39)||' 
 or property_value like '||chr(39)||chr(37)||c1_rec.pro_name||chr(39)||')and property_name like '||chr(39)||chr(37)||'SubMenu'||chr(39)|| ' and user_name = '||chr(39)||c1_rec.user_name||chr(39); 
 
execute immediate v_sql;           
                
end loop;
end;
end;
/
begin
mainent_submenu;
end;
/

create sequence seq_id1 start with 1 increment by 1 maxvalue 99999999 minvalue 1 nocycle
;
create sequence seq_id2 start with 1 increment by 1 maxvalue 99999999 minvalue 1 nocycle
;
alter table me_temp1 add n int 
;
update me_temp1 set n = seq_id1.nextval
;
create table me_temp2 (user_name varchar2(200), prop_value varchar2(200) )
;
insert into me_temp2 select user_name, substr(property_name,1,instr(property_name, 'Action')-1) from main_entry_prop_back14 where property_value = 'refdata.ScheduledTaskTreeFrame'
;
alter table me_temp2 add n int 
;
alter table me_temp2 add prop_name varchar2(200) 
;
update me_temp2 set prop_name = (select prop_name from me_temp1 where  me_temp1.n=me_temp2.n)
;
update me_temp2 set n = seq_id2.nextval
;
create or replace procedure mainent_replace_submenu
is
begin
declare
pro_name varchar2(200);
p_name varchar2(200);
v_sql varchar2(500);
v_sql1 varchar2(500);
v_sql2 varchar2(500); 
space1 varchar2(10);                              
cursor c1 is select * from me_temp2;
begin                     
for c1_rec in c1 LOOP 
begin 
v_sql := 'update main_entry_prop 
 set property_value = replace ('||chr(39)||c1_rec.prop_name||chr(39)||','||chr(39)||c1_rec.prop_value||' '||chr(39)||
 ') where property_value like '||chr(39)||c1_rec.prop_value||' '||chr(37)||chr(39)||
 ' and property_name like '||chr(39)||chr(37)||'SubMenu'||chr(39)|| 
 ' and user_name = '||chr(39)||c1_rec.user_name||chr(39); 
 
 execute immediate (v_sql);
 
 v_sql2 := 'update main_entry_prop 
 set property_value = replace ('||chr(39)||c1_rec.prop_name||chr(39)||','||chr(39)||' '||c1_rec.prop_value||chr(39)||
 ') where property_value like '||chr(39)||chr(37)||' '||c1_rec.prop_value||chr(39)||
 ' and property_name like '||chr(39)||chr(37)||'SubMenu'||chr(39)|| 
 ' and user_name = '||chr(39)||c1_rec.user_name||chr(39); 
 
 execute immediate (v_sql2);
space1:=' ';
v_sql1 := 'update main_entry_prop set property_value = replace ('||chr(39)||c1_rec.prop_name||chr(39)||','||chr(39)||space1||c1_rec.prop_value||space1||chr(39)||','||chr(39)||chr(32)||chr(39)||') where property_value like '||chr(39)||chr(37)||space1||c1_rec.prop_value||space1||chr(37)||chr(39)||' and property_name like '||chr(39)||chr(37)||'SubMenu'||chr(39)||' and user_name = '||chr(39)||c1_rec.user_name||chr(39); 
 DBMS_OUTPUT.PUT_LINE(v_sql1);
execute immediate (v_sql1);
end;
end loop;
end;
end;
/
begin
mainent_replace_submenu;
end;
/

drop table me_temp1
;
drop table me_temp2
;
drop procedure mainent_replace_submenu
;
drop procedure mainent_submenu
;
drop sequence seq_id1
;
drop sequence seq_id2
;