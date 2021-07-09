UPDATE credit_rating
SET debt_seniority          = 'ANY'
WHERE upper(debt_seniority) = 'ANY'
GO