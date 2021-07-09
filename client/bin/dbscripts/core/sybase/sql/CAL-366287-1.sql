select pl_config_id into missing_plmeasure from official_pl_config 
where pl_config_id not in (select pl_config_id from official_pl_config_attr where attr_type='plmeasure' and attr_value='P' || char(38) || 'L')
go

insert into official_pl_config_attr (pl_config_id, attr_type, attr_value, user_specified_order)
select missing_plmeasure.pl_config_id, 'plmeasure' as attr_type, 'P' || char(38) || 'L' as attr_value, max_measureid.order_id
from missing_plmeasure, (select pl_config_id, max(user_specified_order)+1 as order_id from official_pl_config_attr where attr_type='plmeasure' group by pl_config_id) as max_measureid
where missing_plmeasure.pl_config_id = max_measureid.pl_config_id
go

drop table missing_plmeasure
go
