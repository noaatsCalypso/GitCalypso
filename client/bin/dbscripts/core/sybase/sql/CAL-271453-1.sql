
update product_cap_floor 
set reset_date_roll = (select code_value from product_sec_code 
where product_sec_code.sec_code = 'ResetDateRoll'
and product_cap_floor.product_id = product_sec_code.product_id) where reset_date_roll is null
go
update product_cap_floor set reset_date_roll = coupon_dateroll where reset_date_roll is null
go

update swap_leg 
set upper_strike= (select cap_swap_ext_info.p_cap_rate from cap_swap_ext_info where swap_leg.product_id=cap_swap_ext_info.product_id )
where exists ( select product_swap.product_id from product_swap  where swap_leg.leg_id = product_swap.pay_leg_id 
and swap_leg.product_id =product_swap.product_id )
go

update swap_leg 
set lower_strike= (select cap_swap_ext_info.p_floor_rate from cap_swap_ext_info where swap_leg.product_id=cap_swap_ext_info.product_id ) 
where exists ( select product_swap.product_id from product_swap  where swap_leg.leg_id = product_swap.pay_leg_id 
and swap_leg.product_id = product_swap.product_id and swap_leg.product_id in (select cap_swap_ext_info.product_id from cap_swap_ext_info))
go

update swap_leg 
set upper_strike = (select cap_swap_ext_info.r_cap_rate from cap_swap_ext_info where swap_leg.product_id=cap_swap_ext_info.product_id ) 
where exists ( select product_swap.product_id from product_swap  where swap_leg.leg_id = product_swap.receive_leg_id 
and swap_leg.product_id =product_swap.product_id and swap_leg.product_id in (select product_id from cap_swap_ext_info))
go

insert into trade_keyword(trade_id,keyword_name, keyword_value)
select t.trade_id, 'StrategyId', convert(varchar(255),(s.id))
from trade_keyword t, strategy s
where t.keyword_name = 'Strategy'
and t.keyword_value = s.name
and not exists( select 1 from trade_keyword t2
where t.trade_id = t2.trade_id
and t2.keyword_name = 'StrategyId')
go

add_column_if_not_exists 'pos_agg','strategy_id','numeric null'
go
update pos_agg set strategy_id = (select max(s.id) from strategy s where s.name = pos_agg.strategy
group by s.name ) where pos_agg.strategy is not null and pos_agg.strategy_id is null
go


update swap_leg 
set lower_strike= (select cap_swap_ext_info.r_floor_rate from cap_swap_ext_info where swap_leg.product_id=cap_swap_ext_info.product_id ) 
where exists ( select product_swap.product_id from product_swap  where  swap_leg.leg_id = product_swap.receive_leg_id 
and swap_leg.product_id =product_swap.product_id and swap_leg.product_id in (select product_id from cap_swap_ext_info))
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='005',
        version_date='20140922'
go 
