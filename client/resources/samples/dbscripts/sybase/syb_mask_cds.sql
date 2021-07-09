/* masking script...   */ 

/* -----------------------------------------------*/
/* masks cds trades that are not part of a basket */
/* by moving the ref_entity_id down 1 row         */
/* for trade baskets we mask the basket name      */
/* run on a test db or copy of a production db    */
/* -----------------------------------------------*/



/* Lets backup both tables that we will update */

select * into product_cds_bak from product_cds
go
select * into ref_entity_bak from ref_entity
go           


/* Build a temp table table containing all we need  */
/* in product_id order.                             */
/* We need a temp table because product_cds table   */
/* contains other things we dont want to update so  */
/* there is gaps in ids, and ids are not in any     */
/* order in the table                               */
/*                                                  */

create table t1 (
 product_id int,
 ref_entity_id int,
 ref_entity_type varchar(255),
 product_desc varchar(255),
 temp_id int IDENTITY)
go


insert into t1 
select product_cds.product_id, 
          ref_entity.ref_entity_id,
          ref_entity.ref_entity_type,
          product_desc.product_type
   from product_cds , ref_entity , product_desc 
   where product_cds.ref_entity_id = ref_entity.ref_entity_id
   and product_cds.product_id = product_desc.product_id  
   and ref_entity.ref_entity_type='ReferenceEntitySingle'
   and product_desc.product_type = 'CreditDefaultSwap' 
   and product_cds.product_id NOT IN (               
       select product_id from template_product)     
order by product_cds.product_id                            
go


/* now add a temporary extra column to product_cds  */
/* so we find out wwhich rows we want to update     */

alter table product_cds add temp_id int NULL          
go


/* update our temp_id on product_cds from our temp table */

update product_cds set temp_id = 
   (select temp_id from t1 
    where t1.product_id = product_cds.product_id)
   where exists
    (select 1 from t1 
    where t1.product_id = product_cds.product_id)
go 



/* now update our ref_entity_id from our temp table  */
/* shifting the ref_entity_id down a row in the      */
/* process                                           */

update product_cds set ref_entity_id =
    (select t1.ref_entity_id from t1
       where t1.temp_id = product_cds.temp_id+1)
     where exists
     (select 1 from t1 
       where t1.temp_id = product_cds.temp_id+1)
go      


/* Now update the remaining ref_entity_id that didnt get updated  */

update product_cds set ref_entity_id = ( select ref_entity_id from t1 where temp_id = 1)
where product_cds.temp_id = (select max(temp_id) from product_cds)
go


/* Now lets hide Basket Names  */

update ref_entity 
    set ref_entity_name = 'masked'
         where ref_entity_type in (
				'ReferenceEntityBasket',
				'ReferenceEntityNthLoss',
				'ReferenceEntityNthDefault')
go


/* clean up */

drop table t1
go
alter table product_cds drop temp_id
go


/* now lets delete any saved reports */

truncate table analysis_output
go
truncate table an_output_header
go
truncate table an_output_total
go
truncate table an_output_value
go
truncate table an_output_zip
go
truncate table an_output_zpart
go

/* all done */
