insert into trade_keyword (trade_id, keyword_name, keyword_value) 
select t.trade_id, 'FinalMatDate', tk.keyword_value from trade_keyword tk, trade t, product_desc pd
where t.trade_id=tk.trade_id and t.product_id=pd.product_id and tk.keyword_name='TerminationDate' and pd.product_type='Swap' and pd.product_extended_type='Cancellable'
and not exists ( select 1 from   trade_keyword  tk1 where  tk1.trade_id = t.trade_id
			and  t.product_id = pd.product_id
			and  tk1.keyword_name='FinalMatDate'
			and pd.product_type='Swap' and pd.product_extended_type='Cancellable')
;
