
create or replace
PROCEDURE drop_Uk_if_exists (tab_name IN varchar2) AS
BEGIN
   declare
    cursor c1 is
          SELECT  c.index_name  FROM user_indexes c, user_tables t WHERE t.table_name=UPPER(tab_name)  and t.table_name=c.table_name 
              and not exists(select 1 from user_constraints t1 where t1.index_name = c.index_name);
   BEGIN
       for c1_rec in c1 loop
              EXECUTE IMMEDIATE ' DROP index '||c1_rec.index_name;       
          end loop;
    END;
END drop_uk_if_exists;
/

begin
 drop_uk_if_exists('ftp_cost_component_rule');
end;
/

create index idx_ftp_cs1 on ftp_cost_component_rule(cost_comp_ccy,sd_filter_name,classification_id)
;

create unique index idx_ftp_cs2 on ftp_cost_component_rule(name ,cost_comp_ccy)
;

create unique index idx_ftp_cs3 on ftp_cost_component_rule (cost_comp_ccy,priority)
;