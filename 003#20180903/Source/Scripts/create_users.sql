--
--Create Users and Grants
--
CREATE USER sis_restrito 
    IDENTIFIED BY sis_restrito 
    DEFAULT TABLESPACE users 
    TEMPORARY TABLESPACE temp;
    
GRANT CREATE SESSION TO sis_restrito;

