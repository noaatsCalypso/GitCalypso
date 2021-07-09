
/* This Script is just for Creating Demo Databases,user tablespace.. */
/* The size of Tablespace are intentionally smaller for small demo database and size should not used for Live Database it vary depending on trade volume */

/* Create the Table Space */
CREATE TABLESPACE CALYPSO DATAFILE '/usr/local/oracle/database/calypso/CALYPSO_01.dbf' 
SIZE 1000M autoextend on next 100m maxsize unlimited
;
/* Create calypso & middletier  users  */
/* clients can change schema names, if desired */

create user calypso identified by calypso
default tablespace calypso temporary tablespace temp;
GRANT SELECT ANY TABLE to 	calypso  ;
GRANT UNLIMITED TABLESPACE to 	calypso  ;
GRANT UPDATE ANY TABLE to 	calypso     ;
GRANT RESOURCE to 	calypso     ;
GRANT CONNECT to 	calypso     ;
GRANT CREATE table to 	calypso     ;
GRANT CREATE SESSION to 	calypso     ;
GRANT CREATE ANY INDEX to 	calypso     ;
grant query rewrite to 	calypso     ;
grant execute any procedure to 	calypso     ;
 grant create view  to 	calypso     ;
grant create sequence to 	calypso     ;

