WITH tabela AS
 (SELECT tabela_xml.primary_key_tabela,
         xml_arq_1.ordernumber,
         xml_arq_2.*
  FROM   tabela_xml,
         xmltable(xmlnamespaces('http://www.w3.org/2001/XMLSchema-instance' AS "schema"),
                  '/PurchaseOrders/PurchaseOrder' passing tabela_xml.arquivo_xml columns ordernumber
                  VARCHAR(500) path 'PurchaseOrderNumber/OrderNumber',
                  address xmltype path 'Address') xml_arq_1,
         xmltable(xmlnamespaces('http://www.w3.org/2001/XMLSchema-instance' AS "schema"),
                  '/Address' passing xml_arq_1.address columns tipo VARCHAR(500) path 'Type',
                  ender VARCHAR(500) path 'Name',
                  street VARCHAR(500) path 'Street',
                  state VARCHAR(500) path 'State',
                  zip VARCHAR(500) path 'Zip',
                  country VARCHAR(500) path 'Country') xml_arq_2
  WHERE  tabela_xml.primary_key_tabela = 1)
SELECT xmlelement("orders",
                  xmlagg(xmlelement("order",
                                    xmlforest(d.ordernumber AS "ordernumber",
                                              (SELECT xmlagg(xmlelement("endereco",
                                                                        xmlforest(e.ender AS "ender",
                                                                                  e.street AS "street",
                                                                                  e.state AS "state",
                                                                                  e.zip AS "zip",
                                                                                  e.country AS "country")))
                                               FROM   tabela e
                                               WHERE  e.ordernumber = d.ordernumber) "emp_list")))) AS "depts"
FROM   tabela d
WHERE  d.ordernumber = 99503
AND    rownum = 1;
