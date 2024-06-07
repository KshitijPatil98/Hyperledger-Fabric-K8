set -x

#Here we are not making directory because it will already be created during tls certs generation
#mkdir -p organizations/peerOrganizations/oyur.skincare.com/

:'The below is equivalent of tlsca_admin which we had in tlscerts. Just that here we dont really store it inside a folder called same orgca_admin but its the same function. The orgcaadmin certificates will be stored in msp folder in oyur.skincare.com. In case of tlsca it used to get stored inside tlscaadmin folder . 
'
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/oyur.skincare.com/


#When this enroll happens a msp folder gets generated in the fabric ca client home directory and these are basically certificates of the orgca admin.    
fabric-ca-client enroll -u https://orgcaadmin:orgcaadminpw@orgca-oyur:8055 --caname orgca-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/orgca-oyur-8055-orgca-oyur.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/orgca-oyur-8055-orgca-oyur.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/orgca-oyur-8055-orgca-oyur.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/orgca-oyur-8055-orgca-oyur.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/config.yaml"
    
    
# Copy oyur org's tls CA cert to oyur org's /msp/tlscacerts directory (for use in the channel MSP definition)
mkdir -p "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/tlscacerts"
cp "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/tlscacerts/ca.crt"

# Copy oyur org's tls CA cert to oyur org's /tlsca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/oyur.skincare.com/tlsca"
cp "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/tlsca/tlsca.oyur.skincare.com-cert.pem"

# Copy oyur org's CA cert to oyur org's /ca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/oyur.skincare.com/ca"
cp "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/ca/ca.oyur.skincare.com-cert.pem"



#Here we are not specifying msp of bootstrap admin using msp dir flag because be default it is set to point to a msp folder in in fabric-ca-client home directory.  

fabric-ca-client register --caname orgca-oyur --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"

fabric-ca-client register --caname orgca-oyur --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"
 
fabric-ca-client register --caname orgca-oyur --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"

fabric-ca-client register --caname orgca-oyur --id.name oyurorgadmin --id.secret oyurorgadminpw --id.type admin --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"




fabric-ca-client enroll -u https://peer0:peer0pw@orgca-oyur:8055 --caname orgca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/msp" --csr.hosts peer0-oyur  --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer1:peer1pw@orgca-oyur:8055 --caname orgca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/msp" --csr.hosts peer1-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://user1:user1pw@orgca-oyur:8055 --caname orgca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/User1@oyur.skincare.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/User1@oyur.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://oyurorgadmin:oyurorgadminpw@orgca-oyur:8055 --caname orgca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/Admin@oyur.skincare.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/Admin@oyur.skincare.com/msp/config.yaml"

{ set +x; } 2>/dev/null

