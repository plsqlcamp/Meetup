CREATE OR REPLACE PACKAGE BODY pk_base64 AS

    FUNCTION decodificar (
        p_base64 IN CLOB
    ) RETURN BLOB IS

        v_blob            BLOB;
        v_buffersize      INTEGER := 48;
        v_offset          INTEGER;
        v_buffervarchar   VARCHAR2(48);
        v_bufferraw       RAW(48);
    BEGIN
    --
        dbms_lob.createtemporary(v_blob, true);
        v_offset := 1;
    --
        BEGIN
            LOOP
                dbms_lob.read(p_base64, v_buffersize, v_offset, v_buffervarchar);
                v_bufferraw := utl_raw.cast_to_raw(v_buffervarchar);
                v_bufferraw := utl_encode.base64_decode(v_bufferraw);
                dbms_lob.append(v_blob, v_bufferraw);
                v_offset := v_offset + v_buffersize;
            END LOOP;
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;

        RETURN v_blob;
    END decodificar;

    FUNCTION codificar (
        p_blob IN BLOB
    ) RETURN CLOB IS

        v_base64          CLOB;
        v_buffersize      INTEGER := 48;
        v_offset          INTEGER;
        v_buffervarchar   VARCHAR2(100);
        v_bufferraw       RAW(100);
    BEGIN
    --
        dbms_lob.createtemporary(v_base64, true);
        v_offset := 1;
    --
        BEGIN
            LOOP
                dbms_lob.read(lob_loc => p_blob, amount => v_buffersize, offset => v_offset, buffer => v_bufferraw);

                v_bufferraw := utl_encode.base64_encode(v_bufferraw);
                v_buffervarchar := utl_raw.cast_to_varchar2(v_bufferraw);
                dbms_lob.append(v_base64, v_buffervarchar);
                v_offset := v_offset + v_buffersize;
            END LOOP;
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;

        RETURN v_base64;
    END codificar;

END pk_base64;