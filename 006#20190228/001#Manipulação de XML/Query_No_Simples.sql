SELECT tabela_xml.primary_key_tabela,
       xml_arq_1.*
FROM   tabela_xml,
       xmltable(xmlnamespaces('http://www.w3.org/2001/XMLSchema-instance' AS "schema"),
                '/PurchaseOrders/PurchaseOrder' passing tabela_xml.arquivo_xml columns ordernumber
                VARCHAR(500) path 'PurchaseOrderNumber/OrderNumber',
                address xmltype path 'Address') xml_arq_1
WHERE  tabela_xml.primary_key_tabela = 1;
