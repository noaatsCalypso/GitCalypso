UPDATE bo_message SET template_name = STR_REPLACE(template_name, 'six', 'SIX') WHERE template_name LIKE '%six'
go
UPDATE advice_config SET template_name = STR_REPLACE(template_name, 'six', 'SIX') WHERE template_name LIKE '%six'
go
UPDATE domain_values SET value = STR_REPLACE(value, 'six', 'SIX') WHERE value LIKE '%six' AND name IN ('SWIFT.Templates.GPI', 'MX.DisplayAppHeader', 'MX.Templates')
go