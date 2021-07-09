alter table quartz_sched_task_exec add  comments2 text null
go
update quartz_sched_task_exec set comments2=comments
go
alter table quartz_sched_task_exec drop comments
go
sp_rename 'quartz_sched_task_exec.comments2',comments
go





