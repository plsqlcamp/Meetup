CREATE OR REPLACE PACKAGE pk_base64 AS
    FUNCTION decodificar (
        p_base64 IN CLOB
    ) RETURN BLOB;

    FUNCTION codificar (
        p_blob IN BLOB
    ) RETURN CLOB;

END pk_base64;