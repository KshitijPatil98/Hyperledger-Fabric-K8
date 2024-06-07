#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. ${PWD}/skincare_script_files/channel_scripts/oyur/utils.sh

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/orderer.skincare.com/tlsca/tlsca.orderer.skincare.com-cert.pem


# Set environment variables for the peers of oyur org
setGlobals() {
  local SET_PEER=""
  if [ -z "$OVERRIDE_PEER" ]; then
    SET_PEER=$1
  else
    SET_PEER="${OVERRIDE_PEER}"
  fi
  infoln "Setting env variables for peer${SET_PEER} of oyur org"
  if [ $SET_PEER -eq 0 ]; then
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="OyurMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/oyur.skincare.com/tlsca/tlsca.oyur.skincare.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/Admin@oyur.skincare.com/msp
    export CORE_PEER_ADDRESS=peer0-oyur:9055
  elif [ $SET_PEER -eq 1 ]; then
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="OyurMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/oyur.skincare.com/tlsca/tlsca.oyur.skincare.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/oyur.skincare.com/users/Admin@oyur.skincare.com/msp
    export CORE_PEER_ADDRESS=peer1-oyur:9065
  else
    errorln "The peer doesnt exist"
  fi

}


# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
