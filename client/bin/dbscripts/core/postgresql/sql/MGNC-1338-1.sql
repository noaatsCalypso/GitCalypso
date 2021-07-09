update margin_portfolio_vm set po_view = (
(select case when count(*) > 0 THEN 1 else 0 end
from quartz_sched_task_attr where attr_name = 'VM View' and attr_value = 'PO' 
and task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_VM_CALCULATOR')
and task_id in (select task_id from quartz_sched_task_attr where attr_name = 'Hierarchy Name' and attr_value in (select hierarchy_name from ers_hierarchy where node_name = margin_portfolio_vm.margin_agreement_name))
)
)
;
delete from quartz_sched_task_attr where attr_name = 'VM View'
and task_id in (select task_id from quartz_sched_task where task_type = 'MARGIN_OTC_VM_CALCULATOR')
;
