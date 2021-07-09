CREATE OR REPLACE FUNCTION RENAME_PWS_ITEMS_COLUMNS
()
RETURNS void LANGUAGE plpgsql
AS $BODY$
BEGIN
  EXECUTE 'CREATE TABLE am_grouping_columns_bk as (select * from am_grouping_columns)';
  EXECUTE 'CREATE TABLE am_filtering_columns_bk  as (select * from am_filtering_columns)';
  EXECUTE 'CREATE TABLE am_columnset_main_columns_bk as (select * from  am_columnset_main_columns)';
  EXECUTE 'CREATE TABLE am_columnset_pivot_columns_bk as (select * from   am_columnset_pivot_columns)';
  EXECUTE 'CREATE TABLE am_columnset_group_columns_bk as (select * from  am_columnset_group_columns)';
  EXECUTE 'CREATE TABLE am_columnset_break_columns_bk as (select * from  am_columnset_breakdown_columns)';
  EXECUTE 'CREATE TABLE am_coloring_colord_columns_bk as (select * from am_coloring_colored_columns)';
  EXECUTE 'CREATE TABLE am_unit_denominator_column_bk as (select * from  am_unit_denominator_column)';
  EXECUTE 'CREATE TABLE am_columnset_config_bk as (select * from am_columnset_configuration)';
  EXECUTE 'CREATE TABLE am_columnset_profiles_bk as (select * from am_columnset_profiles)';
  EXECUTE 'CREATE TABLE am_columnset_widgets_bk as (select * from am_columnset_widgets)';
  EXECUTE 'CREATE TABLE am_columnset_actions_bk as (select * from am_columnset_actions)';
  EXECUTE 'CREATE TABLE am_unit_configuration_bk as (select * from am_unit_configuration)';
  EXECUTE 'CREATE TABLE am_unit_profiles_bk as (select * from am_unit_profiles)';
  EXECUTE 'CREATE TABLE am_grouping_configuration_bk as (select * from am_grouping_configuration)';
  EXECUTE 'CREATE TABLE am_grouping_profiles_bk as (select * from am_grouping_profiles)';
  EXECUTE 'CREATE TABLE am_filtering_configuration_bk as (select * from am_filtering_configuration)';
  EXECUTE 'CREATE TABLE am_filtering_profiles_bk as (select * from am_filtering_profiles)';
  EXECUTE 'CREATE TABLE am_coloring_configuration_bk as (select * from am_coloring_configuration)';
  EXECUTE 'CREATE TABLE am_coloring_profiles_bk as (select * from am_coloring_profiles)';
  EXECUTE 'CREATE TABLE am_coloring_rule_config_bk as (select * from am_coloring_rule_configuration)';
  EXECUTE 'truncate table am_grouping_columns';
  EXECUTE 'truncate table am_filtering_columns';
  EXECUTE 'truncate table am_columnset_main_columns';
  EXECUTE 'truncate table am_columnset_pivot_columns';
  EXECUTE 'truncate table am_columnset_group_columns';
  EXECUTE 'truncate table am_columnset_breakdown_columns';
  EXECUTE 'truncate table am_unit_denominator_column';
  EXECUTE 'truncate table am_columnset_configuration';
  EXECUTE 'truncate table am_columnset_profiles';
  EXECUTE 'truncate table am_columnset_widgets';
  EXECUTE 'truncate table am_columnset_actions';
  EXECUTE 'truncate table am_unit_configuration';
  EXECUTE 'truncate table am_unit_profiles';
  EXECUTE 'truncate table am_grouping_configuration';
  EXECUTE 'truncate table am_grouping_profiles';
  EXECUTE 'truncate table am_filtering_configuration';
  EXECUTE 'truncate table am_filtering_profiles';
  EXECUTE 'truncate table am_coloring_configuration';
  EXECUTE 'truncate table am_coloring_profiles';
  EXECUTE 'truncate table am_coloring_rule_configuration';

EXCEPTION WHEN OTHERS THEN
  NULL;
END;

$BODY$
;

DO $$ begin
	perform RENAME_PWS_ITEMS_COLUMNS();
end$$;

DROP FUNCTION RENAME_PWS_ITEMS_COLUMNS()
;