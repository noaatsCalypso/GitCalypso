update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='Counterparty-BranchLocation'
;
update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='Counterparty-DeskLocation'
;
update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='Counterparty-TraderLocation'
;
update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='ProcessingOrg-BranchLocation'
;
update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='ProcessingOrg-DeskLocation'
;
update tr_reporting_attr set attribute_domain='country.iso_code' where attribute_domain is null and attribute_name='ProcessingOrg-TraderLocation'
;
update tr_reporting_attr set attribute_domain='currency_default.currency_code' where attribute_domain is null and attribute_name='AdditionalPriceCurrency'
;
update tr_reporting_attr set attribute_domain='currency_default.currency_code' where attribute_domain is null and attribute_name='PriceCurrency'
;
update tr_reporting_attr set attribute_domain='legal_entity.short_name' where attribute_domain is null and attribute_name='MasUTIGeneratingParty'
;
update tr_reporting_attr set attribute_domain='legal_entity.short_name' where attribute_domain is null and attribute_name='ReportingParty-CFTC'
;
update tr_reporting_attr set attribute_domain='legal_entity.short_name' where attribute_domain is null and attribute_name='ReportingParty-SEC'
;
update tr_reporting_attr set attribute_domain='legal_entity.short_name' where attribute_domain is null and attribute_name='UTIGeneratingParty'
;
update tr_reporting_attr set attribute_domain='tr_report.additional_price_type' where attribute_domain is null and attribute_name='AdditionalPriceNotationType'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_beneficiary_id' where attribute_domain is null and attribute_name='Counterparty-Beneficiary'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_broker_id' where attribute_domain is null and attribute_name='Counterparty-Broker'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_clearing_broker_id' where attribute_domain is null and attribute_name='Counterparty-ClearingBroker'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_collateral_portfolio_code' where attribute_domain is null and attribute_name='Counterparty-CollateralPortfolioCode'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_desk' where attribute_domain is null and attribute_name='Counterparty-Desk'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_execution_agent_id' where attribute_domain is null and attribute_name='Counterparty-ExecutionAgent'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_settlement_agent_id' where attribute_domain is null and attribute_name='Counterparty-SettlementAgent'
;
update tr_reporting_attr set attribute_domain='tr_report.cpty_trader' where attribute_domain is null and attribute_name='Counterparty-Trader'
;
update tr_reporting_attr set attribute_domain='tr_report.payment_frequency_method' where attribute_domain is null and attribute_name='PaymentFrequencyPeriod1'
;
update tr_reporting_attr set attribute_domain='tr_report.po_beneficiary_id' where attribute_domain is null and attribute_name='ProcessingOrg-Beneficiary'
;
update tr_reporting_attr set attribute_domain='tr_report.po_collateral_portfolio_code' where attribute_domain is null and attribute_name='ProcessingOrg-CollateralPortfolioCode'
;
update tr_reporting_attr set attribute_domain='tr_report.po_execution_agent_id' where attribute_domain is null and attribute_name='ProcessingOrg-ExecutionAgent'
;
update tr_reporting_attr set attribute_domain='tr_report.po_settlement_agent_id' where attribute_domain is null and attribute_name='ProcessingOrg-SettlementAgent'
;
update tr_reporting_attr set attribute_domain='tr_report.price_type' where attribute_domain is null and attribute_name='PriceNotationPriceType1'
;
update tr_reporting_attr set attribute_domain='tr_report.upi' where attribute_domain is null and attribute_name='UPI'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='AllocationIndicator'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingDCO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ClearingMandatory-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='Compression'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='CompressionFAR'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='Counterparty-Collateralized'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='Counterparty-CommercialActivity'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='Counterparty-TradingCapacity'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ElectronicConfirmation'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ExecutionVenue'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsCounterpartyLocal-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='IsProcessingOrgLocal-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='LargeSizeTrade'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='MaskedCounterparty-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='NonStandardFlag'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='OffPlatformVerification'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='PreConfirmation-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='PreConfirmation-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='PriceForming'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='PrimaryAssetClass'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrg-Collateralized'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrg-CommercialActivity'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrg-TradingCapacity'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ProcessingOrgRole-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Confirmation-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-PET-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-RealTime-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-ASIC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.AB.ASC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.BC.BCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.MB.MSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.NB.FCSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.NL.DSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.NS.NSSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.NT.NTSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.NU.NSO'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.ON.OSC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.PEI.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.QC.AMF'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.SK.FCAA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CA.YT.OSS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-CFTC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-ESMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-HKMA'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-MAS'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='ReportingResult-Snapshot-SEC'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='SecondaryAssetClass'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='TerminatedByCompression'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='TerminatedByCompressionFAR'
;
update tr_reporting_attr set attribute_domain='tr_reporting_attr_restriction.value' where attribute_domain is null and attribute_name='UnderlyingCodeType'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='AsicUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='BlockCanadaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='BlockHkmaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='BlockMasUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='BlockUSI/USIIssuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='BlockUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='CanadaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='FeeCanadaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='FeeHkmaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='FeeMasUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='FeeUSI/USIIssuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='FeeUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='HkmaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='MasUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OldCanadaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OldHkmaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OldMasUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OldUSI/USIIssuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OldUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OriginatingCanadaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OriginatingHkmaUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OriginatingMasUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OriginatingUSI/USIIssuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='OriginatingUTI/Issuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='USI/USIIssuer'
;
update tr_reporting_attr set attribute_domain='tr_usi_uti.issuer_reference' where attribute_domain is null and attribute_name='UTI/Issuer'
;
/