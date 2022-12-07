SET ECHO OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT OFF;
SET VERIFY OFF;
SET PAGES 0;
SET HEAD OFF;

-- redirection de la sortie standard

SPOOL H:\Documents\git\3IF-BDR\scriptGenereAuto.sql;

SELECT 'revoke select, insert, update, delete on ' || TABLE_NAME || ' from acognot;' 
FROM user_tables;

SPOOL OFF;
-- arrêt de la redirection

@H:\Documents\git\3IF-BDR\scriptGenereAuto.sql;