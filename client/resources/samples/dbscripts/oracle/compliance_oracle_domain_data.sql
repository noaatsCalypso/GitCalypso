INSERT INTO engine_config (engine_id,engine_name,engine_comment,version_num) SELECT MAX(engine_id) + 1, 'ERSComplianceEngine', '', 1 FROM engine_config
;