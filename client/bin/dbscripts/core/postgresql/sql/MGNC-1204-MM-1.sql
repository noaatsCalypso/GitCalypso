/* For Margin Calculator Migration to Calculation Set we will drop all the result and */
truncate table cm_calculation_summary
;
truncate table cm_calculation_summary_hist
;
truncate table cm_result
;
truncate table cm_result_errors
;
truncate table cm_result_node
;
truncate table cm_result_hist
;
truncate table cm_result_errors_hist
;
truncate table cm_result_node_hist
;
