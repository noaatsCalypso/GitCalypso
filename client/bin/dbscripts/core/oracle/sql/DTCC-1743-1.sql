DECLARE dtcc_seed_exists integer;
BEGIN
    select count(*) into dtcc_seed_exists FROM calypso_seed WHERE seed_name = 'ReportingEtdPosition';
    IF dtcc_seed_exists = 0 THEN
        INSERT INTO calypso_seed (last_id, seed_name, seed_alloc_size) values(0, 'ReportingEtdPosition', 1);
        COMMIT;
    END IF;
END;
;