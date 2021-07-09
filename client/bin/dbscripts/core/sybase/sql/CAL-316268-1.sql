create index idx_mirror on trade(trade_id,mirror_trade_id,trade_status)
go
insert into trade_keyword ( trade_id, keyword_name, keyword_value) 
select t.mirror_trade_id, 'FinalMatDate', tk.keyword_value from trade_keyword tk, trade t 
where t.trade_id=tk.trade_id and t.trade_status='TERMINATED' and t.mirror_trade_id not in (0)
and tk.keyword_name='FinalMatDate'
and t.mirror_trade_id not in (select distinct tk1.trade_id from trade_keyword tk1 where tk1.keyword_name='FinalMatDate')
go