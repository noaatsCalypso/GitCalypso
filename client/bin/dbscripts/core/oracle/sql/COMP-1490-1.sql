UPDATE ERSC_DATA_REVISION SET data=replace(replace(data, '"version" : 0', '"version" : 1'), '"revisionNumber" : 0', '"revisionNumber" : 1') WHERE data_id IN (SELECT name FROM ERSC_RULE WHERE version=0 UNION SELECT id FROM ERSC_RULE WHERE version=0)
;

UPDATE ERSC_DATA_REVISION SET data=replace(replace(data, '"version" : 0', '"version" : 1'), '"revisionNumber" : 0', '"revisionNumber" : 1') WHERE data_id IN (SELECT name FROM ERSC_RULE_GROUP WHERE version=0 UNION SELECT id FROM ERSC_RULE_GROUP WHERE version=0)
;

UPDATE ERSC_RULE SET version=1 WHERE version=0
;

UPDATE ERSC_RULE SET revision_number=1 WHERE revision_number=0
;

UPDATE ERSC_RULE_CHECK SET version=1 WHERE version=0
;

UPDATE ERSC_RULE_GROUP SET version=1 WHERE version=0
;

UPDATE ERSC_RULE_GROUP SET revision_number=1 WHERE revision_number=0
;

UPDATE ERSC_RULE_PORTFOLIO SET version=1 WHERE version=0
;

UPDATE ERSC_SANCTION_ITEM SET version=1 WHERE version=0
;