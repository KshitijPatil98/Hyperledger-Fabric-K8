set -x

#Here we are not making directory because it will already be created during tls certs generation
#mkdir -p organizations/ordererOrganizations/orderer.skincare.com/

:'The below is equivalent of tlsca_admin. Just that here we dont really store it inside a folder called same orgca_admin but its the same function. The orgcaadmin certificates will be stored in
msp folder in orderer.skincare.com. In case of tlsca it used to get stored inside tlsca folder. 
'
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/orderer.skincare.com/


#When this enroll happens a msp folder gets generated in the fabric ca client home directory and these are basically certificates of the orgca admin.    
fabric-ca-client enroll -u https://orgcaadmin:orgcaadminpw@orgca-orderer:8056 --caname orgca-orderer --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem"

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/orgca-orderer-8056-orgca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/orgca-orderer-8056-orgca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/orgca-orderer-8056-orgca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/orgca-orderer-8056-orgca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/config.yaml"
    
    
# Copy orderer org's tls CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
mkdir -p "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/tlscacerts"
cp "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/tlscacerts/ca.crt"

# Copy orderer org's tls CA cert to orderer org's /tlsca directory (for use by clients)
mkdir -p "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/tlsca"
cp "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/tlsca/tlsca.orderer.skincare.com-cert.pem"

# Copy orderer org's CA cert to orderer org's /ca directory (for use by clients)
mkdir -p "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/ca"
cp "${PWD}/organizations/orgca_certs/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/ca/ca.orderer.skincare.com-cert.pem"



#Here we are not specifying msp of bootstrap admin using msp dir flag because be default it is set to point to a msp folder in in fabric-ca-client home directory.  

fabric-ca-client register --caname orgca-orderer --id.name orderer0 --id.secret orderer0pw --id.type orderer --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem"

fabric-ca-client register --caname orgca-orderer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem"

fabric-ca-client register --caname orgca-orderer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem"
 
fabric-ca-client register --caname orgca-orderer --id.name ordererorgadmin --id.secret ordererorgadminpw --id.type admin --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem"




fabric-ca-client enroll -u https://orderer0:orderer0pw@orgca-orderer:8056 --caname orgca-orderer -M "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer0.skincare.com/msp" --csr.hosts orderer0  --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" 
cp "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer0.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://orderer1:orderer1pw@orgca-orderer:8056 --caname orgca-orderer -M "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer1.skincare.com/msp" --csr.hosts orderer1  --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" 
cp "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer1.skincare.com/msp/config.yaml"

fabric-ca-client enroll -u https://orderer2:orderer2pw@orgca-orderer:8056 --caname orgca-orderer -M "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer2.skincare.com/msp" --csr.hosts orderer2  --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" 
cp "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/orderers/orderer2.skincare.com/msp/config.yaml"


fabric-ca-client enroll -u https://ordererorgadmin:ordererorgadminpw@orgca-orderer:8056 --caname orgca-orderer -M "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/users/Admin@orderer.skincare.com/msp" --tls.certfiles "${PWD}/organizations/tlsca_certs/orderer/ca-cert.pem" 
cp "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/orderer.skincare.com/users/Admin@orderer.skincare.com/msp/config.yaml"

{ set +x; } 2>/dev/null

