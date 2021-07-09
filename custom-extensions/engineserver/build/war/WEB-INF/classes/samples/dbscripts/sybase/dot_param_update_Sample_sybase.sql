
update ers_result_history
set analysis='ProfitLoss.Standard'
where analysis = 'ProfitLoss'
and value_date in 
    (select rr.value_date
    from ers_run_history rr, ers_run_param rp
    where rp.analysis = 'ProfitLoss' and rp.param_set='test'
    and rr.analysis = rp.analysis
    and rr.value_date = rp.value_date
    and rp.official = 1)
and value_date not in
    (select a.value_date
    from ers_run_param a join ers_run_param b on
    (a.value_date = b.value_date)
    where a.analysis = 'ProfitLoss.Standard' and b.analysis = 'ProfitLoss' and b.param_set = 'test' 
    and a.official = 1)
go

update ers_run_history
set analysis='ProfitLoss.Standard'
where analysis = 'ProfitLoss'
and value_date in 
    (select rr.value_date
    from ers_run_history rr, ers_run_param rp
    where rp.analysis = 'ProfitLoss' and rp.param_set='test'  
    and rr.analysis = rp.analysis
    and rr.value_date = rp.value_date
    and rp.official = 1)
and value_date not in
    (select a.value_date
    from ers_run_param a join ers_run_param b on
    (a.value_date = b.value_date)
    where a.analysis = 'ProfitLoss.Standard' and b.analysis = 'ProfitLoss' and b.param_set = 'test' 
    and a.official = 1)
go

update ers_run_param
set analysis='ProfitLoss.Standard' , param_set = 'Standard'
where analysis = 'ProfitLoss' and param_set='test'
and official = 1
and value_date not in
    (select a.value_date
    from ers_run_param a join ers_run_param b on
    (a.value_date = b.value_date)
    where a.analysis = 'ProfitLoss.Standard' and b.analysis = 'ProfitLoss' and b.param_set = 'test' 
    and a.official = 1)
go

update ers_job_exec
set analysis = 'ProfitLoss.Standard' , param_set='Standard'
where analysis = 'ProfitLoss' and param_set = 'test'
and task_id <> 0
go

update ers_run
set analysis = 'ProfitLoss.Standard'
where run_id in(
select r.run_id
    from ers_run r, ers_run_param rp
    where rp.analysis = 'ProfitLoss' and rp.param_set='test'
    and r.analysis = rp.analysis
    and r.value_date = rp.value_date
    and rp.official <> 1)
go

update ers_run_param
set analysis = 'ProfitLoss.Standard', param_set = 'Standard'
where analysis = 'ProfitLoss' and param_set = 'test'
and official <> 1
go
