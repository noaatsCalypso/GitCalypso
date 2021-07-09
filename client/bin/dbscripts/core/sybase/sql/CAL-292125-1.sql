-- A change to always show the ccy pair in PairPosRef was done in  CAL-292125 (v15.0)
-- this sql script will 
--    1. migrate any plunits in the pre-v15.0 db with non-PairPosRef to PairPosRef in official_pl_unit table 
--    2. if any plunit referenced in mark table is in non-PairPosRef, change to plunit of the one in PairPosRef 

/*
 * ==========================  CUSTOMIZE DATE BELOW ==========================
 */
select pl_config_id, valuation_date 
into temp_opl_latest_dates
from official_pl_mark where 1=2
go

-- find last date marks were generated for each pl config using pre-v15.0 Calypso
-- only marks up-to and including this date will be updated
insert into temp_opl_latest_dates (pl_config_id, valuation_date)
select pl_config_id, max(valuation_date) valuation_date from official_pl_mark group by pl_config_id
go

/*
 * ===========================================================================
 */


select distinct currency_pair, '   ' as primary_currency, '   ' as quoting_currency, currency_pair as pair_pos_ref_currency_pair 
into temp_opl_uniq_currency_pair
from official_pl_unit 
where currency_pair like '%/%' -- ex. JPY/USD
go

update temp_opl_uniq_currency_pair set pair_pos_ref_currency_pair = null
go

update temp_opl_uniq_currency_pair
set primary_currency=substring(currency_pair,1, charindex('/',currency_pair)-1),
    quoting_currency=substring(currency_pair, charindex('/',currency_pair)+1, len(currency_pair) - charindex('/',currency_pair))
go

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR 
EUR/USD          EUR                  USD	 	 
*/

/* delete ones that already have pair_pos_ref_b set to true */
delete from temp_opl_uniq_currency_pair where currency_pair in (select primary_currency || '/' || quoting_currency from currency_pair where pair_pos_ref_b = 1)
go

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR 
==> deleted EUR/USD          EUR                  USD	 	 
*/

/* map currency_pair with pair_pos_ref_b=false to one that is true */
update temp_opl_uniq_currency_pair
set    pair_pos_ref_currency_pair = src.primary_currency || '/' || src.quoting_currency
from   temp_opl_uniq_currency_pair trg, currency_pair src
where  trg.primary_currency = src.quoting_currency
and    trg.quoting_currency = src.primary_currency
and    src.pair_pos_ref_b = 1
go       

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR                EUR/USD
*/

-- clean up
delete from temp_opl_uniq_currency_pair where pair_pos_ref_currency_pair is null
go

/* we have the temp table setup now with mapping between currency pair in plunit table (CURRENCY_PAIR) to what it should be (in PAIR_POS_REF_CURRENCY_PAIR). */

/* select from plunit interested currency pairs, plus new_pl_unit_id mapping column */
select u.*, u.pl_unit_id as new_pl_unit_id, p.pair_pos_ref_currency_pair
into temp_opl_unit_map
from official_pl_unit u, temp_opl_uniq_currency_pair p
where u.currency_pair = p.currency_pair
go

/* initialize new_pl_unit_id column to 0 (not null since this column is not nullable */
update temp_opl_unit_map set new_pl_unit_id = 0
go

/*
select * from temp_opl_unit_map

PL_UNIT_ID     BOOK_ID     STRATEGY     TRADER     DESK     CURRENCY     CURRENCY_PAIR     PO_ID     IS_BY_TRADE     NEW_PL_UNIT_ID     PAIR_POS_REF_CURRENCY_PAIR
1004           67696                                        EUR          USD/EUR           1101      0               0                  EUR/USD
1002           67696                                        USD          USD/EUR           1101      0               0                  EUR/USD

*/

