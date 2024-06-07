#!/bin/bash


set -x


#Here /organizations/xyz and  organizations/xyz is a 
#Make sure you already have a folder named users created and it should contain a folder named tlsca_admin

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/tlsca_certs/oyur/users/tlsca_admin


fabric-ca-client enroll -d -u https://tlscaadmin:tlscaadminpw@tlsca-oyur:7055 --caname tlsca-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" --enrollment.profile tls 



fabric-ca-client register -d --caname tlsca-oyur --id.name rcaadmin --id.secret rcaadminpw  --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/oyur/users/tlsca_admin/msp"

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@tlsca-oyur:7055 --caname tlsca-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" --enrollment.profile tls --csr.hosts orgca-oyur --mspdir "${PWD}/organizations/tlsca_certs/oyur/users/rca_admin/msp"


fabric-ca-client register -d --caname tlsca-oyur --id.name peer0 --id.secret peer0pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/oyur/users/tlsca_admin/msp"


fabric-ca-client enroll -u https://peer0:peer0pw@tlsca-oyur:7055 --caname tlsca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls" --enrollment.profile tls --csr.hosts peer0-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer0.oyur.skincare.com/tls/server.key"  



fabric-ca-client register -d --caname tlsca-oyur --id.name peer1 --id.secret peer1pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/oyur/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://peer1:peer1pw@tlsca-oyur:7055 --caname tlsca-oyur -M "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls" --enrollment.profile tls --csr.hosts peer1-oyur --tls.certfiles "${PWD}/organizations/tlsca_certs/oyur/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/oyur.skincare.com/peers/peer1.oyur.skincare.com/tls/server.key"  




{ set +x; } 2>/dev/null

