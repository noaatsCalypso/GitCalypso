DELETE FROM grouping_hierarchy WHERE parent_id in (select id from trade_grouping_base where underlying_id not in (select fund_id from fund) and type = 'Fund')
GO
DELETE FROM grouping_references WHERE grouping_id in (select id from trade_grouping_base where underlying_id not in (select fund_id from fund) and type = 'Fund')
GO
DELETE FROM trade_grouping_base WHERE underlying_id not in (select fund_id from fund) and type = 'Fund'
GO