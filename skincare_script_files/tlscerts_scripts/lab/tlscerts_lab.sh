#!/bin/bash


set -x


#Here /organizations/xyz and  organizations/xyz is a 
#Make sure you already have a folder named users created and it should contain a folder named tlsca_admin

export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/tlsca_certs/lab/users/tlsca_admin


fabric-ca-client enroll -d -u https://tlscaadmin:tlscaadminpw@tlsca-lab:7054 --caname tlsca-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" --enrollment.profile tls 



fabric-ca-client register -d --caname tlsca-lab --id.name rcaadmin --id.secret rcaadminpw  --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/lab/users/tlsca_admin/msp"

fabric-ca-client enroll -d -u https://rcaadmin:rcaadminpw@tlsca-lab:7054 --caname tlsca-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" --enrollment.profile tls --csr.hosts orgca-lab --mspdir "${PWD}/organizations/tlsca_certs/lab/users/rca_admin/msp"


fabric-ca-client register -d --caname tlsca-lab --id.name peer0 --id.secret peer0pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/lab/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://peer0:peer0pw@tlsca-lab:7054 --caname tlsca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls" --enrollment.profile tls --csr.hosts peer0-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer0.lab.skincare.com/tls/server.key"  



fabric-ca-client register -d --caname tlsca-lab --id.name peer1 --id.secret peer1pw  --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem" --mspdir "${PWD}/organizations/tlsca_certs/lab/users/tlsca_admin/msp"

fabric-ca-client enroll -u https://peer1:peer1pw@tlsca-lab:7054 --caname tlsca-lab -M "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls" --enrollment.profile tls --csr.hosts peer1-lab --tls.certfiles "${PWD}/organizations/tlsca_certs/lab/ca-cert.pem"

cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/ca.crt"
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/server.crt"
cp "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/lab.skincare.com/peers/peer1.lab.skincare.com/tls/server.key"  





{ set +x; } 2>/dev/null

