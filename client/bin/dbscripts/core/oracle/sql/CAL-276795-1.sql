delete from ers_info
;
CREATE TABLE ers_limit_groups
   (
	group_type		varchar2 (64)   NOT NULL,
	group_name		varchar2 (64)	NOT NULL,
	group_value		varchar2 (64)	NOT NULL
   )
;
insert into ers_limit_groups (group_type, group_name, group_value)(select 'ProductGroup', product_group, product_type from ers_product_groups)
;