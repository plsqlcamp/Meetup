DECLARE
  e_oper_invalida EXCEPTION;
  --PRAGMA EXCEPTION_INIT(e_oper_invalida, -29283);
  varq utl_file.file_type;

BEGIN
  varq := utl_file.fopen(location => 'c:\', filename => 'seila.txt', open_mode => 'W');
EXCEPTION
  WHEN e_oper_invalida THEN
    dbms_output.put_line('Operacao invalida');
  
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
