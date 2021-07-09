UPDATE bo_message SET template_name = REPLACE(template_name, 'six', 'SIX') WHERE template_name LIKE '%six'
;
UPDATE advice_config SET template_name = REPLACE(template_name, 'six', 'SIX') WHERE template_name LIKE '%six'
;
UPDATE domain_values SET value = REPLACE(value, 'six', 'SIX') WHERE value LIKE '%six' AND name IN ('SWIFT.Templates.GPI', 'MX.DisplayAppHeader', 'MX.Templates')
;