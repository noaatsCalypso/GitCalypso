if not exists (select 1 from sysobjects where name='ers_info' and type='U')
begin 
exec ('create table ers_info(major_version numeric not null,
		minor_version numeric not null,
		sub_version numeric not null,
		version_date datetime null,
		ref_time_zone varchar(128) null,
		patch_version varchar(32) null,
		patch_date datetime null)')
end
go
update ers_trade
set attr1_name = 'Issuer'
where attr1_name = 'ReferenceEntity'
go
update ers_trade
set attr2_name = 'Issuer'
where attr2_name = 'ReferenceEntity'
go
update ers_trade
set attr3_name = 'Issuer'
where attr3_name = 'ReferenceEntity'
go
update ers_trade
set attr4_name = 'Issuer'
where attr4_name = 'ReferenceEntity'
go
update ers_trade
set attr5_name = 'Issuer'
where attr5_name = 'ReferenceEntity'
go
update ers_trade
set attr6_name = 'Issuer'
where attr6_name = 'ReferenceEntity'
go
update ers_trade
set attr7_name = 'Issuer'
where attr7_name = 'ReferenceEntity'
go
update ers_trade
set attr8_name = 'Issuer'
where attr8_name = 'ReferenceEntity'
go
update ers_trade
set attr9_name = 'Issuer'
where attr9_name = 'ReferenceEntity'
go
update ers_trade
set attr10_name = 'Issuer'
where attr10_name = 'ReferenceEntity'
go
update ers_trade
set attr11_name = 'Issuer'
where attr11_name = 'ReferenceEntity'
go
update ers_trade
set attr12_name = 'Issuer'
where attr12_name = 'ReferenceEntity'
go
update ers_trade
set attr13_name = 'Issuer'
where attr13_name = 'ReferenceEntity'
go

update ers_grouping
set attr1_name = 'Issuer'
where attr1_name = 'ReferenceEntity'
go
update ers_grouping
set attr2_name = 'Issuer'
where attr2_name = 'ReferenceEntity'
go
update ers_grouping
set attr3_name = 'Issuer'
where attr3_name = 'ReferenceEntity'
go
update ers_grouping
set attr4_name = 'Issuer'
where attr4_name = 'ReferenceEntity'
go
update ers_grouping
set attr5_name = 'Issuer'
where attr5_name = 'ReferenceEntity'
go
update ers_grouping
set attr6_name = 'Issuer'
where attr6_name = 'ReferenceEntity'
go
update ers_grouping
set attr7_name = 'Issuer'
where attr7_name = 'ReferenceEntity'
go
update ers_grouping
set attr8_name = 'Issuer'
where attr8_name = 'ReferenceEntity'
go
update ers_grouping
set attr9_name = 'Issuer'
where attr9_name = 'ReferenceEntity'
go
if exists (select 1 from sysobjects where name='ers_info' and type='U')
begin
exec ('delete from ers_info')
end
go
update ers_limit set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
go
update ers_limit_pending set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
go
update ers_limit_authorise set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
go
update ers_limit_authorise_reject set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
go
