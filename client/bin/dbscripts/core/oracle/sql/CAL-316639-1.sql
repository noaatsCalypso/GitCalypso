begin
add_column_if_not_exists ('product_eq_struct_option','is_performance_based','number null');
end;
/
Update Product_Eq_Struct_Option Set Performance_Type=(Case Is_Performance_Based  When 1 Then 'Performance' Else 'Quantity'  End) Where Is_Performance_Based Is Not Null
;

