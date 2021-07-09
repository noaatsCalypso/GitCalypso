delete from calypso_seed where seed_name = 'PricingSheetStrategyInfo'
/
insert into calypso_seed (last_id,seed_name,seed_alloc_size) values (1000,'PricingSheetStrategyInfo',500)
/
create table temp_tk as SELECT * FROM trade_keyword  WHERE keyword_name = 'StrategyType' AND trade_id NOT IN (SELECT trade_id FROM ps_strategy_info)
/

CREATE OR REPLACE PROCEDURE update_strategy_info AS
	BEGIN
		DECLARE
			s_keyword_value VARCHAR2(100);
			nextid          NUMBER := 0;

 			CURSOR c_keywords IS SELECT DISTINCT keyword_value FROM temp_tk;
		BEGIN
 			SELECT coalesce(max(last_id) + 1,1001) INTO nextid FROM calypso_seed WHERE seed_name = 'PricingSheetStrategyInfo';
            OPEN c_keywords;
            	LOOP
            		FETCH c_keywords INTO s_keyword_value;
					EXIT WHEN c_keywords%NOTFOUND;
						INSERT INTO ps_strategy_info (strategy_id,strategy_name,trade_id) SELECT nextid, SUBSTR(keyword_value, 1, INSTR(keyword_value, ':', 1) - 1), trade_id 
						FROM temp_tk 
						WHERE keyword_name = 'StrategyType' 
							AND keyword_value = s_keyword_value 
							AND trade_id NOT IN (SELECT trade_id FROM ps_strategy_info);
					nextid := nextid + 1;
				END LOOP;
			CLOSE c_keywords;
		END;
	END update_strategy_info;
/
 
begin
	update_strategy_info;
end;
/
DROP PROCEDURE update_strategy_info
/
update calypso_seed set last_id = (select coalesce(max(strategy_id) + 1,1001) from ps_strategy_info) WHERE seed_name = 'PricingSheetStrategyInfo'
/
drop table temp_tk
/