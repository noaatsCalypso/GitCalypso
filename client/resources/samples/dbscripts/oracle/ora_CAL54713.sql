/* CAL-54713 : insert Trade panel in TransferViewerWindow so that the netted trade of a SimpleNetting transfer can be displayed */
insert into report_panel_def values (-1,-1,'Trade','Trade',null,null)
;
update report_panel_def set
panel_index=(select max(panel_index)+1 from report_panel_def where win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow')),
win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow')
where exists (select 1 from report_panel_def where panel_name != 'Trade' and win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow'))
and not exists (select 1 from report_panel_def where panel_name = 'Trade' and win_def_id=(select win_def_id from report_win_def where def_name='TransferViewerWindow'))
and win_def_id=-1
;
delete report_panel_def where win_def_id=-1
;
/* End CAL-54713 */
