create table missing_plmeasure as select pl_config_id from official_pl_config 
where pl_config_id not in (select pl_config_id from official_pl_config_attr where attr_type='plmeasure' and attr_value='P' || chr(38) || 'L')
;

insert into official_pl_config_attr (pl_config_id, attr_type, attr_value, user_specified_order)
select missing_plmeasure.pl_config_id, 'plmeasure', 'P' || chr(38) || 'L', max_measureid.order_id
from missing_plmeasure, (select pl_config_id, max(user_specified_order)+1 as order_id from official_pl_config_attr where attr_type='plmeasure' group by pl_config_id) max_measureid
where missing_plmeasure.pl_config_id = max_measureid.pl_config_id
;

drop table missing_plmeasure
;