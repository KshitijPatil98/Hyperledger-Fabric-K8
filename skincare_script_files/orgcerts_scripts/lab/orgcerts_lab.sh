set -x

#Here we are not making directory because it will already be created during tls certs generation
#mkdir -p organizations/peerOrganizations/lab.skincare.com/

:'The below is equivalent of tlsca_admin which we had in tlscerts. Just that here we dont really store it inside a folder called same orgca_admin but its the same function. The orgcaadmin certificates will be stored in msp folder in lab.skincare.com. In case of tlsca it used to get stored inside tlscaadmin folder . 
'
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/lab.skincare.com/


#When this enroll happens a msp folder gets generated in the fabric ca client home directory and these are basically certificates of the orgca admin.    
fabric-ca-client enroll -u https://orgcaadmin:orgcaadminpw@orgca-lab:8054 --caname orgca-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/orgca-lab-8054-orgca-lab.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/orgca-lab-8054-orgca-lab.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/orgca-lab-8054-orgca-lab.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/orgca-lab-8054-orgca-lab.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/config.yaml"
    
    
# Copy lab org's tls CA cert to lab org's /msp/tlscacerts directory (for use in the channel MSP definition)
mkdir -p "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/tlscacerts"
cp "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/tlscacerts/ca.crt"

# Copy lab org's tls CA cert to lab org's /tlsca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/lab.skincare.com/tlsca"
cp "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/lab.skincare.com/tlsca/tlsca.lab.skincare.com-cert.pem"

# Copy lab org's CA cert to lab org's /ca directory (for use by clients)
mkdir -p "${PWD}/organizations/peerOrganizations/lab.skincare.com/ca"
cp "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/lab.skincare.com/ca/ca.lab.skincare.com-cert.pem"



#Here we are not specifying msp of bootstrap admin using msp dir flag because be default it is set to point to a msp folder in in fabric-ca-client home directory.  

fabric-ca-client register --caname orgca-lab --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"

fabric-ca-client register --caname orgca-lab --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"
 
fabric-ca-client register --caname orgca-lab --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"

fabric-ca-client register --caname orgca-lab --id.name laborgadmin --id.secret laborgadminpw --id.type admin --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"



fabric-ca-client enroll -u https://peer0:peer0pw@orgca-lab:8054 --caname orgca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/msp" --csr.hosts peer0-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://peer1:peer1pw@orgca-lab:8054 --caname orgca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/msp" --csr.hosts peer1-lab  --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/msp/config.yaml"


fabric-ca-client enroll -u https://user1:user1pw@orgca-lab:8054 --caname orgca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/users/User1@lab.skincare.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/lab.skincare.com/users/User1@lab.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://laborgadmin:laborgadminpw@orgca-lab:8054 --caname orgca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/users/Admin@lab.skincare.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" 
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/lab.skincare.com/users/Admin@lab.skincare.com/msp/config.yaml"

{ set +x; } 2>/dev/null

