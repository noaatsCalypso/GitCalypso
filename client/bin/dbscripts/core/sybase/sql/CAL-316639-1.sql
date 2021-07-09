add_column_if_not_exists 'product_eq_struct_option','is_performance_based','numeric null'
go
update product_eq_struct_option set performance_type=(case is_performance_based  when 1 then 'Performance' else 'Quantity'  end) where is_performance_based is not null
go

