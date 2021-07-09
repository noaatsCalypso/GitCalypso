declare
  cnt number;
begin
  select count(*) into cnt from triparty_allocation_parameter;
  if cnt != 0 then
    -- BLOOMBERG_DUMMY_BONDCUSIP
	execute IMMEDIATE 'update triparty_allocation_parameter set bond_cusip = (select VALUE from domain_values where domain_values.NAME=''BLOOMBERG_DUMMY_BONDCUSIP'' and rownum = 1);';
	-- BLOOMBERG_DUMMY_EQUITYCUSIP
	execute IMMEDIATE 'update triparty_allocation_parameter set equity_cusip = (select VALUE from domain_values where domain_values.NAME=''BLOOMBERG_DUMMY_EQUITYCUSIP'' and rownum = 1);';
	-- BLOOMBERG_DUMMY_CASH_COLLATERAL_CUSIP
	execute IMMEDIATE 'update triparty_allocation_parameter set cash_cusip = (select VALUE from domain_values where domain_values.NAME=''BLOOMBERG_DUMMY_CASH_COLLATERAL_CUSIP'' and rownum = 1)';
  end if;
end;
/
-- MC_TRIPARTY_ALLOCATION
declare
  cnt number;
begin
  select count(*) into cnt from triparty_allocation_parameter;
  if cnt != 0 then
	declare
	isMarginCallAllocation varchar2(16):='';
	BEGIN
		select domain_values.VALUE into isMarginCallAllocation from domain_values where domain_values.NAME='MC_TRIPARTY_ALLOCATION';	
		if isMarginCallAllocation = 'true' THEN
			execute immediate 'update triparty_allocation_parameter set trade_type = ''MC Trade''';
		end if;
		if isMarginCallAllocation = 'false'  then 
			execute immediate 'update triparty_allocation_parameter set trade_type = ''Pledge Trade''';
		end if;
	END update_mc_triparty_allocation;
 end if;
end;
/
declare
  cnt number;
begin
  select count(*) into cnt from triparty_allocation_parameter;
  if cnt != 0 then
	-- DV_TRIPARTY_REFERENCE_IDENTIFIER_KEYWORD
    execute IMMEDIATE 'update triparty_allocation_parameter set alternate_identifier = ''AccountId-TCTR'' where UPPER(exposure_type) = ''MARGIN CALL ENTRY'' and (UPPER(agent_name) = ''JPMORGAN'' or UPPER(exposure_type) = ''JP MORGAN'');';
	execute IMMEDIATE 'update triparty_allocation_parameter set alternate_identifier = ''AccountId-CLTR'' where UPPER(agent_name) = ''BPSS''';
	execute IMMEDIATE 'update triparty_allocation_parameter set alternate_identifier = ''TriPartyExternalRef'' where UPPER(exposure_type) = ''REPO''';
	-- DV_TRIPARTY_UNDER_COLLATERALISATION TripartyUnderCollateralization
	execute IMMEDIATE 'update triparty_allocation_parameter set under_threshold = (select VALUE from domain_values where domain_values.NAME=''TripartyUnderCollateralization'' and rownum = 1);';
	-- DV_TRIPARTY_OVER_COLLATERALISATION TripartyOverCollateralization
	execute IMMEDIATE 'update triparty_allocation_parameter set over_threshold = (select VALUE from domain_values where domain_values.NAME=''TripartyOverCollateralization'' and rownum = 1);';
  end if;
end;
/