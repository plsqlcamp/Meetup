CREATE OR REPLACE PACKAGE pk_ctrl_contatos AS
    PROCEDURE p_insere_contato (
        p_id IN NUMBER
    );

END pk_ctrl_contatos;