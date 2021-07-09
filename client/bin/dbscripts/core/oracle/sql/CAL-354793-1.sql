alter table quartz_sched_task_exec add comments2 clob
;
update quartz_sched_task_exec set comments2=comments
;
alter table quartz_sched_task_exec drop column comments
;
alter table quartz_sched_task_exec rename column comments2 To comments
;