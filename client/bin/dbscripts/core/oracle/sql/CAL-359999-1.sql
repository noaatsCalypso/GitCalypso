delete from pc_repo where matcher is null
;
begin
drop_pk_if_exists ('pc_repo');
end;
/