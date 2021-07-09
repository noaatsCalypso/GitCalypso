insert into calypso_seed select isnull(max(j.job_id)+1,100), 'limit_job', 100 from ers_limit_job j
GO