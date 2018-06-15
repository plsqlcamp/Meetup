create or replace package pkg_rotina is
  --
  function fnc_regiao_americas(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2;
  --
  function fnc_regiao_europa(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2;
  --
  function fnc_dpto_financeiro(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2;
  --
  function fnc_dpto_vendas(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2;
  --
  function fnc_cargo_gerente(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2;
  --
end pkg_rotina;
/
create or replace package body pkg_rotina is
  --
  function fnc_regiao_americas(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2 is
    v_qtd_func_type number(2);
    e_problema_cadastro exception;
    v_retorno varchar2(3);
  begin
    --
    v_qtd_func_type := p_dados_func.count();
    --
    if v_qtd_func_type = 1 then
      if p_dados_func(1).regiao = 'Americas' then
        v_retorno := 'S';
      else
        v_retorno := 'N';
      end if;
    else
      raise e_problema_cadastro;
    end if;
    --
    return(v_retorno);
  exception
    when e_problema_cadastro then
      raise_application_error(-20000,
                              'Problemas com o cadastro do funcionario.');
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_regiao_americas : ' ||
                              sqlerrm);
  end fnc_regiao_americas;
  --
  function fnc_regiao_europa(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2 is
    v_qtd_func_type number(2);
    e_problema_cadastro exception;
    v_retorno varchar2(3);
  begin
    --
    v_qtd_func_type := p_dados_func.count();
    --
    if v_qtd_func_type = 1 then
      if p_dados_func(1).regiao = 'Europe' then
        v_retorno := 'S';
      else
        v_retorno := 'N';
      end if;
    else
      raise e_problema_cadastro;
    end if;
    --
    return(v_retorno);
  exception
    when e_problema_cadastro then
      raise_application_error(-20000,
                              'Problemas com o cadastro do funcionario.');
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_regiao_europa : ' || sqlerrm);
  end fnc_regiao_europa;
  --
  function fnc_dpto_financeiro(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2 is
    v_qtd_func_type number(2);
    e_problema_cadastro exception;
    v_retorno varchar2(3);
  begin
    --
    v_qtd_func_type := p_dados_func.count();
    --
    if v_qtd_func_type = 1 then
      if p_dados_func(1).nome_departamento = 'Finance' then
        v_retorno := 'S';
      else
        v_retorno := 'N';
      end if;
    else
      raise e_problema_cadastro;
    end if;
    --
    return(v_retorno);
  exception
    when e_problema_cadastro then
      raise_application_error(-20000,
                              'Problemas com o cadastro do funcionario.');
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_dpto_financeiro : ' ||
                              sqlerrm);
  end fnc_dpto_financeiro;
  --
  function fnc_dpto_vendas(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2 is
    v_qtd_func_type number(2);
    e_problema_cadastro exception;
    v_retorno varchar2(3);
  begin
    --
    v_qtd_func_type := p_dados_func.count();
    --
    if v_qtd_func_type = 1 then
      if p_dados_func(1).nome_departamento = 'Sales' then
        v_retorno := 'S';
      else
        v_retorno := 'N';
      end if;
    else
      raise e_problema_cadastro;
    end if;
    --
    return(v_retorno);
  exception
    when e_problema_cadastro then
      raise_application_error(-20000,
                              'Problemas com o cadastro do funcionario.');
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_dpto_vendas : ' || sqlerrm);
  end fnc_dpto_vendas;
  --
  function fnc_cargo_gerente(p_dados_func in pkg_executa_rotina.typ_tab_dados_func)
    return varchar2 is
    v_qtd_func_type number(2);
    e_problema_cadastro exception;
    v_retorno varchar2(3);
  begin
    --
    v_qtd_func_type := p_dados_func.count();
    --
    if v_qtd_func_type = 1 then
      if p_dados_func(1).cargo_funcionario like '%Manager%' then
        v_retorno := 'S';
      else
        v_retorno := 'N';
      end if;
    else
      raise e_problema_cadastro;
    end if;
    --
    return(v_retorno);
  exception
    when e_problema_cadastro then
      raise_application_error(-20000,
                              'Problemas com o cadastro do funcionario.');
    when others then
      raise_application_error(-20000,
                              'Erro rotina fnc_cargo_gerente : ' || sqlerrm);
  end fnc_cargo_gerente;
  --
end pkg_rotina;
/
