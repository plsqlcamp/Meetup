-- Create table
create table regra_sequencia_rotinas
(
  regra_sequencia_rotinas_id number(10),
  regras_id                  number(10),
  retorno_funcao             varchar2(3),
  rotina_id                  number(10),
  proxima_rotina_id          number(10)
);
