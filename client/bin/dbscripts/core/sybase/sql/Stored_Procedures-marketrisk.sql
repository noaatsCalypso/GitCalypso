/****** Object:  Stored Procedure dbo.sp_ers_arc_result    Script Date: 01/11/2005 12:00:00 ******/
if exists (select * from sysobjects where id = object_id('sp_ers_arc_result')  )
	drop procedure sp_ers_arc_result
GO







-- DEPRECATED MARKET RISK PROCEDURES REMOVAL IF EXISTS:
-- sp_ers_arc_result is not deprecated 
-- sp_ers_housekeeping is not deprecated 
-- sp_ers_save_pc_map  deprecated but exist on code even if not used need first full removal
IF OBJECT_ID('sp_ers_save_scenario') IS NOT NULL
    DROP PROCEDURE sp_ers_save_scenario
GO

-- sp_ers_update_trade deprecated but exist on code even if not used need first full removal
-- sp_ers_makeofficial_trade deprecated but exist on code even if not used need first full removal
IF OBJECT_ID('sp_save_scenario_params') IS NOT NULL
    DROP PROCEDURE sp_save_scenario_params
GO

IF OBJECT_ID('SP_DELETE_SCENARIO_SET') IS NOT NULL
    DROP PROCEDURE SP_DELETE_SCENARIO_SET
GO

IF OBJECT_ID('sp_save_mc_scenario_params') IS NOT NULL
    DROP PROCEDURE sp_save_mc_scenario_params
GO

IF OBJECT_ID('sp_ers_update_hierarchy_attr') IS NOT NULL
    DROP PROCEDURE sp_ers_update_hierarchy_attr
GO

IF OBJECT_ID('sp_ers_update_batch') IS NOT NULL
    DROP PROCEDURE sp_ers_update_batch
GO

IF OBJECT_ID('tr_ins_ers_result') IS NOT NULL
    drop trigger tr_ins_ers_result
GO
