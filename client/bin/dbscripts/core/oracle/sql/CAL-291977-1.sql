-- several mark PLType enum moved to FrameworkEffectiveProductType enum.
-- to reflect this change, move official_pl_mark.pl_type to official_pl_mark.effective_product_type and set official_pl_mark.pl_type='Framework'
-- tables affected: official_pl_mark, official_pl_mark_hist official_pl_aggregate_item, official_pl_crystallized_mark 
-- Optionally, use PARALLEL(4) Oracle hint to shorten execution time.

update /*+ parallel(8) */ official_pl_mark 
set    effective_product_type = decode(pl_type,'Inactive PL Selloff','PL Selloff','Inactive PL Sellback','PL Sellback',pl_type),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || chr(38) || 'L',
                            'Cost of Funding for Crystallized P' || chr(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
;

update /*+ parallel(8) */ official_pl_mark 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
;

update /*+ parallel(8) */ official_pl_mark_hist 
set    effective_product_type = decode(pl_type,'Inactive PL Selloff','PL Selloff','Inactive PL Sellback','PL Sellback',pl_type),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || chr(38) || 'L',
                            'Cost of Funding for Crystallized P' || chr(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
;

update /*+ parallel(8) */ official_pl_mark_hist 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
;


update /*+ parallel(8) */ official_pl_aggregate_item 
set    effective_product_type = decode(pl_type,'Inactive PL Selloff','PL Selloff','Inactive PL Sellback','PL Sellback',pl_type),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || chr(38) || 'L',
                            'Cost of Funding for Crystallized P' || chr(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
;

update /*+ parallel(8) */ official_pl_aggregate_item 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
;

update /*+ parallel(8) */ official_pl_crystallized_mark 
set    effective_product_type = pl_type
where  pl_type in ('Crystallized P' || chr(38) || 'L', 'Cost of Funding for Crystallized P' || chr(38) || 'L')
;

UPDATE /*+ parallel(8) */ official_pl_crystallized_mark set pl_type = 'Framework'
;


