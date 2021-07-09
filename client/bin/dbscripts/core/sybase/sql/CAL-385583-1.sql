
DELETE
FROM investment_cash_position
WHERE position_id IN
  (SELECT p.position_id
  FROM official_pl_mark m
  RIGHT JOIN investment_cash_position p
  ON m.trade_id = p.position_id
  INNER JOIN
	(SELECT treasury_portfolio_id,
	  book_id,
	  currency
	FROM investment_cash_position
	GROUP BY treasury_portfolio_id,
	  book_id,
	  currency
	HAVING COUNT(*) > 1
	) d
  ON p.treasury_portfolio_id = d.treasury_portfolio_id
  AND p.book_id              =d.book_id
  AND p.currency             =d.currency
  WHERE m.mark_id           IS NULL
  )
GO
