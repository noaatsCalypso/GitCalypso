UPDATE quartz_sched_task_attr
SET attr_value =REPLACE(attr_value,'-XX:MaxMetaspaceSize=1024m','')
WHERE attr_name='JVM_SETTINGS'
;