create or replace PACKAGE BODY pk_api_base AS

    FUNCTION f_converte_blob_clob (
        p_blob      IN   BLOB,
        p_charset   IN   VARCHAR2 DEFAULT 'AL32UTF8'
    ) RETURN CLOB IS

        v_clob          CLOB;
        v_offset_dest   INTEGER := 1;
        v_offset_src    INTEGER := 1;
        v_warning       INTEGER;
        v_langcontext   INTEGER := dbms_lob.default_lang_ctx;
        v_csid          NUMBER;
    BEGIN
    --definir charset a ser usado na conversao
        IF p_charset IS NOT NULL THEN
            v_csid := nls_charset_id(p_charset);
        ELSE
            v_csid := dbms_lob.default_csid;
        END IF;
    --

        dbms_lob.createtemporary(v_clob, true, dbms_lob.call);
    --
        dbms_lob.converttoclob(dest_lob => v_clob, src_blob => p_blob, amount => dbms_lob.getlength(p_blob), dest_offset => v_offset_dest
        , src_offset => v_offset_src, blob_csid => v_csid, lang_context => v_langcontext, warning => v_warning);
    --

        RETURN v_clob;
    --
    END f_converte_blob_clob;

    FUNCTION f_valor_header_response (
        p_response IN OUT NOCOPY utl_http.resp,
        p_nome IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_header VARCHAR2(4000);
    BEGIN
    --
        utl_http.get_header_by_name(p_response, p_nome, v_header);
    --
        RETURN v_header;
    EXCEPTION
        WHEN utl_http.request_failed THEN
            RETURN NULL;
    END f_valor_header_response;

    FUNCTION f_extrair_json (
        p_response IN OUT NOCOPY utl_http.resp
    ) RETURN CLOB IS

        v_json             CLOB;
        v_conteudo         BLOB;
        v_raw              RAW(32727);
        v_charset          VARCHAR2(100);
        v_charset_header   VARCHAR2(100);
    BEGIN
    --
        BEGIN
            dbms_lob.createtemporary(v_conteudo, true, dbms_lob.call);
            LOOP
                utl_http.read_raw(p_response, v_raw);
                dbms_lob.append(v_conteudo, v_raw);
            END LOOP;

        EXCEPTION
            WHEN utl_http.end_of_body THEN
                NULL;
        END;
      -- 

        IF f_valor_header_response(p_response => p_response, p_nome => 'Content-Encoding') = 'GZIP' THEN
            v_conteudo := utl_compress.lz_uncompress(v_conteudo);
        END IF;
     --

        v_charset_header := f_valor_header_response(p_response => p_response, p_nome => 'Content-Type');
        CASE
            WHEN instr(upper(v_charset_header), 'UTF-8') > 0 THEN
                v_charset := 'AL32UTF8';
            WHEN instr(upper(v_charset_header), 'UTF-16') > 0 THEN
                v_charset := 'AL16UTF16';
            ELSE
                v_charset := NULL;
        END CASE;
    -- Conversao para Texto 

        v_json := f_converte_blob_clob(v_conteudo, v_charset);
    --liberar memoria do binario
        dbms_lob.freetemporary(v_conteudo);
    --
        RETURN v_json;
    END f_extrair_json;

END pk_api_base;