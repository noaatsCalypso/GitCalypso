
begin
   execute immediate 'drop procedure sp_ers_limit_housekeeping';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop package string_fnc';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop procedure SP_ERS_LIMITS_ROLL_RISKMETRICS';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop function sp_ers_rm_drilldown';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

begin
   execute immediate 'drop package types';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/

-- DEPRECATED MARKET RISK PROCEDURES REMOVAL IF EXISTS: (here because CAL-328582)
-- sp_ers_arc_result is not deprecated 
-- sp_ers_housekeeping is not deprecated 
-- sp_ers_save_pc_map  deprecated but exist on code even if not used need first full removal
begin
   execute immediate 'drop procedure sp_ers_save_scenario';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
-- sp_ers_update_trade deprecated but exist on code even if not used need first full removal
-- sp_ers_makeofficial_trade deprecated but exist on code even if not used need first full removal
begin
   execute immediate 'drop procedure sp_save_scenario_params';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure SP_DELETE_SCENARIO_SET';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_save_mc_scenario_params';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_ers_update_hierarchy_attr';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/
begin
   execute immediate 'drop procedure sp_ers_update_batch';
exception when others then
   if sqlcode != -4043 then
      raise;
   end if;
end;
/