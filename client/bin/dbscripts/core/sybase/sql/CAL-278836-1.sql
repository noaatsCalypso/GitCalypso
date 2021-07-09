/* Upgrade Version */

/* Fix Risk Attribution Classname issue in HistSim */
update ers_risk_attribution set node_class=str_replace(node_class,'tk.risk.sim.',null) where node_class like '%tk.risk.sim.%'
go
