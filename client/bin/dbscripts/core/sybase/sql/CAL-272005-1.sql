update trade
set exchange_id=0
where product_id in (select product_id from product_desc where product_type in ('CapFloor','CappedSwap','Cash','EquitySwapHull','ExoticAccretingSwap','FRA','FX','FXForward','FXOption','FXSwap','SingleSwapLeg',
'SpreadCapFloor','SpreadSwap','StructuredProduct','Swap','Swaption','XCCySwap','NDS'))
go

UPDATE calypso_info
    SET major_version=14,
        minor_version=2,
        sub_version=0,
        patch_version='004',
        version_date='20150228'
go 
