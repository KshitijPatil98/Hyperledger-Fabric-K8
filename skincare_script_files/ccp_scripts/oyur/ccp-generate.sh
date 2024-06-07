#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${PWD}/skincare_script_files/ccp_scripts/oyur/ccp-template.json
}


ORG=Oyur
P0PORT=9055
CAPORT=8055
PEERPEM=${PWD}/organizations/peerOrganizations/oyur.skincare.com/tlsca/tlsca.oyur.skincare.com-cert.pem
CAPEM=${PWD}/organizations/peerOrganizations/oyur.skincare.com/ca/ca.oyur.skincare.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${PWD}/organizations/peerOrganizations/oyur.skincare.com/connection-oyur.json

