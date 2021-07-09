update domain_values 
set description = description || ',ASIC'
where name = 'DTCC-GTR-RelevantJurisdictionsByPurpose' and value='Snapshot' and description not like '%ASIC%'
;