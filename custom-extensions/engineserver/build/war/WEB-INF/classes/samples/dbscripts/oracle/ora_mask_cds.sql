/* masking script...   */ 

/* -----------------------------------------------*/
/* masks cds trades that are not part of a basket */
/* by moving the ref_entity_id down 1 row         */
/* for trade baskets we mask the basket name      */
/* run on a test db or copy of a production db    */
/* -----------------------------------------------*/



/* Lets backup both tables that we will update */

create table product_cds_bak as select * from product_cds
;
create table ref_entity_bak as select * from ref_entity
;

/* we need a sequence */

create sequence t1_seq start with 1 increment by 1
;


/* Build a temp table table containing all we need  */
/* in product_id order.                             */
/* We need a temp table because product_cds table   */
/* contains other things we dont want to update so  */
/* there is gaps in ids, and ids are not in any     */
/* order in the table                               */
/*                                                  */
/* You cant create a table with an 'order by' and   */
/* a sequence at the same time - so we have to do   */
/* it in two steps                                  */

create table t1 as 
   select pc.product_id, 
          re.ref_entity_id,
          re.ref_entity_type,
          pd.product_type
   from product_cds pc, ref_entity re, product_desc pd
   where pc.ref_entity_id = re.ref_entity_id
   and pc.product_id = pd.product_id  
   and re.ref_entity_type='ReferenceEntitySingle'
   and pd.product_type = 'CreditDefaultSwap'
   and pc.product_id NOT IN (
       select product_id from template_product) 
   order by pc.product_id
;


/* now add an extra column to hold row position */

alter table t1 add temp_id int
;


/* now update this sequentially from our sequence */

update t1 set temp_id = t1_seq.nextval
;


/* now add a temporary extra column to product_cds  */
/* so we find out wwhich rows we want to update     */

alter table product_cds add temp_id int
;


/* update our temp_id on product_cds from our temp table */

update product_cds set temp_id = 
   (select temp_id from t1 
    where t1.product_id = product_cds.product_id)
   where exists
    (select 1 from t1 
    where t1.product_id = product_cds.product_id)
;



/* now update our ref_entity_id from our temp table  */
/* shifting the ref_entity_id down a row in the      */
/* process                                           */

update product_cds set ref_entity_id =
    (select t1.ref_entity_id from t1
       where t1.temp_id = product_cds.temp_id+1)
     where exists
     (select 1 from t1 
       where t1.temp_id = product_cds.temp_id+1)
;      


/* Now update the remaining ref_entity_id that didnt get updated  */

update product_cds set ref_entity_id =
   (select ref_entity_id from t1 where temp_id = 1)
where product_cds.temp_id = (select max(temp_id) from product_cds)
;


/* Now lets hide Basket Names  */

update ref_entity 
    set ref_entity_name = 'masked-'||to_char(t1_seq.nextval)
         where ref_entity_type in (
				'ReferenceEntityBasket',
				'ReferenceEntityNthLoss',
				'ReferenceEntityNthDefault')
;


/* clean up */

drop table t1
;
drop sequence t1_seq
;
alter table product_cds drop column temp_id
;

/* now lets delete any saved reports */

truncate table analysis_output
;
truncate table an_output_header
;
truncate table an_output_total
;
truncate table an_output_value
;
truncate table an_output_zip
;
truncate table an_output_zpart
;


/* all done */
