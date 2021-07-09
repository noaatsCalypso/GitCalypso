update domain_values set value='ComplianceRuleSanctioningLevelViewRole' where value='ComplianceRuleSantioningLevelViewRole'
;
update domain_values set value='ComplianceRuleSanctioningLevelEditRole' where value='ComplianceRuleSantioningLevelEditRole'
;
update group_access set access_value='ComplianceRuleSanctioningLevelViewRole' where access_value='ComplianceRuleSantioningLevelViewRole'
;
update group_access set access_value='ComplianceRuleSanctioningLevelEditRole' where access_value='ComplianceRuleSantioningLevelEditRole'
;