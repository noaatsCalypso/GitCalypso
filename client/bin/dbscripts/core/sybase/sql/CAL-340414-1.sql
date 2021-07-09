-- BLOOMBERG_DUMMY_BONDCUSIP
DECLARE 
@bondValue varchar(16)
begin
select top 1 @bondValue  = value from domain_values where domain_values.name='BLOOMBERG_DUMMY_BONDCUSIP'
end
update triparty_allocation_parameter set bond_cusip = @bondValue
go

-- BLOOMBERG_DUMMY_EQUITYCUSIP
DECLARE 
@equityValue varchar(16)
begin
select top 1 @equityValue  = value from domain_values where domain_values.name='BLOOMBERG_DUMMY_EQUITYCUSIP'
end
update triparty_allocation_parameter set equity_cusip = @equityValue
go

-- BLOOMBERG_DUMMY_CASH_COLLATERAL_CUSIP
DECLARE 
@cashValue varchar(16)
begin
select top 1 @cashValue  = value from domain_values where domain_values.name='BLOOMBERG_DUMMY_CASH_COLLATERAL_CUSIP'
end
update triparty_allocation_parameter set cash_cusip = @cashValue
go

-- MC_TRIPARTY_ALLOCATION
DECLARE 
@isMarginCallAllocation varchar(16)
BEGIN
begin
select top 1 @isMarginCallAllocation = value from domain_values where domain_values.name='MC_TRIPARTY_ALLOCATION'
end
if @isMarginCallAllocation = 'true'
execute ('update triparty_allocation_parameter set trade_type = ''MC Trade''')
if @isMarginCallAllocation = 'false'
execute ('update triparty_allocation_parameter set trade_type = ''Pledge Trade''')
END
go

-- DV_TRIPARTY_REFERENCE_IDENTIFIER_KEYWORD
update triparty_allocation_parameter set alternate_identifier = 'AccountId-TCTR' where UPPER(exposure_type) = 'MARGIN CALL ENTRY' and (UPPER(agent_name) = 'JPMORGAN' or UPPER(exposure_type) = 'JP MORGAN')
go
update triparty_allocation_parameter set alternate_identifier = 'AccountId-CLTR' where UPPER(agent_name) = 'BPSS'
go
update triparty_allocation_parameter set alternate_identifier = 'TriPartyExternalRef' where UPPER(exposure_type) = 'REPO'
go

-- DV_TRIPARTY_UNDER_COLLATERALISATION TripartyUnderCollateralization
DECLARE 
@underThreshold varchar(16)
begin
select top 1 @underThreshold  = value from domain_values where domain_values.name='TripartyUnderCollateralization'
end
update triparty_allocation_parameter set under_threshold = cast( @underThreshold as float )
go


-- DV_TRIPARTY_OVER_COLLATERALISATION TripartyOverCollateralization
DECLARE 
@overThreshold varchar(16)
begin
select top 1 @overThreshold  = value from domain_values where domain_values.name='TripartyOverCollateralization'
end
update triparty_allocation_parameter set over_threshold = cast( @overThreshold as float )
go

