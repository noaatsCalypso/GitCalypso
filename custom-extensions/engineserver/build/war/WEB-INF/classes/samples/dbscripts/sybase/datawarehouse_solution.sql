
CREATE TABLE calypso_info (
        major_version   int NOT NULL,
        minor_version   int NOT NULL,
        sub_version     int NOT NULL,
        version_date   datetime  NULL,
        ref_time_zone  varchar(128) NULL,
        patch_version  varchar(32) NULL,
        patch_date     datetime  NULL,
        released_b     bit Default 1,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (major_version,minor_version,sub_version))
go

