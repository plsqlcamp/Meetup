CREATE OR REPLACE PROCEDURE recebexml
(
  diretorio,
  nome_arquivo
) IS
  variavel_clob CLOB;
BEGIN
  -- Carregando o XML em uma variavel.
  SELECT xmlserialize(document
                      xmltype(bfilename(diretorio, nome_arquivo), nls_charset_id('AL32UTF8'))) AS xmldoc
  INTO   variavel_clob
  FROM   dual;
  --
  INSERT INTO tabela_xml
    (primary_key_tabela, -- NUMBER
     arquivo_xml) -- XMLTYPE
  VALUES
    (1,
     xmltype.createxml(variavel_clob));
  --
END recebexml;
