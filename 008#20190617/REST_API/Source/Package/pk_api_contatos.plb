CREATE OR REPLACE PACKAGE BODY pk_api_contatos IS

    const_url_base   CONSTANT VARCHAR2(200) := 'http://5cd226e0d935aa00141498ec.mockapi.io/api/v1/contatos';
    const_qtd_char   CONSTANT PLS_INTEGER := 32;
    --

    FUNCTION f_invocar_api (
        p_url     IN   VARCHAR2 DEFAULT const_url_base,
        p_verbo   IN   VARCHAR2,
        p_corpo   IN   CLOB DEFAULT NULL
    ) RETURN pk_api_base.t_retorno_api IS
    --

        v_request         utl_http.req;
        v_response        utl_http.resp;
        v_tamanho_corpo   PLS_INTEGER;
        v_index           PLS_INTEGER := 1;
        --
        v_retorno         pk_api_base.t_retorno_api;
    BEGIN
    --
        utl_http.set_transfer_timeout(10);
        v_request := utl_http.begin_request(url => p_url, method => p_verbo, http_version => utl_http.http_version_1_1);
        --

        utl_http.set_header(v_request
        , 'Accept', 'application/json; charset=utf-8');                                      
        --
        IF p_corpo IS NOT NULL THEN
            v_tamanho_corpo := length(p_corpo);
            utl_http.set_header(v_request, 'content-length', v_tamanho_corpo);
            utl_http.set_header(v_request, 'Content-Type', 'application/json');             
            --Setar o BODY da mensagem
            WHILE v_index <= v_tamanho_corpo LOOP
                utl_http.write_text(v_request, substr(p_corpo, v_index, const_qtd_char));
                v_index := v_index + const_qtd_char;
            END LOOP;

        END IF;
        --

        v_response := utl_http.get_response(v_request);
        --
        v_retorno.codigo_status := v_response.status_code;
        v_retorno.conteudo := pk_api_base.f_extrair_json(v_response);
        --
        utl_http.end_response(v_response);
        --
        RETURN v_retorno;
    --
    END f_invocar_api;
--

    FUNCTION f_get_por_id (
        p_id IN NUMBER
    ) RETURN pk_api_base.t_retorno_api IS
        v_retorno pk_api_base.t_retorno_api;
    BEGIN
        v_retorno := f_invocar_api(p_url => const_url_base
                                            || '/'
                                            || p_id,--
                                             p_verbo => 'GET');
        --

        RETURN v_retorno;
    END f_get_por_id;

    FUNCTION f_get RETURN pk_api_base.t_retorno_api IS
        v_retorno pk_api_base.t_retorno_api;
    BEGIN
        v_retorno := f_invocar_api(p_verbo => 'GET');
        --
        RETURN v_retorno;
    END f_get;

    FUNCTION p_post (
        p_json IN CLOB
    ) RETURN pk_api_base.t_retorno_api IS
        v_retorno pk_api_base.t_retorno_api;
    BEGIN
        v_retorno := f_invocar_api(p_verbo => 'POST', p_corpo => p_json);
        --
        RETURN v_retorno;
    END p_post;

    FUNCTION p_delete (
        p_id IN NUMBER
    ) RETURN pk_api_base.t_retorno_api IS
        v_retorno pk_api_base.t_retorno_api;
    BEGIN
        v_retorno := f_invocar_api(p_url => const_url_base
                                            || '/'
                                            || p_id,--
                                             p_verbo => 'DELETE');

        RETURN v_retorno;
    END p_delete;

    FUNCTION p_put (
        p_id     IN   NUMBER,
        p_json   IN   CLOB
    ) RETURN pk_api_base.t_retorno_api IS
        v_retorno pk_api_base.t_retorno_api;
    BEGIN
        v_retorno := f_invocar_api(p_url => const_url_base
                                            || '/'
                                            || p_id, --
                                             p_verbo => 'PUT',--
                                             p_corpo => p_json);
        --

        RETURN v_retorno;
    END p_put;

END pk_api_contatos;