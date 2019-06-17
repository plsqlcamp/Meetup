create or replace PACKAGE pk_api_base AS
    TYPE t_retorno_api IS RECORD (
        codigo_status   PLS_INTEGER,
        conteudo      CLOB
    );
  
    FUNCTION f_extrair_json (
        p_response IN OUT NOCOPY utl_http.resp
    ) RETURN CLOB;
    
END pk_api_base;