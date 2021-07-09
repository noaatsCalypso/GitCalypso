-- A change to always show the ccy pair in PairPosRef was done in  CAL-292125 (v15.0)
-- this sql script will 
--    1. migrate any plunits in the pre-v15.0 db with non-PairPosRef to PairPosRef in official_pl_unit table 
--    2. if any plunit referenced in mark table is in non-PairPosRef, change to plunit of the one in PairPosRef 

/*
 * ==========================  CUSTOMIZE DATE BELOW ==========================
 */
create table temp_opl_latest_dates 
as select pl_config_id, valuation_date from official_pl_mark where 1=2
;

-- find last date marks were generated for each pl config using pre-v15.0 Calypso
-- only marks up-to and including this date will be updated
insert into temp_opl_latest_dates (pl_config_id, valuation_date)
select pl_config_id, max(valuation_date) valuation_date from official_pl_mark group by pl_config_id
;

/*
 * ===========================================================================
 */


create table temp_opl_uniq_currency_pair
as
select distinct currency_pair, '   ' as primary_currency, '   ' as quoting_currency, currency_pair as pair_pos_ref_currency_pair 
from official_pl_unit 
where currency_pair like '%/%' -- ex. JPY/USD
;

update temp_opl_uniq_currency_pair set pair_pos_ref_currency_pair = null
;

update temp_opl_uniq_currency_pair
set primary_currency=substr(currency_pair,1, instr(currency_pair,'/',1)-1),
    quoting_currency=substr(currency_pair,instr(currency_pair,'/',1)+1, length(currency_pair) - instr(currency_pair,'/',1))
;

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR 
EUR/USD          EUR                  USD	 	 
*/

/* delete ones that already have pair_pos_ref_b set to true */
delete from temp_opl_uniq_currency_pair where currency_pair in (select primary_currency || '/' || quoting_currency from currency_pair where pair_pos_ref_b = 1)
;

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR 
==> deleted EUR/USD          EUR                  USD	 	 
*/

/* map currency_pair with pair_pos_ref_b=false to one that is true */
MERGE
INTO    temp_opl_uniq_currency_pair trg
USING   (
        SELECT  primary_currency,  quoting_currency
        FROM    currency_pair
        WHERE   pair_pos_ref_b = 1
        ) src
ON      (trg.primary_currency = src.quoting_currency
        AND trg.quoting_currency = src.primary_currency
        )
WHEN MATCHED THEN UPDATE
    SET trg.pair_pos_ref_currency_pair = src.primary_currency || '/' || src.quoting_currency
;

/*
select * from temp_opl_uniq_currency_pair 

CURRENCY_PAIR    PRIMARY_CURRENCY     QUOTING_CURRENCY	 PAIR_POS_REF_CURRENCY_PAIR
USD/EUR          USD                  EUR                EUR/USD
*/

-- clean up
delete from temp_opl_uniq_currency_pair where pair_pos_ref_currency_pair is null
;

/* we have the temp table setup now with mapping between currency pair in plunit table (CURRENCY_PAIR) to what it should be (in PAIR_POS_REF_CURRENCY_PAIR). */

/* select from plunit interested currency pairs, plus new_pl_unit_id mapping column */
create table temp_opl_unit_map
as
select u.*, u.pl_unit_id as new_pl_unit_id, p.pair_pos_ref_currency_pair
from official_pl_unit u, temp_opl_uniq_currency_pair p
where u.currency_pair = p.currency_pair
;

/* initialize new_pl_unit_id column to 0 (not null since this column is not nullable */
update temp_opl_unit_map set new_pl_unit_id = 0
;

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
        SELECT  trg.pl_unit_id, trg.currency,trg.currency_pair, src.pl_unit_id,src.book_id,src.strategy,src.trader,src.desk,src.currency,src.currency_pair,src.po_id,src.is_by_trade
        FROM    official_pl_unit src,  temp_opl_unit_map trg
        where    (trg.book_id = src.book_id OR ((trg.book_id IS NULL) AND (src.book_id IS NULL)))
        AND (trg.strategy = src.strategy OR ((trg.strategy IS NULL) AND (src.strategy IS NULL)))
        AND (trg.trader = src.trader OR ((trg.trader IS NULL) AND (src.trader IS NULL)))
        AND (trg.desk = src.desk OR ((trg.desk IS NULL) AND (src.desk IS NULL)))
        AND (trg.currency = src.currency)
        AND (trg.pair_pos_ref_currency_pair = src.currency_pair)
        AND (trg.po_id = src.po_id)
        AND (trg.is_by_trade = src.is_by_trade)
