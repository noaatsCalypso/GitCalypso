update calypso_seed
set last_id = (select coalesce(max(violation_id)+1,1001) from ers_violation) 
where seed_name='ers_violation_id'
go