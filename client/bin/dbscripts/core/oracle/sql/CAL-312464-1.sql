INSERT
INTO ers_hierarchy_node_attribute (hierarchy_name,
version,
node_id,
attribute_name,
attribute_value) 
( SELECT DISTINCT h.hierarchy_name ,
1,
0,
'SEGID',
'All'
FROM ers_hierarchy_attribute ha ,
ers_hierarchy h
WHERE hierarchy_type IN ( 'Book','UserAttribute' )
AND ha.version =1
AND h.version =1
AND ha.hierarchy_name = h.hierarchy_name
AND h.hierarchy_name NOT IN
(SELECT hierarchy_name
FROM ers_hierarchy_node_attribute
WHERE version = 1
AND node_id = 0
AND attribute_name = 'SEGID'
)
)
;