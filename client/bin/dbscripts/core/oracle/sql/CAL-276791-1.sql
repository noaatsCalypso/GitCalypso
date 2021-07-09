update ers_trade
set attr1_name = 'Issuer'
where attr1_name = 'ReferenceEntity'
;
update ers_trade
set attr2_name = 'Issuer'
where attr2_name = 'ReferenceEntity'
;
update ers_trade
set attr3_name = 'Issuer'
where attr3_name = 'ReferenceEntity'
;
update ers_trade
set attr4_name = 'Issuer'
where attr4_name = 'ReferenceEntity'
;
update ers_trade
set attr5_name = 'Issuer'
where attr5_name = 'ReferenceEntity'
;
update ers_trade
set attr6_name = 'Issuer'
where attr6_name = 'ReferenceEntity'
;
update ers_trade
set attr7_name = 'Issuer'
where attr7_name = 'ReferenceEntity'
;
update ers_trade
set attr8_name = 'Issuer'
where attr8_name = 'ReferenceEntity'
;
update ers_trade
set attr9_name = 'Issuer'
where attr9_name = 'ReferenceEntity'
;
update ers_trade
set attr10_name = 'Issuer'
where attr10_name = 'ReferenceEntity'
;
update ers_trade
set attr11_name = 'Issuer'
where attr11_name = 'ReferenceEntity'
;
update ers_trade
set attr12_name = 'Issuer'
where attr12_name = 'ReferenceEntity'
;
update ers_trade
set attr13_name = 'Issuer'
where attr13_name = 'ReferenceEntity'
;

update ers_grouping
set attr1_name = 'Issuer'
where attr1_name = 'ReferenceEntity'
;
update ers_grouping
set attr2_name = 'Issuer'
where attr2_name = 'ReferenceEntity'
;
update ers_grouping
set attr3_name = 'Issuer'
where attr3_name = 'ReferenceEntity'
;
update ers_grouping
set attr4_name = 'Issuer'
where attr4_name = 'ReferenceEntity'
;
update ers_grouping
set attr5_name = 'Issuer'
where attr5_name = 'ReferenceEntity'
;
update ers_grouping
set attr6_name = 'Issuer'
where attr6_name = 'ReferenceEntity'
;
update ers_grouping
set attr7_name = 'Issuer'
where attr7_name = 'ReferenceEntity'
;
update ers_grouping
set attr8_name = 'Issuer'
where attr8_name = 'ReferenceEntity'
;
update ers_grouping
set attr9_name = 'Issuer'
where attr9_name = 'ReferenceEntity'
;
delete from ers_info
;
update ers_limit set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
;
update ers_limit_pending set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
;
update ers_limit_authorise set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
;
update ers_limit_authorise_reject set attr2_name = 'Issuer' where service = 'Market Risk' and attr2_name = 'ReferenceEntity'
;
