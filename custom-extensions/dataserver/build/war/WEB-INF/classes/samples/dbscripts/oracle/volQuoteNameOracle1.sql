-- notes on the functions used :
-- 
-- instr (string_to_be_searched, what_im_looking_for, start_pos, nth appearance)
-- substr (string_to_be_searched, start_pos, no_of_chars_after_start_pos)
-- occurs (what_im_looking_for, string_to_be_searched)
--
-- ** NOTE THAT THE "OCCURS" FUNCTION NEEDS TO BE SEPERATELY COMPILED ** 
--
--
create or replace function OCCURS
  (cSearchExpression   nvarchar2, cExpressionSearched nvarchar2)
return smallint
deterministic
as
        occurs          smallint :=  0;
        start_location  smallint :=  instr(cExpressionSearched, cSearchExpression);
begin
  if  cExpressionSearched is not null and cSearchExpression is not null then
        while  start_location  >  0 loop
                occurs  :=  occurs + 1;
                start_location := instr(cExpressionSearched, cSearchExpression, start_location + 1);
        end loop;
  end if;
 return  occurs;
end OCCURS;
/



drop table t1
;

create table t1 as
    (SELECT und.quote_name, vsm.vol_surface_id, und.vol_surf_und_id, vsm.vol_surface_date,  SUBSTR(cap.rate_index, INSTR(cap.rate_index, '/', -1, 1)+1, length(cap.rate_index)) source, cap.strike_rel_b, cap.start_tenor
               FROM vol_surf_und und, vol_surf_und_cap cap,  vol_surface_member vsm
               WHERE
                 und.vol_surf_und_id = cap.vol_surf_und_id
		 AND vsm.vol_surf_und_id = und.vol_surf_und_id)
;


insert into t1 (quote_name, vol_surface_id, vol_surf_und_id, vol_surface_date, source, strike_rel_b, start_tenor)
    SELECT und.quote_name, vsm.vol_surface_id, und.vol_surf_und_id, vsm.vol_surface_date,  SUBSTR(swp.rate_index, INSTR(swp.rate_index, '/', -1, 1)+1, length(swp.rate_index)), swp.fixed_rate_rel_b,0
               FROM vol_surf_und und, vol_surf_und_swpt swp, vol_surface_member vsm
               WHERE
                und.vol_surf_und_id = swp.vol_surf_und_id
	       AND vsm.vol_surf_und_id = und.vol_surf_und_id
;

commit
;
--

--select * from t1
--;

create table vol_surf_und_BACKUP as select * from  vol_surf_und
;

create table vol_surf_qtvalue_BACKUP as select * from vol_surf_qtvalue
;

create table vol_quote_adj_BACKUP as select * from vol_quote_adj
;


create or replace procedure t2                                 
AS
begin
declare
  cursor c1 is SELECT rowid, quote_name,vol_surface_id,vol_surface_date, vol_surf_und_id, source, strike_rel_b,start_tenor from t1;                     
  v_sql varchar2(512);
  v_pos number;
  v_str1 varchar2(132);
  v_str2 varchar2(132);
  v_new_quote_name varchar2(128);
  v_new varchar2(132);
  v_start number;
begin


for c1_rec in c1 LOOP
    v_start := 3;
    if c1_rec.start_tenor !=0 then
      v_start := 4;
   end if;

 if occurs('Cap.',c1_rec.quote_name) = 1 or occurs('Floor.',c1_rec.quote_name) = 1 then
    v_str1 := substr(c1_rec.quote_name,1,(instr(c1_rec.quote_name,'.',1,v_start)));
    v_str2 := substr(c1_rec.quote_name,instr(c1_rec.quote_name,'.',1,v_start)+1,length(c1_rec.quote_name));

          if c1_rec.strike_rel_b = 1 then
            v_new_quote_name := v_str1||'R'||v_str2||'.'||c1_rec.source;
             else
            v_new_quote_name := v_str1||v_str2||'.'||c1_rec.source;
          end if;
  else 
    v_str1 := substr(c1_rec.quote_name,1,(instr(c1_rec.quote_name,'.',1,7)));
    v_str2 := substr(c1_rec.quote_name,instr(c1_rec.quote_name,'.',1,7)+1,length(c1_rec.quote_name));

          if c1_rec.strike_rel_b = 1 then
            v_new_quote_name := v_str1||c1_rec.source||'.R'||v_str2;
             else
            v_new_quote_name := v_str1||c1_rec.source||'.'||v_str2;
          end if;
        
end if;


    v_sql := 'update vol_surf_und set quote_name = '||chr(39)||v_new_quote_name||chr(39)||' where vol_surf_und_id = '||c1_rec.vol_surf_und_id;
--    dbms_output.put_line(v_sql);
    execute immediate v_sql;


     v_sql := 'update vol_surf_qtvalue set quote_name = '||chr(39)||v_new_quote_name||chr(39)||' where vol_surface_id = '||c1_rec.vol_surface_id||
		' and quote_name = '||chr(39)||c1_rec.quote_name||chr(39)||' and vol_surface_date = '||chr(39)||c1_rec.vol_surface_date||chr(39);
 --   dbms_output.put_line(v_sql);
     execute immediate v_sql;


     v_sql := 'update vol_quote_adj set quote_name = '||chr(39)||v_new_quote_name||chr(39)||' where vol_surface_id = '||c1_rec.vol_surface_id||
		' and quote_name = '||chr(39)||c1_rec.quote_name||chr(39)||' and vol_surface_date = '||chr(39)||c1_rec.vol_surface_date||chr(39);
  --  dbms_output.put_line(v_sql);
     execute immediate v_sql;


END LOOP;
commit;

end;
end;
/

show errors
begin
   t2;
end;
/