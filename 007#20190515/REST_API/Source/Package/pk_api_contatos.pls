create or replace PACKAGE pk_api_contatos IS
    FUNCTION f_get_por_id (
        p_id IN NUMBER
    ) RETURN pk_api_base.t_retorno_api;

    FUNCTION f_get RETURN pk_api_base.t_retorno_api;

    FUNCTION p_post (
        p_json IN CLOB
    ) RETURN pk_api_base.t_retorno_api;

    FUNCTION p_delete (
        p_id IN NUMBER
    ) RETURN pk_api_base.t_retorno_api;

    FUNCTION p_put (
        p_id in number,
        p_json   IN CLOB
    ) RETURN pk_api_base.t_retorno_api;

END pk_api_contatos;