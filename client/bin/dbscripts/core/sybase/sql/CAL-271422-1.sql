update report_win_def set use_pricing_env=1 where def_name = 'CompositeAnalysis'
go
/* diff */ 
INSERT INTO calypso_seed ( last_id, seed_name, seed_alloc_size ) VALUES ( 1000, 'Fund_Rebate_Schedule', 100 )
go

/*  Update Version */
UPDATE calypso_info
    SET major_version=11,
        minor_version=1,
        sub_version=0,
        patch_version='002',
        version_date='20100305'
go