/* some rows in temp_opl_unit_map already have plunit in official_pl_unit table and some dont 
   Part1) for those where we already have plunit (i.e., "similar") find them and use them to set new_pl_unit_id.
   Part2) for those where we dont already have plunit - keep the existing plunit but change the official_pl_unit.currency_pair to pair_pos_ref_currency_pair
   doing this in two parts is needed incase we have two plunits that are all same except for currency_pair - if you just change the currency pair then you will get duplicate exception
*/

/* find existing plunit that has all the same values but currency_pair is pair_pos_ref_currency_pair - use this "similar" plunit to update new_pl_unit_id */

/*
        SELECT  trg.PL_UNIT_ID, trg.CURRENCY,trg.CURRENCY_PAIR, src.PL_UNIT_ID,src.BOOK_ID,src.STRATEGY,src.TRADER,src.DESK,src.CURRENCY,src.CURRENCY_PAIR,src.PO_ID,src.IS_BY_TRADE
        FROM    official_pl_unit src,  temp_opl_unit_map trg
        where    (trg.BOOK_ID = src.BOOK_ID OR ((trg.BOOK_ID IS NULL) AND (src.BOOK_ID IS NULL)))
        AND (trg.STRATEGY = src.STRATEGY OR ((trg.STRATEGY IS NULL) AND (src.STRATEGY IS NULL)))
        AND (trg.TRADER = src.TRADER OR ((trg.TRADER IS NULL) AND (src.TRADER IS NULL)))
        AND (trg.DESK = src.DESK OR ((trg.DESK IS NULL) AND (src.DESK IS NULL)))
        AND (trg.CURRENCY = src.CURRENCY)
        AND (trg.pair_pos_ref_currency_pair = src.CURRENCY_PAIR)
        AND (trg.PO_ID = src.PO_ID)
        AND (trg.IS_BY_TRADE = src.IS_BY_TRADE)
*/

update  temp_opl_unit_map
set     new_pl_unit_id = src.pl_unit_id
from    temp_opl_unit_map trg,
        official_pl_unit src
where   (trg.book_id = src.book_id or ((trg.book_id is null) and (src.book_id is null)))
and     (trg.strategy = src.strategy or ((trg.strategy is NULL) and (src.strategy is null)))
and     (trg.trader = src.trader or ((trg.trader is null) and (src.trader is null)))
and     (trg.desk = src.desk or ((trg.desk is null) and (src.desk is null)))
and     (trg.currency = src.currency)
and     (trg.pair_pos_ref_currency_pair = src.currency_pair)  -- this is the important bit
and     (trg.po_id = src.po_id)
and     (trg.is_by_trade = src.is_by_trade)
go

/*
select * from temp_opl_unit_map

PL_UNIT_ID     BOOK_ID     STRATEGY     TRADER     DESK     CURRENCY     CURRENCY_PAIR     PO_ID     IS_BY_TRADE     NEW_PL_UNIT_ID (*)    PAIR_POS_REF_CURRENCY_PAIR
1004           67696                                        EUR          USD/EUR           1101      0               1003                  EUR/USD
1002           67696                                        USD          USD/EUR           1101      0               1002                  EUR/USD

*/

/* Part2) now the ones with new_pl_unit_id=0 are ones that do not have "similar", for these just modify the official_pl_unit.currency_pair */
update official_pl_unit
set    currency_pair = src.pair_pos_ref_currency_pair
from   official_pl_unit trg,
       temp_opl_unit_map src
where  trg.pl_unit_id = src.pl_unit_id
and    src.new_pl_unit_id = 0
go


/* Part1) now handle "similar" ones */ 
update   official_pl_mark
set      pl_unit_id = t.new_pl_unit_id
from     official_pl_mark m,
         temp_opl_unit_map t, 
         temp_opl_latest_dates dt
where    t.pl_unit_id = m.pl_unit_id
and      t.new_pl_unit_id !=0
and      m.pl_config_id = dt.pl_config_id
and      m.valuation_date <= dt.valuation_date
go



drop table temp_opl_unit_map
go

drop table temp_opl_uniq_currency_pair
go

drop table temp_opl_latest_dates
go
