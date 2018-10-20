DECLARE
   --variáveis e tipos
   inicio NUMBER;--irá guardar o tempo de início da execução de cada instrução
   iteracoes INTEGER := 500000; --número de linhas, iterações do for  
   --tipos, tabelas indexadas por inteiros
   TYPE numeros IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   TYPE textos IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   TYPE tabela IS TABLE OF bulk_teste%ROWTYPE;
   --variáveis
   lv_numeros NUMEROS;
   lv_textos TEXTOS;
   lv_tabela TABELA;
   lv_linha bulk_teste%ROWTYPE;
  
   --cursor
   CURSOR c IS
     SELECT *
     FROM bulk_teste;
        
   --     
   FUNCTION calcula(inicio NUMBER) RETURN NUMBER IS
   BEGIN
     RETURN ((dbms_utility.get_time-inicio)/100);
   END calcula;        
   
   --
   PROCEDURE p_inicio(inicio IN OUT NUMBER) IS
   BEGIN
     inicio := dbms_utility.get_time;
   END p_inicio;
BEGIN
   -- popular as variáveis
   FOR i IN 1..iteracoes LOOP
     lv_numeros(i) := dbms_random.value;
     lv_textos(i) := dbms_random.string('p', 50);
   END LOOP;
   
   --INSERT com um FOR simples
   p_inicio(inicio);
   FOR i IN 1..iteracoes LOOP
     INSERT INTO bulk_teste VALUES(lv_numeros(i), lv_textos(i));
   END LOOP;
   dbms_output.put_line('Tempo para inserir com um FOR simples: '||calcula(inicio));
   
   --INSERT COM FORALL COM LIMIT
   OPEN c;
   p_inicio(inicio);
   LOOP
     FETCH c BULK COLLECT INTO
     lv_tabela LIMIT 1000;
     EXIT WHEN lv_tabela.COUNT = 0;
     FORALL i IN 1..lv_tabela.COUNT
      INSERT INTO bulk_teste VALUES(lv_tabela(i).numero, lv_tabela(i).texto);
   END LOOP;
   dbms_output.put_line('Tempo para inserir com um FORALL com LIMIT de 1000: '||calcula(inicio));
   CLOSE c;
   
   --INSERT COM FORALL
   p_inicio(inicio);
   FORALL i IN 1..iteracoes
     INSERT INTO bulk_teste VALUES(lv_numeros(i), lv_textos(i));
   dbms_output.put_line('Tempo para inserir com um FORALL: '||calcula(inicio));
   
   --FETCH SEM BULK COLLECT
   p_inicio(inicio);
   OPEN c;
   LOOP
     FETCH c INTO
     lv_linha;
     EXIT WHEN c%NOTFOUND;
   END LOOP;
   CLOSE c;
   dbms_output.put_line('Tempo para um SELECT simples sem BULK: '||calcula(inicio));
  
   --FETCH COM BULK COLLECT
   p_inicio(inicio);
   OPEN c;  
   FETCH c BULK COLLECT INTO
     lv_tabela;
   CLOSE c;
   dbms_output.put_line('Tempo para um BULK COLLECT: '||calcula(inicio));
  
   --FETCH COM BULK COLLECT E LIMIT DE 500
   p_inicio(inicio);
   OPEN c;  
   LOOP
     FETCH c BULK COLLECT INTO
     lv_tabela LIMIT 500;
     EXIT WHEN lv_tabela.COUNT = 0;
   END LOOP;
   CLOSE c;
   dbms_output.put_line('Tempo para um BULK COLLECT com LIMIT de 500: '||calcula(inicio));
  
   --FETCH COM BULK COLLECT E LIMIT DE 2000
   p_inicio(inicio);
   OPEN c;
   LOOP
     FETCH c BULK COLLECT INTO
     lv_tabela LIMIT 2000;
     EXIT WHEN lv_tabela.COUNT = 0;
   END LOOP;
   CLOSE c;
   dbms_output.put_line('Tempo para um BULK COLLECT com LIMIT de 2000: '||calcula(inicio));  
END;