/*  Account Group creation */
/*  Create a account group for each Hierarchy used in the MARGIN_INPUT, MARGIN_CALCULATOR ST */
INSERT
INTO cm_account_group
  (
    id,
    tenant_id,
    version,
    creation_user,
    creation_user_type,
    creation_date,
    last_update_user,
    last_update_user_type,
    last_update_date,
    name
  )
SELECT MD5(RANDOM()::TEXT || ':' || CURRENT_TIMESTAMP)::UUID,
  0,
  0,
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  FLOOR(EXTRACT(epoch FROM NOW())*1000),
  '00000000-0000-0000-0000-000000000000',
  'urn:calypso:cloud:platform:iam:model:User',
  FLOOR(EXTRACT(epoch FROM NOW())*1000),
  attr_value
FROM quartz_sched_task_attr
WHERE attr_name in ('Hierarchy Name','Hierarchy')
AND task_id    IN
  (SELECT task_id
  FROM quartz_sched_task
  WHERE task_type IN ('MARGIN_CALCULATOR', 'MARGIN_INPUT')
  )
GROUP BY attr_value
;


/*  Create a temp table account cm_hierarchy_account_map - Populate hierarchy_name and tf column*/
CREATE TABLE cm_hierarchy_account_map AS
SELECT hierarchy_name,
  node_data                    AS tf,
  CAST('ACT_GRP_ID' AS VARCHAR(64))  AS account_group_id,
  CAST('PORTFOLIO_NAME' AS VARCHAR(255)) AS portfolio_name
FROM ers_hierarchy
WHERE node_data    IS NOT NULL
AND hierarchy_name IN
  (SELECT attr_value
  FROM quartz_sched_task_attr
  WHERE attr_name in ('Hierarchy Name','Hierarchy')
  AND task_id    IN
    (SELECT task_id
    FROM quartz_sched_task
    WHERE task_type IN ('MARGIN_CALCULATOR', 'MARGIN_INPUT')
    )
  GROUP BY attr_value
  ) 
;

/*  Update the account_group_id column in the mapping table from the cm_account_group */
UPDATE cm_hierarchy_account_map
SET account_group_id =
  (SELECT id
  FROM cm_account_group
  WHERE cm_hierarchy_account_map.hierarchy_name = cm_account_group.name
  )
;
/*  Update the portfolio_name column in the mapping table when criteria is old keyword Criteria */
UPDATE cm_hierarchy_account_map
SET portfolio_name =
  (SELECT criterion_value
  FROM trade_filter_crit
  WHERE criterion_name  = 'keyword.IM_PORTFOLIO_NAME'
  AND trade_filter_name = cm_hierarchy_account_map.tf
  )
WHERE EXISTS
  (SELECT criterion_value
  FROM trade_filter_crit
  WHERE criterion_name  = 'keyword.IM_PORTFOLIO_NAME'
  AND trade_filter_name = cm_hierarchy_account_map.tf
  )
;
/*  Update the portfolio_name column in the mapping table when criteria is new keyword Criteria */
UPDATE cm_hierarchy_account_map
SET portfolio_name =
  (SELECT regexp_replace(condition_tree, '.*?<string>IM_PORTFOLIO_NAME<\/string>.*?<string>_operands<\/string>.*?<object-array>.*?<string>([^<]*)<\/string>.*?<\/com.calypso.ui.component.condition.ConditionTree>', '\1')
  FROM trade_filter
  WHERE condition_tree IS NOT NULL
  AND trade_filter_name = cm_hierarchy_account_map.tf
  )
WHERE NOT EXISTS
  (SELECT criterion_value
  FROM trade_filter_crit
  WHERE criterion_name  = 'keyword.IM_PORTFOLIO_NAME'
  AND trade_filter_name = cm_hierarchy_account_map.tf
  ) 
;
/* Add a the AccountGroup ref to the account group mapping table of the account */
INSERT
INTO cm_account_group_ids
  (
    account_id,
    account_group_ids
  )
SELECT DISTINCT
  (SELECT id
  FROM cm_account
  WHERE name = cm_hierarchy_account_map.portfolio_name
  ),
  account_group_id
FROM cm_hierarchy_account_map
WHERE exists (SELECT id
  FROM cm_account
  WHERE name = cm_hierarchy_account_map.portfolio_name)
;


/* Add new Account Group Ids attribute on the MARGIN_INPUT and MARGIN_CALCULATOR ST which had a Hierarchy attribute */
INSERT INTO quartz_sched_task_attr
  (task_id, attr_name, attr_value
  )
SELECT task_id,
  'Account Group Ids',
  (SELECT id
  FROM cm_account_group
  WHERE name = quartz_sched_task_attr.attr_value 
  and quartz_sched_task_attr.attr_name in ('Hierarchy Name','Hierarchy')
  )
FROM quartz_sched_task_attr
WHERE attr_name in ('Hierarchy Name','Hierarchy')
AND task_id IN (SELECT task_id
  FROM quartz_sched_task
  WHERE task_type IN ('MARGIN_CALCULATOR', 'MARGIN_INPUT')
)
;
/* Cleanup TradeFilter on ALL MARGIN UMR ST to make sure the scheduled Task will keep using Hierarchy post migration */
update quartz_sched_task set trade_filter = null WHERE task_type IN ('MARGIN_CALCULATOR', 'MARGIN_INPUT') 
;

/* Clean up */
drop table cm_hierarchy_account_map
;

