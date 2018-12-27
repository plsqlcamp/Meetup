-- Exemplo 1

declare
  oObject json_object_t := New json_object_t;
  oObjectPai json_object_t := New json_object_t;
begin 
  
  
  oObject.put('Nome', 'Caio');
  oObject.put('SobreNome', 'Caio');
  oObjectPai.put('Dados',oObject);
  dbms_output.put_line (oObjectPai.to_clob);

end;


-- Exemplo 2
declare
  oObject json_object_t := new json_object_t;
  aArray json_array_t := New json_array_t;
begin
  
  oObject.put('Exemplo Array1', 'Input 1');
  oObject.put('Exemplo Array2', 'Input 2');
   aArray.append( oObject);
  
  dbms_output.put_line(aArray.to_clob);
  
end;  


declare

  oReturn json_object_t;
  aArrayJson json_array_t;
  oReturnjson json_object_t;
begin
  
 oReturn := new json_object_t();
 oReturnjson := new json_object_t();
 aArrayJson := new json_array_t();
 
 for ix in (select * from tb_pessoa where lower(no_pessoa) = 'teste')  loop
   oReturn.put('Nome', ix.no_pessoa);
   oReturn.put('TpPessoa', ix.tp_pessoa);
   
   
   aArrayJson.append(oReturn);
 end loop;
  
 dbms_output.put_line(aArrayJson.to_clob);
 
end;  

-----------------


CREATE TABLE tabela_json_mha (
  codigo NUMBER NOT NULL,
  dados  VARCHAR2(4000),
  CONSTRAINT tabela_json_pk PRIMARY KEY (codigo),
  CONSTRAINT tabela_json_chk1 CHECK (dados IS JSON)
);    


SELECT table_name,
            column_name,
            format,
            data_type
     FROM  user_json_columns;
     
INSERT INTO tabela_json_mha (codigo, dados)
VALUES (1,
        '{
    "Nome": "Caio",
    "SobreNome": "Izidio",
    "Certificacoes": [ "XX", "SSS" ]
    }
');   

commit;


INSERT INTO tabela_json_mha (codigo, dados)
VALUES (2,'Teste MeetUp');

select * from tabela_json_mha;