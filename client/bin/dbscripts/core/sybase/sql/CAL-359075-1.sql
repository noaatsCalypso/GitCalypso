create or replace procedure sp_pl_methodology_driver as
	begin
		declare 
			@n1 int, 
			@n2 int, 
			@n3 int, 
			@pl_meth_driver varchar(32), 
			@book_attr_name varchar(32) 
			select @n1=count(distinct pl_methodology_driver) from pl_methodology_config
			select @n2=count(*) FROM book_attribute WHERE is_pl_methodology_driver = 1
  			if (@n1 > 1)
  			begin
      			raiserror 20001 'Error occured - Found multiple methodology drivers in pl_methodology_config table'
  			end	
  
  			if (@n2 > 1)
  			begin
        		raiserror 20001 'Error occured - there should be only one book attribute set to pl methodology driver in book_attribute table'
  			end
  			 
  			
  			if (@n1 = 1)
  			begin 
	  			 
  				select @pl_meth_driver=pl_methodology_driver FROM pl_methodology_config 
  	
  				if (@n2 = 0)
  				begin
  					select @n3=count(*) FROM book_attribute WHERE attribute_name=@pl_meth_driver
  					if (@n3 = 0)
  					begin
  						exec ('insert into book_attribute(attribute_name,is_pl_methodology_driver) VALUES (@pl_meth_driver, 1)') 
  					end
  					if (@n3 = 1)
  					begin
						exec ('update book_attribute SET is_pl_methodology_driver = 1 WHERE attribute_name=@pl_meth_driver')
  					end
  				end
  				if (@n2 = 1)
  				begin
  	  				select @book_attr_name=attribute_name FROM book_attribute WHERE is_pl_methodology_driver = 1	
  	
	  				if (@pl_meth_driver != @book_attr_name)
	  				begin
	  					raiserror 20001 'Error occured - Pl methodology driver in pl_methodology_config table do not match Pl methodology driver book attribute'
	  				end
  				end  
  			end  
	end
go

exec sp_pl_methodology_driver
go
drop procedure sp_pl_methodology_driver
go
