update official_pl_constituent_tree 
set dest.agg_id = src.trade_id
from official_pl_constituent_tree dest, official_pl_mark src
where dest.agg_node_id = src.mark_id
and dest.agg_id = 0
go