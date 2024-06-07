#!/bin/bash


set -x


#Here /organizations/xyz and  organizations/xyz is a 
#Make sure you already have a folder named users created and it should contain a folder named tlsca_admin

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin


:'Here we are using localhost because inside  containers in same network can talk to each other using names but here this script is running from my pc and my pc doesnt know what tlsca-${ORGNAME_ALL_LOWER} is
so i am using localhost. One option is to make an entry in /etc/hosts file on my machine and that will do it
'
fabric-ca-client enroll -d -u https://tlscaadmin:tlscaadminpw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --enrollment.profile tls --csr.hosts 'tlsca-admin' --csr.hosts 'localhost'



fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name rcaadmin --id.secret rcaadminpw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --enrollment.profile tls --csr.hosts 'orgca-${ORGNAME_ALL_LOWER}' --csr.hosts 'localhost' --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/rca_admin/msp"


fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name peer0 --id.secret peer0pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://peer0:peer0pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.key"  



fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name peer1 --id.secret peer1pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://peer1:peer1pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls" --enrollment.profile tls --csr.hosts peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.key"  



#Here we will also generate tls certificates for our chaincode container 

fabric-ca-client register -d --caname tlsca-${ORGNAME_ALL_LOWER} --id.name ${CC_NAME} --id.secret ${CC_NAME}pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/users/tlsca_admin/msp"

#Here below command will generate the necessary certificates in the folder specified using -M flag. Also
fabric-ca-client enroll -u https://${CC_NAME}:${CC_NAME}pw@localhost:${TLSCAPORT} --caname tlsca-${ORGNAME_ALL_LOWER} -M "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/tls" --enrollment.profile tls --csr.hosts ${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"


cp "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/tls/tlscacerts/"* "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/crypto/root_cert.pem"
cp "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/tls/signcerts/"* "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/crypto/cert.pem"
cp "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/tls/keystore/"* "${PWD}/${PROJECT_NAME}_cc_files/${ORGNAME_ALL_LOWER}/crypto/key.pem"



{ set +x; } 2>/dev/null

