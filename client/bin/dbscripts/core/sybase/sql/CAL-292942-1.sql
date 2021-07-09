UPDATE product_ca
SET ca_rounding = ca_rounding + ' (FR)'
WHERE ca_rounding IN ('Nearest Half Share', 'Round Up', 'Not Available', 'Natural Rounding', 'Round Down(Cash In Lieu)')
go

UPDATE product_ca
SET ca_rounding = ca_rounding + '(FR)'
WHERE ca_rounding = 'Round Down(No Cash)'
go
