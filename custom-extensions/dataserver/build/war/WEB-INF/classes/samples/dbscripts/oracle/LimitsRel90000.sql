alter table ers_exposure add issuer_notional float default 0 not null
;

alter table ers_exposure add issuer_notional_base float default 0 not null
;

DROP TABLE ers_limit_adjustment
;

CREATE TABLE ers_limit_adjustment
   (
	adjustment_id		int    		NOT NULL,
	limit_id		int    		NOT NULL,
	group_id		int		NOT NULL,
	adjust_type		char(10)	NOT NULL,
	related_limit_id	int		NOT NULL,
	effective_date		TIMESTAMP	NOT NULL,
	expires_date		TIMESTAMP	NOT NULL,
	effective_julian	int		NOT NULL,
	expires_julian		int		NOT NULL,
	amount			float		NOT NULL,
	user_name		varchar(32)	NOT NULL,
     	CONSTRAINT UNIQ_ers_limit_adjustment PRIMARY KEY (adjustment_id) USING INDEX TABLESPACE CALYPSOIDX
   ) TABLESPACE CALYPSOACTIVE
;

CREATE INDEX IDX_ers_limit_adjustment ON ers_limit_adjustment(effective_julian, expires_julian) TABLESPACE CALYPSOIDX
;

CREATE TABLE ers_limit_adjustment_reject
   (
	adjustment_id		int    		NOT NULL,
	reason			varchar(32)	NOT NULL,
	limit_id		int    		NOT NULL,
	group_id		int		NOT NULL,
	adjust_type		char(10)	NOT NULL,
	related_limit_id	int		NOT NULL,
	effective_date		TIMESTAMP	NOT NULL,
	expires_date		TIMESTAMP	NOT NULL,
	effective_julian	int		NOT NULL,
	expires_julian		int		NOT NULL,
	amount			float		NOT NULL,
	user_name		varchar(32)	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;


CREATE TABLE ers_limit_adjustment_authorise
   (
	adjustment_id		int    		NOT NULL,
	reason			varchar(32)	NOT NULL,
	limit_id		int    		NOT NULL,
	group_id		int		NOT NULL,
	adjust_type		char(10)	NOT NULL,
	related_limit_id	int		NOT NULL,
	effective_date		TIMESTAMP	NOT NULL,
	expires_date		TIMESTAMP	NOT NULL,
	effective_julian	int		NOT NULL,
	expires_julian		int		NOT NULL,
	amount			float		NOT NULL,
	user_name		varchar(32)	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;

CREATE TABLE ers_limit_adjustment_pending
   (
	adjustment_id		int    		NOT NULL,
	reason			varchar(32)	NOT NULL,
	limit_id		int    		NOT NULL,
	group_id		int		NOT NULL,
	adjust_type		char(10)	NOT NULL,
	related_limit_id	int		NOT NULL,
	effective_date		TIMESTAMP	NOT NULL,
	expires_date		TIMESTAMP	NOT NULL,
	effective_julian	int		NOT NULL,
	expires_julian		int		NOT NULL,
	amount			float		NOT NULL,
	user_name		varchar(32)	NOT NULL
   )  TABLESPACE CALYPSOACTIVE
;

