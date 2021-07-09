-- several mark PLType enum moved to FrameworkEffectiveProductType enum.
-- to reflect this change, move official_pl_mark.pl_type to official_pl_mark.effective_product_type and set official_pl_mark.pl_type='Framework'
-- tables affected: official_pl_mark, official_pl_mark_hist official_pl_aggregate_item, official_pl_crystallized_mark 

update official_pl_mark 
set    effective_product_type = (case pl_type 
                                 when 'Inactive PL Selloff' then 'PL Selloff'
                                 when 'Inactive PL Sellback' then 'PL Sellback'
                                 else pl_type
                                 end),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || char(38) || 'L',
                            'Cost of Funding for Crystallized P' || char(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
go

update official_pl_mark 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
go

update official_pl_mark_hist 
set    effective_product_type = (case pl_type 
                                 when 'Inactive PL Selloff' then 'PL Selloff'
                                 when 'Inactive PL Sellback' then 'PL Sellback'
                                 else pl_type
                                 end),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || char(38) || 'L',
                            'Cost of Funding for Crystallized P' || char(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
go

update official_pl_mark_hist 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
go


update official_pl_aggregate_item 
set    effective_product_type = (case pl_type 
                                 when 'Inactive PL Selloff' then 'PL Selloff'
                                 when 'Inactive PL Sellback' then 'PL Sellback'
                                 else pl_type
                                 end),
       pl_type='Framework'
where  pl_type in ('Cost of Funding',
                            'Crystallized P' || char(38) || 'L',
                            'Cost of Funding for Crystallized P' || char(38) || 'L',
                            'PL Selloff',
                            'PL Sellback',
                            'Inactive PL Selloff',
                            'Inactive PL Sellback')
go

update official_pl_aggregate_item 
set    position_or_trade = 'com.calypso.tk.core.Trade',
       effective_product_type = position_or_trade,
       pl_type='Framework'
where  position_or_trade in ('Cost of Funding')
go

update official_pl_crystallized_mark 
set    effective_product_type = pl_type
where  pl_type in ('Crystallized P' || char(38) || 'L', 'Cost of Funding for Crystallized P' || char(38) || 'L')
go

UPDATE official_pl_crystallized_mark set pl_type = 'Framework'
go


