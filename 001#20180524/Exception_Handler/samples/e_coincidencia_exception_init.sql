CREATE OR REPLACE PROCEDURE proc_coincidencia IS
  e_coincidencia EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_coincidencia, -20002);
  v_num1 PLS_INTEGER;
  v_num2 PLS_INTEGER;
BEGIN
  FOR i IN 1 .. 1000000
  LOOP
    v_num1 := dbms_random.value(1, 500);
    v_num2 := dbms_random.value(1, 500);
    IF v_num1 = v_num2 THEN
      raise_application_error(-20002, 'Excecao por coincidencia extrema - iteracao ' || i, TRUE);
    END IF;
  END LOOP;
EXCEPTION
  WHEN e_coincidencia THEN
    --dbms_output.put_line(SQLCODE || chr(10) || SQLERRM);
    RAISE;
END;
/

BEGIN
  proc_coincidencia;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(dbms_utility.format_error_stack || dbms_utility.format_error_backtrace);
END;
/
