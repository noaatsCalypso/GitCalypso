
CREATE OR REPLACE FORCE VIEW "RMS_POS_VIEW" ("ACCOUNT_ID", "PRODUCT_ID", "TIME_ID", "INSTANCE_ID", "SETT_AMT_L", "SETT_AMT_S")
AS
  SELECT ACCOUNT_ID,PRODUCT_ID,
    TIME_ID,INSTANCE_ID,
    SUM(BOOK_VALUE_LONG)  AS SETT_AMT_L,
    SUM(BOOK_VALUE_SHORT) AS SETT_AMT_S
  FROM RMS_POS_RISK
  GROUP BY ACCOUNT_ID,PRODUCT_ID, TIME_ID,INSTANCE_ID
;

CREATE OR REPLACE FORCE VIEW "RMS_POS_QTY_VIEW" ("ACCOUNT_ID", "PRODUCT_ID", "TIME_ID", "INSTANCE_ID", "QTY_LONG", "QTY_SHORT", "QTY", "QUANTITY_SIGN")
AS
  SELECT ACCOUNT_ID,PRODUCT_ID,
    TIME_ID,INSTANCE_ID,
    SUM(qty_long)  AS QTY_LONG,
    SUM(qty_short) AS QTY_SHORT, 
    SUM(quantity) AS QTY,
    QUANTITY_SIGN
  FROM RMS_ACCT_POS
  GROUP BY ACCOUNT_ID,PRODUCT_ID, TIME_ID,INSTANCE_ID, QUANTITY_SIGN
;


create or replace
PROCEDURE  upd_pos_risk (time_id IN number) 
IS
  t_id number := time_id;
BEGIN
    delete from rms_pos_risk rpr where rpr.time_id = t_id;
    delete from rms_pos_risk_stress rprs where rprs.time_id = t_id;
    
  
	insert into RMS_POS_RISK (
  PRODUCT_ID,TIME_ID,ACCOUNT_ID,SETTLE_DAYS,QTY_LONG,QTY_SHORT,BOOK_VALUE_LONG,BOOK_VALUE_SHORT,LFE,
  SFE,VOLUME,MTM,SV,OPTION_PREMIUM,
  GAMMA_LONG,VEGA_LONG,THETA_LONG,RHO_LONG,DELTA_LONG,
  GAMMA_SHORT,VEGA_SHORT,THETA_SHORT,RHO_SHORT,DELTA_SHORT,
  FRONT_MONTH,NPV,HYPPL
  )
  SELECT 
  pr.product_id, ap.time_id, ap.account_id, ap.settle_days, ap.qty_long, ap.qty_short, 
  ap.book_value_long, ap.book_value_short, ap.qty_long * pr.future_equiv,
  -ap.qty_short * pr.future_equiv, pr.daily_volume, ap.quantity * pr.mtm, ap.quantity * pr.sv,
  ap.quantity * pr.option_premium, 
  ap.qty_long * pr.gamma,
  ap.qty_long * pr.vega,
  ap.qty_long * pr.theta,
  ap.qty_long * pr.rho,
  ap.qty_long * pr.delta,
  ap.qty_short * pr.gamma,
  ap.qty_short * pr.vega,
  ap.qty_short * pr.theta,
  ap.qty_short * pr.rho,
  ap.qty_short * pr.delta,
  ap.front_month,
  ap.quantity *pr.mtm - (nvl(ap.book_value_long,0)+nvl(ap.book_value_short,0))*ap.fx_base,
  ap.quantity * pr.hyppl
  FROM RMS_ACCT_POS ap, RMS_PRODUCT_RISK pr
  where ap.time_id = pr.time_id
  and ap.product_id = pr.product_id
  and ap.time_id = t_id;
  
  
  insert into RMS_POS_RISK_STRESS (
  ACCOUNT_ID,PRODUCT_ID,TIME_ID,MEASURE_ID,AMOUNT_LONG_BASE,AMOUNT_SHORT_BASE,AMOUNT_BASE,STRESS_AMOUNT,GAIN_DISCOUNT
  )
 SELECT ap.account_id, prs.product_id, ap.time_id, prs.measure_id, ap.qty_long * prs.amount_base, 
  ap.qty_short * prs.amount_base, ap.qty * prs.amount_base,
  prs.stress_amount,prs.gain_discount
  FROM RMS_POS_QTY_VIEW ap, rms_product_risk_stress prs
  where ap.time_id = prs.time_id
  and ap.product_id = prs.product_id
  and ap.time_id = t_id; 
