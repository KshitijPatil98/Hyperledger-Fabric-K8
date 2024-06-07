#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/utils.sh

export ORDERER_CA=${PWD}/organizations/${ORDERERNAME_ALL_LOWER}Organizations/${ORDERERNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca/tlsca.${ORDERERNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem


# Set environment variables for the peers of ${ORGNAME_ALL_LOWER} org
setGlobals() {
  local SET_PEER=""
  if [ -z "$OVERRIDE_PEER" ]; then
    SET_PEER=$1
  else
    SET_PEER="${OVERRIDE_PEER}"
  fi
  infoln "Setting env variables for peer${SET_PEER} of ${ORGNAME_ALL_LOWER} org"
  if [ $SET_PEER -eq 0 ]; then
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="${ORGNAME_FIRST_UPPER}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca/tlsca.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp
    export CORE_PEER_ADDRESS=localhost:${PEER0LIS}
  elif [ $SET_PEER -eq 1 ]; then
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID="${ORGNAME_FIRST_UPPER}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca/tlsca.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/msp
    export CORE_PEER_ADDRESS=localhost:${PEER1LIS}
  else
    errorln "The peer doesnt exist"
  fi

}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local SET_PEER=""
  if [ -z "$OVERRIDE_PEER" ]; then
    SET_PEER=$1
  else
    SET_PEER="${OVERRIDE_PEER}"
  fi
  if [ $SET_PEER -eq 0 ]; then
    export CORE_PEER_ADDRESS=peer0.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com:${PEER0LIS}
  elif [ $SET_PEER -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer1.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com:${PEER1LIS}
  else
    errorln "No such peer present"
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
