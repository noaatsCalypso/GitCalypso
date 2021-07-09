
update product_cap_floor a
set reset_date_roll = (select b.code_value from product_sec_code b
where b.sec_code = 'ResetDateRoll'
and a.product_id = b.product_id) where reset_date_roll is null
;
update product_cap_floor  set reset_date_roll = coupon_dateroll where reset_date_roll is null
;


insert into trade_keyword(trade_id,keyword_name, keyword_value)
select t.trade_id, 'StrategyId', to_char(s.id)
from trade_keyword t, strategy s
where t.keyword_name = 'Strategy'
and t.keyword_value = s.name
and not exists( select 1 from trade_keyword t2
where t.trade_id = t2.trade_id
and t2.keyword_name = 'StrategyId')
;

update swap_leg a
set upper_strike= (select cap_swap_ext_info.p_cap_rate from cap_swap_ext_info where a.product_id=cap_swap_ext_info.product_id )
where exists ( select b.product_id from product_swap b where  
a.leg_id = b.pay_leg_id and  a.product_id =b.product_id
and a.product_id in (select product_id from cap_swap_ext_info))
;

begin
add_column_if_not_exists('pos_agg','strategy_id', 'number(38)');
end;
/
update pos_agg agg set strategy_id = (select max(s.id) from strategy s where s.name = agg.strategy
group by s.name ) where agg.strategy is not null and agg.strategy_id is null
;

update swap_leg a
set lower_strike= (select cap_swap_ext_info.p_floor_rate from cap_swap_ext_info where a.product_id=cap_swap_ext_info.product_id ) 
where exists ( select b.product_id from product_swap b where  
a.leg_id = b.pay_leg_id and  a.product_id =b.product_id
and a.product_id in (select product_id from cap_swap_ext_info))
;

update swap_leg a
set upper_strike = (select cap_swap_ext_info.r_cap_rate from cap_swap_ext_info where a.product_id=cap_swap_ext_info.product_id ) 
where exists ( select b.product_id from product_swap b where  
a.leg_id = b.receive_leg_id and  a.product_id =b.product_id
and a.product_id in (select product_id from cap_swap_ext_info))
;

update swap_leg a
set lower_strike= (select cap_swap_ext_info.r_floor_rate from cap_swap_ext_info where a.product_id=cap_swap_ext_info.product_id ) 
where exists ( select b.product_id from product_swap b where  
a.leg_id = b.receive_leg_id and  a.product_id =b.product_id
and a.product_id in (select product_id from cap_swap_ext_info))
;



UPDATE calypso_info
    SET major_version=14,
        minor_version=1,
        sub_version=0,
        patch_version='005',
        version_date=TO_DATE('22/09/2014','DD/MM/YYYY') 
