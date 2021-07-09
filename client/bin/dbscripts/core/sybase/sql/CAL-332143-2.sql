update domain_values set name = 'analysisServer' where name = 'buySideServer'
GO
delete from domain_values where value = 'buysideserver1'
GO
delete from domain_values where value = 'buysideserver2'
GO
delete from domain_values where value = 'buysideserver3'
GO