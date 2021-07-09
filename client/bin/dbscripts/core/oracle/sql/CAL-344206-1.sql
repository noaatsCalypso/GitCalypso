/*
CAL-344206
Fixes corrupted data in 
  - ha_hedge_relationship_trade: columns original_nominal, open_nominal, participation_nominal get now correct sign.
  - ha_hedge_liquidation_item: column adj_part_nominal gets now correct sign.

Before applying the changes, creates two backup tables:
 - ha_sign_fix_backup_hrt backups ha_hedge_relationship_trade for modified rows and columns
 - ha_sign_fix_backup_hli backups ha_hedge_liquidation_item for modified rows and columns
*/ 
declare x number;
BEGIN
    BEGIN
		SELECT count(*) INTO x FROM user_tables WHERE TABLE_NAME in (UPPER('ha_sign_fix_backup_hrt'), UPPER('ha_sign_fix_backup_hli'));
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        x:=0;
        WHEN others THEN
        null;
    END;
    IF x = 0 THEN
		EXECUTE IMMEDIATE 'create table ha_sign_fix_backup_hrt as 
            select * from 
            (
              (
            			select hart.id, hart.trade_id,hart.hedge_relationship_id,hahdef.relationship_subclass, hahdef.hedged_risk, s.swap_type, s.receive_leg_type, s.pay_leg_type,
            			hart.original_nominal, ABS(hart.original_nominal)*((CASE WHEN s.receive_leg_type = ''Fixed'' THEN 1 ELSE -1 END)*(CASE WHEN hahdef.relationship_subclass = ''Cash Flow Hedge'' AND hahdef.hedged_risk NOT IN (''FX Risk'', ''Translation Risk'', ''Interest Rate in Base'') THEN -1 ELSE 1 END)) AS fixed_original_nominal,
            			hart.open_nominal, ABS(hart.open_nominal)*((CASE WHEN s.receive_leg_type = ''Fixed'' THEN 1 ELSE -1 END)*(CASE WHEN hahdef.relationship_subclass = ''Cash Flow Hedge'' AND hahdef.hedged_risk NOT IN (''FX Risk'', ''Translation Risk'', ''Interest Rate in Base'') THEN -1 ELSE 1 END)) AS fixed_open_nominal,
            			hart.participation_nominal, ABS(hart.participation_nominal)*((CASE WHEN s.receive_leg_type = ''Fixed'' THEN 1 ELSE -1 END)*(CASE WHEN hahdef.relationship_subclass = ''Cash Flow Hedge'' AND hahdef.hedged_risk NOT IN (''FX Risk'', ''Translation Risk'', ''Interest Rate in Base'') THEN -1 ELSE 1 END)) AS fixed_participation_nominal
            			from ha_hedge_relationship_trade hart, trade t, product_swap s, ha_hedge_relationship hahr, ha_hedge_strategy hahdef
            			where hart.trade_id=t.trade_id and t.product_id = s.product_id and s.swap_type = ''Swap'' and s.pay_leg_type <> s.receive_leg_type  
            			and hart.hedge_relationship_id=hahr.hedge_relationship_id and hahr.hedge_strategy_id=hahdef.relationship_id 
              union
                  select hart.id, hart.trade_id,hart.hedge_relationship_id,hahdef.relationship_subclass, hahdef.hedged_risk, s.swap_type, s.receive_leg_type, s.pay_leg_type,
            			hart.original_nominal, ABS(hart.original_nominal)*(CASE WHEN s.pay_leg_id = sl.leg_id THEN -1 ELSE 1 END) AS fixed_original_nominal,
            			hart.open_nominal, ABS(hart.open_nominal)*(CASE WHEN s.pay_leg_id = sl.leg_id THEN -1 ELSE 1 END) AS fixed_open_nominal,
            			hart.participation_nominal, ABS(hart.participation_nominal)*(CASE WHEN s.pay_leg_id = sl.leg_id THEN -1 ELSE 1 END)  AS fixed_participation_nominal
            			from ha_hedge_relationship_trade hart, trade t, product_swap s, swap_leg sl, ha_hedge_relationship hahr, ha_hedge_strategy hahdef, 
                  ha_hedge_accounting_scheme has, entity_attributes has_a
            			where hart.trade_id=t.trade_id and t.product_id = s.product_id and t.product_id=sl.product_id and s.swap_type = ''SwapCrossCurrency'' 
                  and sl.principal_currency <> has_a.attr_value
                  and abs(hart.original_nominal) = abs(sl.principal_amount)  /* check on principal in order to check we are on the expected leg and we ignore unknown cases */
                  and hart.hedge_relationship_id=hahr.hedge_relationship_id and hahr.hedge_strategy_id=hahdef.relationship_id 
                  and has.has_id = hahr.hedge_accounting_scheme_id
                  and has_a.entity_id=has.has_id and has_a.entity_type = ''HedgeAccountingScheme'' and has_a.attr_name = ''Base Currency''
              )      
              order by trade_id asc
            )      
            where
            			(fixed_original_nominal<>original_nominal OR fixed_open_nominal<>open_nominal OR fixed_participation_nominal<>participation_nominal)
			';
		EXECUTE IMMEDIATE 'create table ha_sign_fix_backup_hli as 
            select * from 
            (
               (
                   select hli.hedge_liq_id, hli.trade_id, hli.hedge_relationship_id, hahdef.relationship_subclass, hahdef.hedged_risk, s.swap_type, s.receive_leg_type, s.pay_leg_type, hli.creation_reason, 
                   hli.adj_part_nominal, -ABS(hli.adj_part_nominal)*((CASE WHEN s.receive_leg_type = ''Fixed'' THEN 1 ELSE -1 END)*(CASE WHEN hahdef.relationship_subclass = ''Cash Flow Hedge'' AND hahdef.hedged_risk NOT IN (''FX Risk'', ''Translation Risk'', ''Interest Rate in Base'') THEN -1 ELSE 1 END)) AS fixed_adj_part_nominal
                   from ha_hedge_liquidation_item hli, trade t, product_swap s, ha_hedge_relationship hahr, ha_hedge_strategy hahdef 
                   where hli.trade_id=t.trade_id and t.product_id = s.product_id and s.swap_type = ''Swap'' and s.pay_leg_type <> s.receive_leg_type
                   and hli.hedge_relationship_id=hahr.hedge_relationship_id and hahr.hedge_strategy_id=hahdef.relationship_id 
            	  union
                   select hli.hedge_liq_id, hli.trade_id, hli.hedge_relationship_id, hahdef.relationship_subclass, hahdef.hedged_risk, s.swap_type, s.receive_leg_type, s.pay_leg_type, hli.creation_reason, 
                   hli.adj_part_nominal, -ABS(hli.adj_part_nominal)*(CASE WHEN s.pay_leg_id = sl.leg_id THEN -1 ELSE 1 END) AS fixed_adj_part_nominal
                   from ha_hedge_liquidation_item hli, trade t, product_swap s, swap_leg sl, ha_hedge_relationship hahr, ha_hedge_strategy hahdef,
                        ha_hedge_relationship_trade hart,
                        ha_hedge_accounting_scheme has, entity_attributes has_a
                   where hli.trade_id=t.trade_id and t.product_id = s.product_id and t.product_id=sl.product_id and s.swap_type = ''SwapCrossCurrency'' 
                   and hli.hedge_relationship_id=hahr.hedge_relationship_id and hahr.hedge_strategy_id=hahdef.relationship_id 
                   and hart.trade_id=t.trade_id and hart.hedge_relationship_id=hahr.hedge_relationship_id
                              and sl.principal_currency <> has_a.attr_value
                              and abs(hart.original_nominal) = abs(sl.principal_amount)  /* check on principal in order to check we are on the expected leg and we ignore unknown cases */
                              and has.has_id = hahr.hedge_accounting_scheme_id
                              and has_a.entity_id=has.has_id and has_a.entity_type = ''HedgeAccountingScheme'' and has_a.attr_name = ''Base Currency''
               )
               order by trade_id asc
            )
            where
            (fixed_adj_part_nominal<>adj_part_nominal)      
			';
		EXECUTE IMMEDIATE 'MERGE INTO ha_hedge_relationship_trade hart
			USING (SELECT id, fixed_original_nominal, fixed_open_nominal, fixed_participation_nominal FROM ha_sign_fix_backup_hrt ) b
			ON (hart.id = b.id)
			WHEN MATCHED THEN UPDATE SET hart.original_nominal = b.fixed_original_nominal, hart.open_nominal = b.fixed_open_nominal, hart.participation_nominal = b.fixed_participation_nominal';
		EXECUTE IMMEDIATE 'MERGE INTO ha_hedge_liquidation_item hli
			USING (SELECT hedge_liq_id, fixed_adj_part_nominal FROM ha_sign_fix_backup_hli ) b
			ON (hli.hedge_liq_id = b.hedge_liq_id)
			WHEN MATCHED THEN UPDATE SET hli.adj_part_nominal = b.fixed_adj_part_nominal';
	  END IF;
END;
