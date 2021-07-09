/* If Pay leg is floating and p_type is null , update it with 'None' */
update cap_swap_ext_info set p_type = 'None' from swap_leg, product_swap where cap_swap_ext_info.product_id = swap_leg.product_id and product_swap.product_id = swap_leg.product_id and swap_leg.leg_id=product_swap.pay_leg_id and  swap_leg.leg_type='Float' and cap_swap_ext_info.p_type is  null
;
 
/* If Receive leg is floating and r_type is null , update it with 'None' */
update cap_swap_ext_info set r_type = 'None' from swap_leg, product_swap  where cap_swap_ext_info.product_id = swap_leg.product_id and product_swap.product_id = swap_leg.product_id and swap_leg.leg_id=product_swap.receive_leg_id  and  swap_leg.leg_type='Float' and cap_swap_ext_info.r_type is  null
;
 


/* Creating a temp table paylegtemp and copying  the columns product_id from swap_leg , pay_leg_id from swap and p_type from cap_swap_ext_info 
   if the product_id's from cap_swap_ext_info  and swap_leg matches
   and if  product_id's from swap and swap_leg matches
   and if p_type is not null and either embed_option_type from swap_leg is not equal to p_type or embed_option_type from swap_leg is null
*/
select leg.product_id,swap.pay_leg_id,info.p_type into paylegtemp from cap_swap_ext_info info, product_swap swap, swap_leg leg
where info.product_id=leg.product_id and
swap.product_id = leg.product_id and 
swap.pay_leg_id=leg.leg_id  and 
info.p_type is not null and 
(leg.embed_option_type <> info.p_type  or leg.embed_option_type is null)
;


/* Creating a temp table rcvlegtemp and copying  the columns product_id from swap_leg , receive_leg_id from swap and r_type from cap_swap_ext_info 
   if the product_id's from cap_swap_ext_info  and swap_leg matches
   and if  product_id's from swap and swap_leg matches
   and if r_type is not null and either embed_option_type from swap_leg is not equal to r_type  or embed_option_type from swap_leg is null
*/
select leg.product_id,swap.receive_leg_id,info.r_type into rcvlegtemp from cap_swap_ext_info info, product_swap swap, swap_leg leg
where info.product_id=leg.product_id and
swap.product_id = leg.product_id and 
swap.receive_leg_id=leg.leg_id  and 
info.r_type is not null and 
(leg.embed_option_type <> info.r_type  or leg.embed_option_type is null)
;

/* Update embed_option_type with p_type 
   if product_id from swap_leg and paylegtemp matches and 
   Leg_id from swap and pay_leg_id from paylegtemp matches
*/
 
update swap_leg set embed_option_type = p_type from paylegtemp pt where swap_leg.product_id = pt.product_id and swap_leg.leg_id = pt.pay_leg_id
;

/* Update embed_option_type with r_type 
   if product_id from swap_leg and receivelegtemp matches and 
   Leg_id from swap and receive_leg_id from pcvlegtemp matches
*/
update swap_leg set embed_option_type = r_type from rcvlegtemp rt where swap_leg.product_id = rt.product_id and swap_leg.leg_id = rt.receive_leg_id
;

/* Dropping the temp tables*/
drop table paylegtemp
;

drop table rcvlegtemp
;