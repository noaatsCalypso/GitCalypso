create or replace procedure rename_pws_items_columns as
begin
  exec ('select * into am_grouping_columns_bk from am_grouping_columns')
  exec ('select * into am_filtering_columns_bk  from am_filtering_columns')
  exec ('select * into am_columnset_main_columns_bk from  am_columnset_main_columns')
  exec ('select * into am_columnset_pivot_columns_bk from   am_columnset_pivot_columns')
  exec ('select * into am_columnset_group_columns_bk from  am_columnset_group_columns')
  exec ('select * into am_columnset_break_columns_bk from  am_columnset_breakdown_columns')
  exec ('select * into am_coloring_colord_columns_bk from am_coloring_colored_columns')
  exec ('select * into am_unit_denominator_column_bk from  am_unit_denominator_column')
  exec ('select * into am_columnset_config_bk from am_columnset_configuration')
  exec ('select * into am_columnset_profiles_bk from am_columnset_profiles')
  exec ('select * into am_columnset_widgets_bk from am_columnset_widgets')
  exec ('select * into am_columnset_actions_bk from am_columnset_actions')
  exec ('select * into am_unit_configuration_bk from am_unit_configuration')
  exec ('select * into am_unit_profiles_bk from am_unit_profiles')
  exec ('select * into am_grouping_configuration_bk from am_grouping_configuration')
  exec ('select * into am_grouping_profiles_bk from am_grouping_profiles')
  exec ('select * into am_filtering_configuration_bk from am_filtering_configuration')
  exec ('select * into am_filtering_profiles_bk from am_filtering_profiles')
  exec ('select * into am_coloring_configuration_bk from am_coloring_configuration')
  exec ('select * into am_coloring_profiles_bk from am_coloring_profiles')
  exec ('select * into am_coloring_rule_config_bk from am_coloring_rule_configuration')
  exec ('truncate table am_grouping_columns')
  exec ('truncate table am_filtering_columns')
  exec ('truncate table am_columnset_main_columns')
  exec ('truncate table am_columnset_pivot_columns')
  exec ('truncate table am_columnset_group_columns')
  exec ('truncate table am_columnset_breakdown_columns')
  exec ('truncate table am_unit_denominator_column')
  exec ('truncate table am_columnset_configuration')
  exec ('truncate table am_columnset_profiles')
  exec ('truncate table am_columnset_widgets')
  exec ('truncate table am_columnset_actions')
  exec ('truncate table am_unit_configuration')
  exec ('truncate table am_unit_profiles')
  exec ('truncate table am_grouping_configuration')
  exec ('truncate table am_grouping_profiles')
  exec ('truncate table am_filtering_configuration')
  exec ('truncate table am_filtering_profiles')
  exec ('truncate table am_coloring_configuration')
  exec ('truncate table am_coloring_profiles')
  exec ('truncate table am_coloring_rule_configuration')

end
go

if exists (select 1 from sysobjects where name='am_grouping_columns')
begin 
 exec rename_pws_items_columns
end
go

drop procedure rename_pws_items_columns
go