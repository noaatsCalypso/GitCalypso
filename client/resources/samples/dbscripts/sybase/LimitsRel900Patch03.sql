update ers_limit_usage set value_date = usage_time
update ers_limit_usage set value_date_julian = julian_offset
go

update ers_limit set is_predeal=1
go

insert INTO ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Flow Types', 'PRINCIPAL')
insert INTO ers_measure_parms(measure,parameter_name,parameter_value) VALUES ('Settlement', 'Ignore CLS', 'No')
go

DELETE ers_rating_list
GO
INSERT INTO ers_rating_list(rating_key, rating_name) VALUES('Rating1', 'S&P Rating')
INSERT INTO ers_rating_list(rating_key, rating_name) VALUES('Rating2', 'Moody Rating')
INSERT INTO ers_rating_list(rating_key, rating_name) VALUES('Rating3', 'Fitch Rating')
go
