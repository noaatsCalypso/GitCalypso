/* Ths script will create the Oracle user, middletier for use   */ 
/* with the Calypso middle-tier servers */


/*								*/
/* Execute the oraclemeta.sql script before using this script.  */
/*								*/



/* 								*/
/* Change the user password and TABLESPACE name as appropriate  */
/* for your Calypso implementation.                             */
/*								*/


CREATE USER middletier IDENTIFIED BY calypso DEFAULT TABLESPACE calypso TEMPORARY TABLESPACE temp;
GRANT SELECT ANY TABLE TO middletier;
GRANT UNLIMITED TABLESPACE TO middletier;
GRANT UPDATE ANY TABLE TO middletier;
GRANT RESOURCE TO middletier;
GRANT CONNECT TO middletier;
GRANT CREATE SESSION TO middletier;
GRANT QUERY REWRITE TO middletier;
GRANT EXECUTE ANY PROCEDURE TO middletier;
GRANT CREATE VIEW  TO middletier; 



