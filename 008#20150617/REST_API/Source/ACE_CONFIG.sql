BEGIN
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => '*.mockapi.io', 
    ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                              principal_name => 'hr',
                              principal_type => xs_acl.ptype_db)); 
END;
