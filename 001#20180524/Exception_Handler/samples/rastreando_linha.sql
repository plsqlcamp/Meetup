CREATE OR REPLACE PROCEDURE my_putline (
    pmsg IN VARCHAR
) IS
    vmsg_padrao   VARCHAR2(7) := 'ABCDE';
BEGIN
    vmsg_padrao := vmsg_padrao || pmsg;
    dbms_output.put_line(vmsg_padrao);
END;
/

BEGIN
    my_putline('FGH');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(dbms_utility.format_error_stack || dbms_utility.format_error_backtrace);
END;
/