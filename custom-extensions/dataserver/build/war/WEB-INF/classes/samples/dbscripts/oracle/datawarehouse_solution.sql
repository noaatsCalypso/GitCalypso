CREATE TABLE calypso_info (
        major_version INTEGER,
        minor_version INTEGER,
        sub_version INTEGER,
        version_date DATE,
        ref_time_zone VARCHAR(128),
        patch_version VARCHAR(32) NULL,
        patch_date  DATE NULL,
        released_b CHAR(1) Default '1',
 CONSTRAINT pk_calypso_info PRIMARY KEY 	(major_version,minor_version,sub_version) USING INDEX TABLESPACE CALYPSOIDX
) TABLESPACE CALYPSOSTATIC
;

