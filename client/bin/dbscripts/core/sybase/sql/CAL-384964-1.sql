update legal_entity set anonymized=0 WHERE anonymized is null
go
update le_contact set anonymized=0 WHERE anonymized is null
go
update le_attribute set anonymized=0 WHERE anonymized is null
go
