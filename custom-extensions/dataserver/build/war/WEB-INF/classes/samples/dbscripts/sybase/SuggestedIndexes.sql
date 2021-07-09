/* for client who use external reference in thier report or query */
CREATE NONCLUSTERED INDEX idx_trd_external_reference on  trade
	(external_reference)
go


/* Feedback: Improved BOPosition drilldown  */
CREATE NONCLUSTERED INDEX idx_tran_val on bo_transfer (value_date)
go

/* Feedback: Significantly improved message report */
CREATE NONCLUSTERED INDEX idx_bo_msg_createdate on  bo_message
	(creation_date)
go


/* if client is querying to get the trade by sent status then this can be useful indexes */
CREATE INDEX idx_bo_posting_sent_status on bo_posting
        (sent_status)
go
