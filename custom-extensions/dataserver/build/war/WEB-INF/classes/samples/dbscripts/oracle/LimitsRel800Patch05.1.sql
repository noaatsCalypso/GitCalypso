alter table ers_limit add is_frozen int default 0 not null
;

alter table ers_limit_authorise add is_frozen int default 0 not null
;

alter table ers_limit_authorise_reject add is_frozen int default 0 not null
;

alter table ers_limit_pending add is_frozen int default 0 not null
;

alter table ers_limit add is_hardlimit int default 0 not null
;

alter table ers_limit_authorise add is_hardlimit int default 0 not null
;

alter table ers_limit_authorise_reject add is_hardlimit int default 0 not null
;

alter table ers_limit_pending add is_hardlimit int default 0 not null
;

CREATE TABLE ers_limit_adjustment
   (
	limit_id		int    		NOT NULL,
	group_id		int		NOT NULL,
	adjust_type		char(10)	NOT NULL,
	related_limit_id	int		NOT NULL,
	effective_date		TIMESTAMP	NOT NULL,
	expires_date		TIMESTAMP	NOT NULL,
	effective_julian	int		NOT NULL,
	expires_julian		int		NOT NULL,
	amount			float		NOT NULL,
     	CONSTRAINT UNIQ_ers_limit_adjustment PRIMARY KEY (limit_id) USING INDEX TABLESPACE CALYPSOIDX
   ) TABLESPACE CALYPSOACTIVE
;

CREATE INDEX IDX_ers_limit_adjustment ON ers_limit_adjustment(effective_julian, expires_julian) TABLESPACE CALYPSOIDX
;


alter table ers_exposure add notional_base float default 0 not null
;

