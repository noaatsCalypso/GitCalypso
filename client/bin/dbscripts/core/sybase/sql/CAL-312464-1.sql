insert
into ers_hierarchy_node_attribute (hierarchy_name,
version,
node_id,
attribute_name,
attribute_value) 
( select distinct h.hierarchy_name ,
1,
0,
'SEGID',
'All'
from ers_hierarchy_attribute ha ,
ers_hierarchy h
where hierarchy_type in ( 'Book','UserAttribute' )
and ha.version =1
and h.version =1
and ha.hierarchy_name = h.hierarchy_name
and h.hierarchy_name not in
(select hierarchy_name
from ers_hierarchy_node_attribute
where version = 1
and node_id = 0
and attribute_name = 'SEGID'
)
)
go