DECLARE
  vope1 NUMBER(5, 2);
  vope2 NUMBER(5, 2);

  error_random PLS_INTEGER;
  e_random EXCEPTION;

  light_error_random PLS_INTEGER;
  fatal_error_random PLS_INTEGER;

  vresult NUMBER(10, 2);

  FUNCTION dividir
  (
    vope1 NUMBER,
    vope2 NUMBER
  ) RETURN NUMBER IS
    vresult NUMBER(10, 2);
  BEGIN
    vresult := vope1 / vope2;
    RETURN vresult;
  END dividir;

BEGIN

  error_random := dbms_random.value(1, 3);

  FOR i IN 1 .. 1000
  LOOP
    light_error_random := dbms_random.value(i, 1000);
    fatal_error_random := dbms_random.value(i, 1000);
  
    vope1 := dbms_random.value(100, 1000);
    vope2 := dbms_random.value(1, 2);
  
    BEGIN
    
      --Em uma determinda iteracao que coincidir com a variavel aleatoria light_error_random, atribuir 0 (zero) ao divisor
      IF light_error_random = i THEN
        vope2 := 0;
      END IF;
    
      --Em uma determinada iteracao que coincidir com a variavel aleatoria fatal_error_random, tentar atribuir um numero maior do que a variavel permite
      IF fatal_error_random = i THEN
        --vope2 := 10000000;
        IF error_random = 1 THEN
          RAISE too_many_rows;
        ELSIF error_random = 2 THEN
          RAISE no_data_found;
        ELSIF error_random = 3 THEN
          RAISE dup_val_on_index;
        END IF;
      END IF;
    
      vresult := dividir(vope1, vope2);
      dbms_output.put_line(i || ': ' || to_char(vresult));
    
    EXCEPTION
    
      WHEN zero_divide THEN
      
        dbms_output.put_line('---------------G R A V A R   L O G ! ! ! -----------------');
        dbms_output.put_line('Ocorreu a divisao por 0 na ' || i || 'ª iteracao');
        dbms_output.put_line(dbms_utility.format_error_stack ||
                             dbms_utility.format_error_backtrace);
        dbms_output.put_line('----------------------------------------------------------');
      
      WHEN OTHERS THEN
      
        dbms_output.put_line('---------------G R A V A R   L O G ! ! ! -----------------');
        dbms_output.put_line('ALGUM ERRO FATAL OCORREU. ABORTAR PROCESSO!');
        dbms_output.put_line('----------------------------------------------------------');
        raise_application_error(-20001,
                                'Erro fatal. Abortar processo' || chr(13) ||
                                dbms_utility.format_error_stack ||
                                dbms_utility.format_error_backtrace,
                                TRUE);
        --RAISE;
    
    END;
  
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    --raise_application_error(-20001, 'Erro da aplicacao: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, true);
    dbms_output.put_line('Erro da aplicacao: ' || SQLERRM);
END;
