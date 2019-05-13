create or replace PACKAGE BODY pk_ctrl_contatos AS

    PROCEDURE p_insere_contato (
        p_id IN NUMBER
    ) IS
        v_contato_api   hr.pk_api_base.t_retorno_api;
        v_json          json_object_t;
        v_contato_tab   contatos%rowtype;
    BEGIN
        v_contato_api := pk_api_contatos.f_get_por_id(p_id => p_id);
        IF v_contato_api.codigo_status = 200 THEN
            v_json := new json_object_t(v_contato_api.conteudo);
            v_contato_tab.id := v_json.get_number('id');
            v_contato_tab.nome := v_json.get_string('nome');
            v_contato_tab.whatsapp := v_json.get_string('whatsapp');
            v_contato_tab.resumo_pessoal := v_json.get_Clob('resumo_pessoal');
            v_contato_tab.imagem := pk_base64.decodificar(v_json.get_clob('imagem'));
            INSERT INTO contatos VALUES v_contato_tab;

        END IF;

    END p_insere_contato;

END pk_ctrl_contatos;