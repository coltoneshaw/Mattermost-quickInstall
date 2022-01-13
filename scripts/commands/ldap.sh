
#!/bin/bash
source .env

initialSetup(){
    bash $SCRIPTS_COMMANDS/installDocker.sh installDocker
    docker run -d --rm -p 10389:10389 -p 10636:10636 rroemhild/test-openldap
}

addLdifUsers(){
    bash $SCRIPTS_UTILITIES echoStatus "Adding LDAP users... This may take a while. Get popcorn."
    ldapmodify -a -x -c -D "cn=admin,dc=planetexpress,dc=com" -H ldap://localhost:10389 -x -w GoodNewsEveryone -f $SETUP_DIR/ldap/add-users.ldif 
    ldapmodify -a -x -c -D "cn=admin,dc=planetexpress,dc=com" -H ldap://localhost:10389 -x -w GoodNewsEveryone -f $SETUP_DIR/ldap/add-groups.ldif
    ldapmodify -a -x -c -D "cn=admin,dc=planetexpress,dc=com" -H ldap://localhost:10389 -x -w GoodNewsEveryone -f $SETUP_DIR/ldap/group-membership.ldif

    bash $SCRIPTS_UTILITIES echoStatus "Finished!"
}