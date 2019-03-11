-- Criar tabela para dados das pessoas
CREATE TABLE person (   
  person_ID  NUMBER,   
  name      VARCHAR2(30),   
  birthdate DATE,   
  gender    VARCHAR2(1)   
);
-- Criar tabela para endereços das pessoas
CREATE TABLE addresses (   
  person_id NUMBER,   
  address_code VARCHAR2(1),   
  address      VARCHAR2(30),   
  city         VARCHAR2(30),   
  state        VARCHAR2(3),   
  zip          VARCHAR2(10)   
);
-- Inserir dados e pessoas e respectivos endereços 
INSERT INTO person VALUES (1, 'VINICIUS', TO_DATE('29/03/2003','DD/MM/RRRR'), 'M');
INSERT INTO person VALUES (2, 'GUSTAVO', TO_DATE('20/06/2011','DD/MM/RRRR'), 'M');
INSERT INTO addresses VALUES (1, 'A', 'RUA A', 'CAMPINAS', 'SP', '123-456');
INSERT INTO addresses VALUES (1, 'A', 'RUA B', 'VALINHOS', 'SP', '321-456');
INSERT INTO addresses VALUES (2, 'B', 'RUA C', 'INDAIATUBA', 'SP', '987-654');
--
commit;
-- Criar type baseado na tabela pessoas
CREATE TYPE address_type AS OBJECT (   
   address_code VARCHAR2(1),   
   address      VARCHAR2(30),   
   city         VARCHAR2(30),   
   state        VARCHAR2(3),   
   zip          VARCHAR2(10)); 
-- Criar type para coleção de endereços
CREATE TYPE addresses_type AS TABLE OF address_type;
-- Criar type baseado na tabela endereços
CREATE TYPE person_type AS OBJECT (   
  personID  NUMBER,   
  name      VARCHAR2(30),   
  birthdate DATE,   
  gender    VARCHAR2(1),   
  addrs     addresses_type); 
-- Criar type para coleção de pessoas com os endereços como 'nested table' 
CREATE TYPE people_type as TABLE OF person_type;
--
DECLARE   
  the_people people_type;   
BEGIN 
 -- buscar dados em um único comando , armazenando na variável 'the_people', com os dados dos endereços em uma 'nested table' que
 -- faz parte da coleção.
  SELECT   
    person_type(   
        person_id,   
        name,   
        birthdate,   
        gender,   
        (SELECT CAST(MULTISET (   
                      SELECT   
                          address_code,   
                          address,   
                          city,   
                          state,   
                          zip   
                        FROM addresses   
                      WHERE person_id = p.person_id) AS addresses_type   
                    )   
          FROM dual   
        )   
    )   
  BULK COLLECT INTO the_people   
  FROM   
    person p   
  ;   
     
  FOR I IN 1..the_people.count loop   
  -- Exibir no output os dados armazenados na coleção.
  dbms_output.put_line('NOME: '||the_people(i).name    
                     ||' IDADE: '||trunc((months_between(sysdate, the_people(i).birthdate))/12)   
                     ||' ENDERECO: '||the_people(i).addrs(1).address   
                     ||' CIDADE: '||the_people(i).addrs(1).city   
                     ||' ESTADO: '||the_people(i).addrs(1).state   
                     ||' CEP: '||the_people(i).addrs(1).zip);    
  end loop;   
END; 