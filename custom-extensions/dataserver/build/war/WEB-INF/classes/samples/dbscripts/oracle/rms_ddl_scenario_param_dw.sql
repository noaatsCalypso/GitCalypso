drop table rms_scen_risk_measures;
drop table rms_scen_pricer_measures;
drop table rms_scen_pre_process;
drop table rms_scen_pre_shift;
drop table rms_scen_pricing_params;
drop table rms_scen_config_columns;
drop table rms_scen_stress_params;
drop table rms_scen_param;

create table rms_scen_risk_measures
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 risk_measure varchar2(64) not null,
 primary key (param_set_name, time_id, risk_measure)
);
create table rms_scen_pricer_measures
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 pricer_measure varchar2(64) not null,
 primary key (param_set_name, time_id, pricer_measure)
);
create table rms_scen_pre_process
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 product_type varchar2(64) not null,
 pricer_measure varchar2(64) not null,
 primary key (param_set_name, time_id, product_type, pricer_measure)
);
create table rms_scen_pre_shift
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 pre_shift_rule varchar2(64) not null,
 by_rule varchar2(64) not null,
 mkt_data_set varchar2(64) not null,
 primary key (param_set_name, time_id, pre_shift_rule, by_rule, mkt_data_set)
);
create table rms_scen_pricing_params
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 pre_shift_rule varchar2(64) not null,
 pricing_rule varchar2(64) not null,
 params_name varchar2(64) not null,
 primary key (param_set_name, time_id, pre_shift_rule, pricing_rule, params_name)
);
create table rms_scen_config_columns
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 column_name varchar2(64) not null,
 primary key (param_set_name, time_id, column_name)
);
create table rms_scen_stress_params
(
 rms_scen_stress_params_id number not null,
 param_set_name varchar2(32) not null,
 time_id number not null,
 scenario_name varchar2(32) not null,
 parent_scenario_name varchar2(32),
 product_name varchar2(64),
 product_type varchar2(64),
 market_data_type varchar2(64),
 relative_contract varchar2(64),
 attribute_source varchar2(64),
 attribute_name varchar2(64),
 attribute_value varchar2(64),
 shift_multiplier_up varchar2(64),
 shift_multiplier_down varchar2(64),
 shift_up_diff_cap varchar2(64),
 shift_down_diff_cap varchar2(64),
 shift_method varchar2(64),
 cap_method varchar2(64),
 shift_input varchar2(64),
 primary key (rms_scen_stress_params_id)
);
create table rms_scen_param
(
 param_set_name varchar2(32) not null,
 time_id number not null,
 mkt_data_set varchar2(32),
 product_type varchar2(32),
 class_name varchar2(255) not null enable,
 comments      varchar2(255),
 version_num   number,
 is_parametric number,
 owner_name    varchar2(32),
 asof_forward_date varchar2(8),
 con_base_currency varchar2(1),
 gen_rolled_curves varchar2(1),
 include_probability varchar2(1),
 explode_trades varchar2(1),
 optimize_risk varchar2(1),
 look_through_fund varchar2(1),
 attach_pricing_curr varchar2(1),
 rollup_allocation varchar2(1),
 primary key (param_set_name, time_id)
);