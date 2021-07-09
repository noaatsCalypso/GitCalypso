UPDATE ersc_data_revision SET data=replace(replace(data, '"version" : 0', '"version" : 1'), '"revisionNumber" : 0', '"revisionNumber" : 1') WHERE data_id IN (SELECT name FROM ersc_rule WHERE version=0 UNION SELECT id FROM ersc_rule WHERE version=0) 
GO

UPDATE ersc_data_revision SET data=replace(replace(data, '"version" : 0', '"version" : 1'), '"revisionNumber" : 0', '"revisionNumber" : 1') WHERE data_id IN (SELECT name FROM ersc_rule_group WHERE version=0 UNION SELECT id FROM ersc_rule_group WHERE version=0) 
GO

UPDATE ersc_rule SET version=1 WHERE version=0 
GO

UPDATE ersc_rule SET revision_number=1 WHERE revision_number=0 
GO

UPDATE ersc_rule_check SET version=1 WHERE version=0 
GO

UPDATE ersc_rule_group SET version=1 WHERE version=0 
GO

UPDATE ersc_rule_group SET revision_number=1 WHERE revision_number=0 
GO

UPDATE ersc_rule_portfolio SET version=1 WHERE version=0 
GO

UPDATE ersc_sanction_item SET version=1 WHERE version=0 
GO