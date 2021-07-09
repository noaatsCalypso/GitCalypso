create or replace view tr_supervisor_view as 
    select S.supervisor_id, S.supervisor_code, R.regulation_code, R.regulation_name, R.dtcc_repository datacenter, S.enabled
    from tr_regulation R, tr_supervisor S
    where R.regulation_id = S.regulation_id
    order by S.supervisor_id
GO


create or replace view tr_uti_view as
    select U.trade_id, R.regulation_code, R.regulation_name, U.type, LS.source_code,
           U.issuer_reference prefix, U.trade_reference value
    from tr_usi_uti U, tr_regulation R, tr_le_id_source LS
    where R.regulation_id = U.regulation_id
          and U.issuer_source_id = LS.source_id
    order by U.trade_id,  U.type, R.regulation_id
GO

create or replace view tr_report_regime_view as
    select RR.trade_id,
           S.supervisor_code supervisor,
           PR.role_name po_role,
           CASE RR.clearing_mandatory_b
                WHEN 0 then 'false'
                WHEN 1 then 'true'
                ELSE null
           END clearing_mandatory,
           CASE RR.counterparty_masked_b
                WHEN 0 then 'false'
                WHEN 1 then 'true'
                ELSE null
           END counterparty_masked,
           CASE RR.po_local_b
                WHEN 0 then 'false'
                WHEN 1 then 'true'
                ELSE null
           END po_local,
           CASE RR.cpty_local_b
                WHEN 0 then 'false'
                WHEN 1 then 'true'
                ELSE null
           END cpty_local
    from tr_report_regime RR, tr_supervisor S, tr_po_role PR
    where RR.supervisor_id = S.supervisor_id and RR.po_role_code = PR.role_code
    order by RR.trade_id, S.supervisor_id
GO

create or replace view tr_po_role_view as
select TR.trade_id, 
       DFA.po_role dfa_po_role, 
       ESMA.po_role esma_po_role, 
       CA_QC.po_role ca_qc_po_role, 
       CA_ON.po_role ca_on_po_role, 
       CA_MB.po_role ca_mb_po_role, 
       MAS.po_role mas_po_role,
       HKMA.po_role hkma_po_role
from tr_report TR
left outer join
     tr_report_regime_view DFA
     on TR.trade_id = DFA.trade_id and DFA.supervisor in ('CFTC', 'SEC')
left outer join
     tr_report_regime_view ESMA
     on TR.trade_id = ESMA.trade_id and ESMA.supervisor = 'ESMA'
left outer join
     tr_report_regime_view CA_QC
     on TR.trade_id = CA_QC.trade_id and CA_QC.supervisor = 'CA_QC_AMF'
left outer join
     tr_report_regime_view CA_ON
     on TR.trade_id = CA_ON.trade_id and CA_ON.supervisor = 'CA_ON_OSC'
left outer join
     tr_report_regime_view CA_MB
     on TR.trade_id = CA_MB.trade_id and CA_MB.supervisor = 'CA_MB_MSC'
left outer join
     tr_report_regime_view MAS
     on TR.trade_id = MAS.trade_id and MAS.supervisor = 'MAS'
left outer join
     tr_report_regime_view HKMA
     on TR.trade_id = HKMA.trade_id and HKMA.supervisor = 'HKMA'
order by TR.trade_id
GO

create or replace view tr_submission_state_view as 
select S.trade_id, J.supervisor_code, S.purpose_code, 
       to_char(S.submission_time, 'YYYY-MM-DD HH24:MI:SS.FF3') submission_time,
       to_char(S.response_time, 'YYYY-MM-DD HH24:MI:SS.FF3') response_time,
       S.validation_code
from tr_submission_state S, tr_supervisor J
where S.supervisor_id = J.supervisor_id
order by S.trade_id, J.supervisor_code, S.submission_time
GO
