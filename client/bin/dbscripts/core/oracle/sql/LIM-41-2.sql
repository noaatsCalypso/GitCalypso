INSERT INTO CALYPSO_SEED (LAST_ID, SEED_NAME, SEED_ALLOC_SIZE) VALUES ((select nvl(MAX(job_id),100)+1 from ers_limit_job), 'limit_job', '100')
;