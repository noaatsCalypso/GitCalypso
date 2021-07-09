ALTER TABLE unitized_fund ADD
	leverage FLOAT,
	expense_ratio FLOAT,
    description varchar(500),
    agent varchar(128)
go
	
ALTER TABLE mandate ADD
	leverage FLOAT,
	expense_ratio FLOAT,
    description varchar(500),
    agent varchar(128)
go