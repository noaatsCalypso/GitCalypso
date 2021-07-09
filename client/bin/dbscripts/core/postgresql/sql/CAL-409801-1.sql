update sched_task_attr set attr_value =replace(attr_value, ';', '|') where attr_name IN('Include Quote Names Like','Exclude Quote Names Like')
; 