END upd_pos_risk;
;

create or replace procedure sp_upd_stresspl_postprocess(TIME_ID in number, MEASUREID_RANGE_START in number, MEASUREID_RANGE_END in number)
is 
  T_ID number := TIME_ID;
  MTM_STRESSPL_1 float;
  NPV float; 
  BOOKBSIS_STRESSPL_1 float;
  SHOCK float;
  NET_SV float;
  PL float;
begin 
for SCENMEASURE in (select SCEN.MEASURE_ID as SCEN_ID from RMS_SCENARIO_MEASURE SCEN where SCEN.category='ST' and SCEN.IS_SCENARIO = 1) LOOP
  for POSRISKSTRESS in (select POS.ACCOUNT_ID as ACCOUNT_ID,POS.PRODUCT_ID as PROD_ID,POS.AMOUNT_BASE as STRESSPL, POS.GAIN_DISCOUNT as GDF, POS.STRESS_AMOUNT as SHOCK from RMS_POS_RISK_STRESS POS where POS.MEASURE_ID = SCENMEASURE.SCEN_ID and POS.TIME_ID = T_ID) LOOP
    select SUM(POSRISK.NPV) into NPV from RMS_POS_RISK POSRISK where POSRISK.ACCOUNT_ID = POSRISKSTRESS.ACCOUNT_ID and POSRISK.PRODUCT_ID = POSRISKSTRESS.PROD_ID and POSRISK.TIME_ID=T_ID;
    select SUM(nvl((case when ACCTPOS.SETTLE_METHOD >=0 then ACCTPOS.BOOK_VALUE_LONG*ACCTPOS.FX_BASE else null end),0) + nvl((case when ACCTPOS.SETTLE_METHOD >=0 then ACCTPOS.BOOK_VALUE_SHORT*ACCTPOS.FX_BASE else null end),0)) into NET_SV from RMS_ACCT_POS ACCTPOS where ACCTPOS.ACCOUNT_ID = POSRISKSTRESS.ACCOUNT_ID and ACCTPOS.PRODUCT_ID = POSRISKSTRESS.PROD_ID and ACCTPOS.TIME_ID=T_ID;
      if POSRISKSTRESS.STRESSPL >0 and POSRISKSTRESS.GDF is not null then
          MTM_STRESSPL_1  := (POSRISKSTRESS.STRESSPL *POSRISKSTRESS.GDF) + NPV;
      else 
          MTM_STRESSPL_1  := POSRISKSTRESS.STRESSPL + NPV;          
      end if;
      
      if POSRISKSTRESS.SHOCK is not null then
        PL := (POSRISKSTRESS.SHOCK/100) * NET_SV;
      else
        PL :=0;
      end if;
      
      if  PL >0  and POSRISKSTRESS.GDF is not null then
          BOOKBSIS_STRESSPL_1 := PL * POSRISKSTRESS.GDF; 
        else
          BOOKBSIS_STRESSPL_1 :=PL;
      end if;
         update RMS_POS_RISK_STRESS POSRISKSTRESS1 set POSRISKSTRESS1.MTM_STRESSPL = MTM_STRESSPL_1, POSRISKSTRESS1.BOOKBASIS_STRESSPL = BOOKBSIS_STRESSPL_1 where POSRISKSTRESS1.TIME_ID = T_ID and POSRISKSTRESS1.MEASURE_ID = SCENMEASURE.SCEN_ID and POSRISKSTRESS1.ACCOUNT_ID = POSRISKSTRESS.ACCOUNT_ID and POSRISKSTRESS1.PRODUCT_ID = POSRISKSTRESS.PROD_ID;
  end LOOP;
end LOOP;
  
end SP_UPD_STRESSPL_POSTPROCESS;
;
