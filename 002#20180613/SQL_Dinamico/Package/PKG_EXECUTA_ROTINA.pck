create or replace package pkg_executa_rotina is
  --
  type typ_rec_dados_func is record(
    nome_funcionario     varchar2(200),
    cargo_funcionario    varchar2(100),
    gerente_funcionario  varchar2(200),
    nome_departamento    varchar2(100),
    gerente_departamento varchar2(200),
    cidade               varchar2(100),
    pais                 varchar2(100),
    regiao               varchar2(100));
  --
  type typ_tab_dados_func is table of typ_rec_dados_func index by binary_integer;
  p_dados_func typ_tab_dados_func;
  --
  function fnc_valida_regra(p_id_regra in number, p_id_func in number)
    return varchar2;
  --
end pkg_executa_rotina;
/
create or replace package body pkg_executa_rotina is
  --
  procedure prc_popula_dados(p_id_func in number) is
  begin
    -- dados funcionario
    select e.first_name || ' ' || e.last_name nome_funcionario,
           j.job_title cargo_funcionario,
           m.first_name || ' ' || m.last_name gerente_funcionario,
           d.department_name nome_departamento,
           g.first_name || ' ' || g.last_name gerente_departamento,
           l.city cidade,
           c.country_name pais,
           r.region_name regiao
      bulk collect
      into p_dados_func
      from employees   e,
           employees   m,
           jobs        j,
           departments d,
           employees   g,
           locations   l,
           countries   c,
           regions     r
     where e.manager_id = m.employee_id(+)
       and e.job_id = j.job_id
       and e.department_id = d.department_id
       and d.manager_id = g.employee_id
       and d.location_id = l.location_id
       and l.country_id = c.country_id
       and c.region_id = r.region_id
       and e.employee_id = p_id_func;
    --
  exception
    when others then
      raise_application_error(-20000,
                              'Erro rotina prc_popula_dados : ' || sqlerrm);
  end prc_popula_dados;
  --
  function fnc_monta_string_rotina(p_nome_rotina in varchar2) return varchar2 is
    v_tb_overload                sys.dbms_describe.number_table;
    v_tb_position                sys.dbms_describe.number_table;
    v_tb_level                   sys.dbms_describe.number_table;
    v_tb_argument_name           sys.dbms_describe.varchar2_table;
    v_tb_datatype                sys.dbms_describe.number_table;
    v_tb_default_value           sys.dbms_describe.number_table;
    v_tb_in_out                  sys.dbms_describe.number_table;
    v_tb_length                  sys.dbms_describe.number_table;
    v_tb_precision               sys.dbms_describe.number_table;
    v_tb_scale                   sys.dbms_describe.number_table;
    v_tb_radix                   sys.dbms_describe.number_table;
    v_tb_spare                   sys.dbms_describe.number_table;
    v_include_string_constraints boolean := false;
    v_indice                     number(3) := 0;
    v_string_rotina              varchar(1000);
  begin
    sys.dbms_describe.describe_procedure(object_name                => p_nome_rotina,
                                         reserved1                  => null,
                                         reserved2                  => null,
                                         overload                   => v_tb_overload,
                                         position                   => v_tb_position,
                                         level                      => v_tb_level,
                                         argument_name              => v_tb_argument_name,
                                         datatype                   => v_tb_datatype,
                                         default_value              => v_tb_default_value,
                                         in_out                     => v_tb_in_out,
                                         length                     => v_tb_length,
                                         precision                  => v_tb_precision,
                                         scale                      => v_tb_scale,
                                         radix                      => v_tb_radix,
                                         spare                      => v_tb_spare,
                                         include_string_constraints => v_include_string_constraints);
    --
    v_string_rotina := 'begin ';
    --
    if v_tb_position(1) = 0 then
      v_indice        := 2;
      v_string_rotina := v_string_rotina || ':v_retorno := ' ||
                         p_nome_rotina || '(';
    else
      v_indice        := 1;
      v_string_rotina := v_string_rotina || ':v_retorno := ''O''; ' ||
                         p_nome_rotina || '(';
    end if;
    --
    if nvl(v_tb_argument_name.count(), 0) > 0 then
      loop
        if v_tb_level(v_indice) = 0 then
          v_string_rotina := v_string_rotina ||
                             v_tb_argument_name(v_indice) || ' => ' ||
                             'pkg_executa_rotina.' ||
                             v_tb_argument_name(v_indice) || ',';
        end if;
        --
        v_indice := v_tb_argument_name.next(v_indice);
        --
        exit when v_indice is null;
      end loop;
      --
    end if;
    --   
    v_string_rotina := substr(v_string_rotina,
                              1,
                              length(v_string_rotina) - 1) || '); end;';
    -- 
    return(v_string_rotina);
  exception
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_monta_string_rotina : ' ||
                              sqlerrm);
  end fnc_monta_string_rotina;
  --
  function fnc_executa_rotina(p_string_rotina in varchar2) return varchar2 is
    c_cursor         number default dbms_sql.open_cursor;
    v_cursor         number;
    v_retorno_rotina varchar2(10) := 'O';
  begin
    -- parse no sql
    dbms_sql.parse(c_cursor, p_string_rotina, dbms_sql.native);
    -- implementa o bind
    dbms_sql.bind_variable(c_cursor, 'v_retorno', v_retorno_rotina);
    -- executa o cursor
    v_cursor := dbms_sql.execute(c_cursor);
    -- recupera o valor da variavel
    dbms_sql.variable_value(c_cursor, 'v_retorno', v_retorno_rotina);
    -- fecha o cursor
    dbms_sql.close_cursor(c_cursor);
    --
    return(v_retorno_rotina);
  exception
    when others then
      --
      if dbms_sql.is_open(c_cursor) then
        dbms_sql.close_cursor(c_cursor);
      end if;
      --
      raise_application_error(-20000,
                              'Erro rotina fnc_executa_rotina : ' ||
                              sqlerrm);
  end fnc_executa_rotina;
  --
  function fnc_valida_regra(p_id_regra in number, p_id_func in number)
    return varchar2 is
    v_id_rotina      number(3);
    v_nome_rotina    varchar(50);
    v_string_rotina  varchar(1000);
    v_retorno_rotina varchar2(3);
  begin
    --
    begin
      select rotina_id
        into v_id_rotina
        from regras
       where regras_id = p_id_regra;
    exception
      when no_data_found then
        raise_application_error(-20000, 'Nao encontrou a regra.');
      when others then
        raise_application_error(-20000,
                                'Erro ao recuperar a primeira rotina : ' ||
                                sqlerrm);
    end;
    --
    prc_popula_dados(p_id_func);
    --
    loop
      begin
        select nome_rotina
          into v_nome_rotina
          from rotinas
         where rotina_id = v_id_rotina;
      exception
        when others then
          raise_application_error(-20000,
                                  'Erro ao recuperar o nome da rotina : ' ||
                                  sqlerrm);
      end;
      --
      v_string_rotina  := fnc_monta_string_rotina(v_nome_rotina);
      v_retorno_rotina := fnc_executa_rotina(v_string_rotina);
      --
      begin
        select proxima_rotina_id
          into v_id_rotina
          from regra_sequencia_rotinas
         where regras_id = p_id_regra
         and   rotina_id = v_id_rotina
         and   retorno_funcao = v_retorno_rotina;
      exception
        when others then
          raise_application_error(-20000,
                                  'Erro ao recuperar o nome da rotina : ' ||
                                  sqlerrm);
      end;
      --
      exit when v_id_rotina is null;
    end loop;
    --
    return(v_retorno_rotina);
    --
  end fnc_valida_regra;
end pkg_executa_rotina;
/
