set -x

#Here we are not making directory because it will already be created during tls certs generation
#mkdir -p organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/

:'The below is equivalent of tlsca_admin which we had in tlscerts. Just that here we dont really store it inside a folder called same orgca_admin but its the same function. The orgcaadmin certificates will be stored in msp folder in ${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com. In case of tlsca it used to get stored inside tlscaadmin folder . 
'
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/


#When this enroll happens a msp folder gets generated in the fabric ca client home directory and these are basically certificates of the orgca admin.    
fabric-ca-client enroll -u https://orgcaadmin:orgcaadminpw@localhost:${ORGCAPORT} --caname orgca-${ORGNAME_ALL_LOWER} --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-${ORGCAPORT}-orgca-${ORGNAME_ALL_LOWER}.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-${ORGCAPORT}-orgca-${ORGNAME_ALL_LOWER}.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-${ORGCAPORT}-orgca-${ORGNAME_ALL_LOWER}.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-${ORGCAPORT}-orgca-${ORGNAME_ALL_LOWER}.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml"
    
    
# Copy ${ORGNAME_ALL_LOWER} org's tls CA cert to ${ORGNAME_ALL_LOWER} org's /msp/tlscacerts directory (for use in the channel MSP definition)
mkdir -p "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/tlscacerts"
cp "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/tlscacerts/ca.crt"

# Copy ${ORGNAME_ALL_LOWER} org's tls CA cert to ${ORGNAME_ALL_LOWER} org's /tlsca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca"
cp "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca/tlsca.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem"

# Copy ${ORGNAME_ALL_LOWER} org's CA cert to ${ORGNAME_ALL_LOWER} org's /ca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/ca"
cp "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/ca/ca.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem"



#Here we are not specifying msp of bootstrap admin using msp dir flag because be default it is set to point to a msp folder in in fabric-ca-client home directory.  

fabric-ca-client register --caname orgca-${ORGNAME_ALL_LOWER} --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

fabric-ca-client register --caname orgca-${ORGNAME_ALL_LOWER} --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"
 
fabric-ca-client register --caname orgca-${ORGNAME_ALL_LOWER} --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"

fabric-ca-client register --caname orgca-${ORGNAME_ALL_LOWER} --id.name ${ORGNAME_ALL_LOWER}orgadmin --id.secret ${ORGNAME_ALL_LOWER}orgadminpw --id.type admin --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem"




fabric-ca-client enroll -u https://peer0:peer0pw@localhost:${ORGCAPORT} --caname orgca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp" --csr.hosts peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com  --csr.hosts localhost  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer1:peer1pw@localhost:${ORGCAPORT} --caname orgca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp" --csr.hosts peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com  --csr.hosts localhost  --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/peers/peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml"


fabric-ca-client enroll -u https://user1:user1pw@localhost:${ORGCAPORT} --caname orgca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/User1@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/User1@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml"

fabric-ca-client enroll -u https://${ORGNAME_ALL_LOWER}orgadmin:${ORGNAME_ALL_LOWER}orgadminpw@localhost:${ORGCAPORT} --caname orgca-${ORGNAME_ALL_LOWER} -M "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/${ORGNAME_ALL_LOWER}/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp/config.yaml"

{ set +x; } 2>/dev/null

