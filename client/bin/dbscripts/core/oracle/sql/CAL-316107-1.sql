DELETE FROM le_agreement_field WHERE le_agreement_field IN ('ELIGIBILITY_RULE_BOTH', 'ELIGIBILITY_RULE_REPO', 'ELIGIBILITY_RULE_REVERSE_REPO')
;
DELETE FROM eligibility_rule WHERE rule_static_data_taker IS NULL AND rule_static_data_giver IS NULL
;