*/

MERGE
INTO    temp_opl_unit_map trg
USING   (
        SELECT  pl_unit_id,book_id,strategy,trader,desk,currency,currency_pair,po_id,is_by_trade
        FROM    official_pl_unit
        ) src
ON      ((trg.book_id = src.book_id OR ((trg.book_id IS NULL) AND (src.book_id IS NULL)))
        AND (trg.strategy = src.strategy OR ((trg.strategy IS NULL) AND (src.strategy IS NULL)))
        AND (trg.trader = src.trader OR ((trg.trader IS NULL) AND (src.trader IS NULL)))
        AND (trg.desk = src.desk OR ((trg.desk IS NULL) AND (src.desk IS NULL)))
        AND (trg.currency = src.currency)
        AND (trg.pair_pos_ref_currency_pair = src.currency_pair)  -- this is the important bit
        AND (trg.po_id = src.po_id)
        AND (trg.is_by_trade = src.is_by_trade)
        )
WHEN MATCHED THEN UPDATE
    SET trg.new_pl_unit_id = src.pl_unit_id
;

/*
select * from temp_opl_unit_map

PL_UNIT_ID     BOOK_ID     STRATEGY     TRADER     DESK     CURRENCY     CURRENCY_PAIR     PO_ID     IS_BY_TRADE     NEW_PL_UNIT_ID (*)    PAIR_POS_REF_CURRENCY_PAIR
1004           67696                                        EUR          USD/EUR           1101      0               1003                  EUR/USD
1002           67696                                        USD          USD/EUR           1101      0               1002                  EUR/USD

*/

/* Part2) now the ones with new_pl_unit_id=0 are ones that do not have "similar", for these just modify the official_pl_unit.currency_pair */
MERGE
INTO    official_pl_unit trg
USING   (
        SELECT  pl_unit_id, currency_pair,pair_pos_ref_currency_pair
        FROM    temp_opl_unit_map
        WHERE   new_pl_unit_id = 0
        ) src
ON      (trg.pl_unit_id = src.pl_unit_id
        )
WHEN MATCHED THEN UPDATE
    SET trg.currency_pair = src.pair_pos_ref_currency_pair
;

/* Part1) now handle "similar" ones - note that we need to do this in two parts - i.e create this temp table 
   then merge because oracle merge does not allow update of a column used in join (in this case pl_unit_id) */ 
create table temp_official_pl_mark
as
        select /*+ PARALLEL(8) */ m.mark_id, m.pl_unit_id, t.new_pl_unit_id 
        FROM    temp_opl_unit_map t, official_pl_mark m, temp_opl_latest_dates dt
        WHERE   t.pl_unit_id = m.pl_unit_id
        AND     t.new_pl_unit_id !=0
        AND     m.pl_config_id = dt.pl_config_id
        AND     m.valuation_date <= dt.valuation_date
;

/*
select * from temp_official_pl_mark

MARK_ID	 PL_UNIT_ID	 NEW_PL_UNIT_ID
1002	1002	1001
1003	1004	1003
1005	1002	1001
1009	1002	1001

...

*/

MERGE
INTO    /*+ PARALLEL(8) */ official_pl_mark trg
USING   (
        SELECT  mark_id, new_pl_unit_id
        FROM    temp_official_pl_mark
        ) src
ON      (trg.mark_id = src.mark_id
        )
WHEN MATCHED THEN UPDATE
    SET trg.pl_unit_id = src.new_pl_unit_id
;

drop table temp_official_pl_mark
;

drop table temp_opl_unit_map
;

drop table temp_opl_uniq_currency_pair
;

drop table temp_opl_latest_dates
;
