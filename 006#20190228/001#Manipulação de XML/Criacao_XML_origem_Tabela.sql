SELECT xmlelement("emps",
                  xmlagg(xmlforest(d.deptno AS "depto",
                                   (SELECT xmlagg(xmlelement("empregados",
                                                             xmlforest(e.ename,
                                                                       e.job,
                                                                       e.hiredate,
                                                                       e.sal,
                                                                       e.comm)))
                                    FROM   emp e
                                    WHERE  e.deptno = d.deptno) "emp_list"))) AS "depts"
FROM   emp d
