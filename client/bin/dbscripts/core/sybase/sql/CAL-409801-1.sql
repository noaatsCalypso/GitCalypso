update sched_task_attr set attr_value  =str_replace(attr_value, ';' ,'|') where attr_name in ('Include Quote Names Like','Exclude Quote Names Like')
go