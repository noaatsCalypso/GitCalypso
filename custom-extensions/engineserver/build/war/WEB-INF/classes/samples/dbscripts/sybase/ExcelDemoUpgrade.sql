/* Table to handle the excel products */
CREATE TABLE product_excelproduct (
	product_id	_ProductId NOT NULL,
	product_type	_LongName NOT NULL,
	attribute_blob	_LongBinary NOT NULL,
	CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
	(product_id))
go

INSERT INTO domain_values (name,value,description) VALUES
('domainName','ExcelProduct.Pricer','Pricers for Excel based products')
go

INSERT INTO domain_values (name,value,description) VALUES
('productClass','Excel','Excel Product Class')
go

INSERT INTO domain_values (name,value,description) VALUES
('productFamily','Excel','Excel Product Family')
go

/* This allows us to find the Pricer in the PricerConfig */
INSERT INTO domain_values (name,value,description) VALUES
('productType','ExcelProduct','Excel Product Type')
go

