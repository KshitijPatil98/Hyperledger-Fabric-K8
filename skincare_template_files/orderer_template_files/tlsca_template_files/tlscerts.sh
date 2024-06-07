set -x


export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin


fabric-ca-client enroll -d -u https://tlscaadmin:tlscaadminpw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --enrollment.profile tls --csr.hosts 'tlsca-admin'


fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name rcaadmin --id.secret rcaadminpw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --enrollment.profile tls --csr.hosts 'orgca-${ORGNAME_ALL_LOWER}' --csr.hosts 'localhost'  --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/rca_admin/msp"




#------------------------------------------REGISTERING AND ENROLLING ${ORDERER0_NAME} NODE OF ${ORGNAME_ALL_LOWER} ORGANIZATION-----------

#you can also run this command without mspdir flag as by defualt it looks for msp folder inside fabric ca client directory
fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name ${ORDERER0_NAME} --id.secret ${ORDERER0_NAME}pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://${ORDERER0_NAME}:${ORDERER0_NAME}pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts ${ORDERER0_NAME}.${PROJECT_NAME}.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

# Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER0_NAME}.${PROJECT_NAME}.com/tls/server.key"  




#---------------------------------------REGISTERING AND ENROLLING ${ORDERER1_NAME} NODE OF ${ORGNAME_ALL_LOWER} ORGANIZATION----------

#you can also run this command without mspdir flag as by defualt it looks for msp folder inside fabric ca client directory
fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name ${ORDERER1_NAME} --id.secret ${ORDERER1_NAME}pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://${ORDERER1_NAME}:${ORDERER1_NAME}pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts ${ORDERER1_NAME}.${PROJECT_NAME}.com  --csr.hosts localhost --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

# Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER1_NAME}.${PROJECT_NAME}.com/tls/server.key"  



#--------------------------------------REGISTERING AND ENROLLING ${ORDERER2_NAME} NODE OF ${ORGNAME_ALL_LOWER} ORGANIZATION---------

#you can also run this command without mspdir flag as by defualt it looks for msp folder inside fabric ca client directory
fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name ${ORDERER2_NAME} --id.secret ${ORDERER2_NAME}pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://${ORDERER2_NAME}:${ORDERER2_NAME}pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts ${ORDERER2_NAME}.${PROJECT_NAME}.com  --csr.hosts localhost --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

# Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/${ORGNAME_ALL_LOWER}s/${ORDERER2_NAME}.${PROJECT_NAME}.com/tls/server.key"  


#--------------------------------------REGISTERING AND ENROLLING ADMIN USER OF ${ORGNAME_ALL_LOWER} ORGANIZATION------------------
:'
Now, technically tls certificates are generated only for the server endpoints. It means certificates are only generated for the identities which act as server(example fabric ca server),
peers, orderers etc.
Now we always have 2 admins. One admin is like the bootstrap admin which is basically admin of the ca server. Other is an admin user of the organization which is of type admin. This is like a 
priviledged user of the organization which is responsible for doing some administrative tasks like joining orderer nodes to the channel etc. 
Now, in the latest update you dont need to create a system channel and application channel seperately. You just create a channel block using the configtx file and the tool and then use the
osnadmin cli to join the ordering nodes to the channel. Now, for running this osnadmin  command you need to be an admim with certain privileges. Now you might wonder that, the admin which we are
talking of is already getting enrolled in the orgcerts_orderer.sh file why do we need tls certificates for this orderer admin user. The reason is when we hit the osnadmin command it is targetted to the 
admin port on the same orderer node(same IP) just a different port. It is configured during bootstraping the orderer node. Now the intercation between the osnadmin and the orderer admin server 
endpoint needs to be mutual tls (both client side and server side need to provide tls certificates during the interaction). Now the orderer admin server certificates are nothing but the tls certificates of the orderer node itself. And the admin client certificates will be generated below
'

#you can also run this command without mspdir flag as by defualt it looks for msp folder inside fabric ca client directory
fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name ${ORGNAME_ALL_LOWER}orgadmin --id.secret ${ORGNAME_ALL_LOWER}orgadminpw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://${ORGNAME_ALL_LOWER}orgadmin:${ORGNAME_ALL_LOWER}orgadminpw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts ${ORGNAME_ALL_LOWER}orgadmin --csr.hosts localhost  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

# Copy the tls CA cert, server cert, server keystore to well known file names. We are just renaming here.
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.key"  


{ set +x; } 2>/dev/null

