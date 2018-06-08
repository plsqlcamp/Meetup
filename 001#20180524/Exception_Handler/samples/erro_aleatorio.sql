DECLARE
  vope1 number(5,2);
  vope2 number(5,2);

  light_error_random pls_integer;
  fatal_error_random  pls_integer;
  
  vresult number(10,2);
  
  function dividir(vope1 number, vope2 number) return number is
    vresult number(10,2);
  begin
    vresult := vope1 / vope2;
    return vresult;
   end dividir;
   
   
begin

    light_error_random := DBMS_RANDOM.VALUE(1,5);
    fatal_error_random := DBMS_RANDOM.VALUE(1,10);
    
    for i in 1..5 loop
        vope1 := DBMS_RANDOM.VALUE(100,1000);
        vope2 := DBMS_RANDOM.VALUE(1,2);
    
       begin
       
          if light_error_random  = i then
              vope2 := 0;
          end if;
        
          if fatal_error_random  = i then
            vope2 := 10000000;
           end if;
        
        
           vresult := dividir(vope1,vope2);
           dbms_output.put_line(to_char(vresult));
        
        exception
        
        when zero_divide then
            dbms_output.put_line('---------------G R A V A R   L O G ! ! ! -----------------');
            dbms_output.put_line('Ocorreu a divisao por 0 na ' || i || ' iteracao');
            dbms_output.put_line('-----------------------------------------------------------');
        when others then
            dbms_output.put_line('---------------G R A V A R   L O G ! ! ! -----------------');
            dbms_output.put_line('ALGUM ERRO FATAL OCORREU. ABORTAR PROCESSO!');
            dbms_output.put_line('-----------------------------------------------------------');
            --raise_application_error(-20001, 'Erro fatal. Abortar processo');
            RAISE;
        end;

    end loop;
  
exception
when others then
  --raise_application_error(-20001, 'Erro da aplicacao: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, true);
  dbms_output.put_line('Erro da aplicacao: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
end;
