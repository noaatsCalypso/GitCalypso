update option_contract set underlying_date_type='Underlying Add Months' where months_added>0
;
update option_contract set underlying_date_type='Underlying Date Schedule' where underlying_rule>0 AND months_added!=-999
;
update option_contract set underlying_date_type='Add Months on Product' where underlying_rule>0 AND months_added=-999
;