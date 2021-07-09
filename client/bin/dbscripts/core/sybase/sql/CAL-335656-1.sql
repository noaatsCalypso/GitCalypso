UPDATE calypso_seed
SET last_id =
  (SELECT MAX(dt.max_id)
  FROM
    (SELECT coalesce (MAX(job_id),0)+1 AS max_id FROM ers_limit_job
    UNION ALL
    SELECT coalesce (last_id,0) AS max_id FROM calypso_seed WHERE seed_name='limit_job'
    ) as dt
  )
WHERE seed_name='limit_job'
GO