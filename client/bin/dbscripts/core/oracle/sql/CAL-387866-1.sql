CREATE OR REPLACE
PROCEDURE rename_pws_items_columns
AS
BEGIN
  EXECUTE immediate 'CREATE TABLE am_grouping_columns_bk as (select * from am_grouping_columns)';
  EXECUTE immediate 'CREATE TABLE am_filtering_columns_bk  as (select * from am_filtering_columns)';
  EXECUTE immediate 'CREATE TABLE am_columnset_main_columns_bk as (select * from  am_columnset_main_columns)';
  EXECUTE immediate 'CREATE TABLE am_columnset_pivot_columns_bk as (select * from   am_columnset_pivot_columns)';
  EXECUTE immediate 'CREATE TABLE am_columnset_group_columns_bk as (select * from  am_columnset_group_columns)';
  EXECUTE immediate 'CREATE TABLE am_columnset_break_columns_bk as (select * from  am_columnset_breakdown_columns)';
  EXECUTE immediate 'CREATE TABLE am_coloring_colord_columns_bk as (select * from am_coloring_colored_columns)';
  EXECUTE immediate 'CREATE TABLE am_unit_denominator_column_bk as (select * from  am_unit_denominator_column)';
  EXECUTE immediate 'CREATE TABLE am_columnset_config_bk as (select * from am_columnset_configuration)';
  EXECUTE immediate 'CREATE TABLE am_columnset_profiles_bk as (select * from am_columnset_profiles)';
  EXECUTE immediate 'CREATE TABLE am_columnset_widgets_bk as (select * from am_columnset_widgets)';
  EXECUTE immediate 'CREATE TABLE am_columnset_actions_bk as (select * from am_columnset_actions)';
  EXECUTE immediate 'CREATE TABLE am_unit_configuration_bk as (select * from am_unit_configuration)';
  EXECUTE immediate 'CREATE TABLE am_unit_profiles_bk as (select * from am_unit_profiles)';
  EXECUTE immediate 'CREATE TABLE am_grouping_configuration_bk as (select * from am_grouping_configuration)';
  EXECUTE immediate 'CREATE TABLE am_grouping_profiles_bk as (select * from am_grouping_profiles)';
  EXECUTE immediate 'CREATE TABLE am_filtering_configuration_bk as (select * from am_filtering_configuration)';
  EXECUTE immediate 'CREATE TABLE am_filtering_profiles_bk as (select * from am_filtering_profiles)';
  EXECUTE immediate 'CREATE TABLE am_coloring_configuration_bk as (select * from am_coloring_configuration)';
  EXECUTE immediate 'CREATE TABLE am_coloring_profiles_bk as (select * from am_coloring_profiles)';
  EXECUTE immediate 'CREATE TABLE am_coloring_rule_config_bk as (select * from am_coloring_rule_configuration)';
  EXECUTE immediate 'truncate table am_grouping_columns';
  EXECUTE immediate 'truncate table am_filtering_columns';
  EXECUTE immediate 'truncate table am_columnset_main_columns';
  EXECUTE immediate 'truncate table am_columnset_pivot_columns';
  EXECUTE immediate 'truncate table am_columnset_group_columns';
  EXECUTE immediate 'truncate table am_columnset_breakdown_columns';
  EXECUTE immediate 'truncate table am_unit_denominator_column';
  EXECUTE immediate 'truncate table am_columnset_configuration';
  EXECUTE immediate 'truncate table am_columnset_profiles';
  EXECUTE immediate 'truncate table am_columnset_widgets';
  EXECUTE immediate 'truncate table am_columnset_actions';
  EXECUTE immediate 'truncate table am_unit_configuration';
  EXECUTE immediate 'truncate table am_unit_profiles';
  EXECUTE immediate 'truncate table am_grouping_configuration';
  EXECUTE immediate 'truncate table am_grouping_profiles';
  EXECUTE immediate 'truncate table am_filtering_configuration';
  EXECUTE immediate 'truncate table am_filtering_profiles';
  EXECUTE immediate 'truncate table am_coloring_configuration';
  EXECUTE immediate 'truncate table am_coloring_profiles';
  EXECUTE immediate 'truncate table am_coloring_rule_configuration';

EXCEPTION
WHEN OTHERS THEN
  NULL;
END rename_pws_items_columns;
/

begin 
	rename_pws_items_columns;
end;
/

DROP PROCEDURE rename_pws_items_columns
;