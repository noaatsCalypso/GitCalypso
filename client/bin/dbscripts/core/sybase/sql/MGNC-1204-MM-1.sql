/* For Margin Calculator Migration to Calculation Set we will drop all the result and */
truncate table cm_calculation_summary
go
truncate table cm_calculation_summary_hist
go
truncate table cm_result
go
truncate table cm_result_errors
go
truncate table cm_result_node
go
truncate table cm_result_hist
go
truncate table cm_result_errors_hist
go
truncate table cm_result_node_hist
go
