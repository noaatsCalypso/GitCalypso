IF NOT EXISTS (SELECT 1 FROM calypso_seed WHERE seed_name = 'ReportingEtdPosition')
BEGIN
    INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) values(0, 'ReportingEtdPosition', 1)
    COMMIT
END
go