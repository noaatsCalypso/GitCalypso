CREATE TABLE ersc_rule_result_c AS
(SELECT * FROM ersc_rule_result rr WHERE rr.id IN
(SELECT rrcj.rule_result_id0 FROM ersc_rule_result_check_join rrcj INNER JOIN ersc_rule_check_result rcr ON rrcj.rule_check_result_id1 = rcr.id
WHERE NOT EXISTS (SELECT * FROM ersc_rule_check rc where rc.id = rcr.check_id))
UNION
SELECT * FROM ersc_rule_result rr WHERE NOT EXISTS (SELECT * FROM ersc_rule r where r.id = rr.rule_id))
GO

CREATE TABLE ersc_rule_check_result_c AS
SELECT rcr.* FROM ersc_rule_result_check_join rrcj INNER JOIN ersc_rule_check_result rcr ON rrcj.rule_check_result_id1 = rcr.id
WHERE rrcj.rule_result_id0 IN (SELECT rrcorrupted.id FROM ersc_rule_result_c rrcorrupted)
GO

CREATE TABLE ersc_rule_result_check_join_c AS
SELECT * FROM ersc_rule_result_check_join rrcj
WHERE rrcj.rule_check_result_id1 IN (SELECT rcrcorrupted.id FROM ersc_rule_check_result_c rcrcorrupted)
GO

DELETE FROM ersc_rule_check_result rcr WHERE rcr.id IN (SELECT rcrcorrupted.id FROM ersc_rule_check_result_c rcrcorrupted)
GO

DELETE FROM ersc_rule_result rr WHERE rr.id IN (SELECT rrcorrupted.id FROM ersc_rule_result_c rrcorrupted)
GO

DELETE FROM ersc_rule_result_check_join rrcj WHERE rrcj.rule_check_result_id1 IN (SELECT rrcjcorrupted.rule_check_result_id1 FROM ersc_rule_result_check_join_c rrcjcorrupted)
GO