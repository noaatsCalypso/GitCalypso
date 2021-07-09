MERGE INTO official_pl_constituent_tree dest
USING (
	select mark_id, trade_id 
	from official_pl_mark
	where mark_id in (select agg_node_id from  official_pl_constituent_tree where agg_id = 0 )
	) src
ON (dest.agg_node_id = src.mark_id)
WHEN MATCHED THEN UPDATE 
	SET dest.agg_id = src.trade_id
;