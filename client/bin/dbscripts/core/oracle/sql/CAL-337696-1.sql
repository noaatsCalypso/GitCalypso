update date_rule set  rel_type='Relative' 
where add_months=0 and rel_type='Fixed' and date_rule_type in (
1,--BEG_MONTH
2,--END_MONTH
3,--BEG_YEAR
4,--END_YEAR
5,--IMM
6,--DAY_FIXED
7,--DAY_MONTH_FIXED
8,--WEEKDAY_FIXED
10,--DAILY
11,--WEEKDAY_CBOT
13)--WEEKLY
;

