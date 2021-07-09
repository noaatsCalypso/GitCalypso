
CREATE TABLE analysis_message ( id numeric (10) NOT NULL,  task_id varchar2 (255) NOT NULL,  message_type numeric (10) NULL,  source_id numeric (10) NULL,  throwable blob  NULL ) 
;
CREATE TABLE analysis_datatable ( analysis varchar2 (255) NOT NULL,  data_table varchar2 (255) NULL ) 
;
CREATE TABLE store_schema ( store_id varchar2 (255) NOT NULL,  entityname varchar2 (255) NOT NULL,  analysis_schema blob  NULL ) 
;
CREATE TABLE column_projection ( id varchar2 (256) NOT NULL,  name varchar2 (256) NOT NULL,  projection blob  NULL ) 
;
CREATE TABLE middletier_seed ( last_id numeric  NOT NULL,  seed_name varchar2 (32) NOT NULL,  seed_alloc_size numeric  DEFAULT 1 NOT NULL ) 
;
INSERT INTO middletier_seed ( last_id, seed_name, seed_alloc_size ) VALUES (1000,'TableSeed',100 )
;
ALTER TABLE column_projection ADD CONSTRAINT pk_column_projection1 PRIMARY KEY ( id )
;
ALTER TABLE middletier_seed ADD CONSTRAINT pk_middletier_seed1 PRIMARY KEY ( seed_name )
;
CREATE INDEX idx_analysis_message1 ON analysis_message ( source_id, task_id ) compute statistics
;
