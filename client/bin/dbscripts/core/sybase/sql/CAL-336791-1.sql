update quartz_sched_task_attr 
set attr_value=STR_REPLACE(attr_value,'-XX:MaxMetaspaceSize=1024m','')
where attr_name='JVM_SETTINGS' 
go