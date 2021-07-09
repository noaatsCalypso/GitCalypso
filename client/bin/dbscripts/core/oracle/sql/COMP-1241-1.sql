INSERT INTO ersc_rule_grouping_columns (rule_id, grouping_columns) SELECT id, grouping_column FROM ersc_rule WHERE grouping_column IS NOT NULL
;

INSERT INTO ersc_rule_check_criteria (rule_check_id, grouping_criteria) SELECT id, criteria FROM ersc_rule_check WHERE criteria IS NOT NULL
;

INSERT INTO ersc_rule_check_res_group_cols (rule_check_result_id, grouping_columns) SELECT id, grouping_column FROM ersc_rule_check_result WHERE grouping_column IS NOT NULL
;

INSERT INTO ersc_rule_check_res_group_vals (rule_check_result_id, grouping_values) SELECT id, grouping_value FROM ersc_rule_check_result WHERE grouping_value IS NOT NULL
;
