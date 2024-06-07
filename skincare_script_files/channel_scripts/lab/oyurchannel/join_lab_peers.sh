#!/bin/bash

: ${CHANNEL_NAME:="oyurchannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
: ${CONTAINER_CLI:="docker"}

BLOCKFILE="${PWD}/skincare_channel_files/channel_artifacts/oyurchannel/${CHANNEL_NAME}.block"
export FABRIC_CFG_PATH=${PWD}/config/

# imports  
. ${PWD}/skincare_script_files/channel_scripts/lab/envVar.sh
. ${PWD}/skincare_script_files/channel_scripts/lab/utils.sh



# joinChannel ORG
joinChannel() {
  PEER=$1
  setGlobals $PEER
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "After $MAX_RETRY attempts, peer${ORG} of lab has failed to join channel '$CHANNEL_NAME' "
}



## Join all the peers to the channel
infoln "Joining peer0 of lab to the channel..."
joinChannel 0
infoln "Joining peer1 of lab to the channel..."
joinChannel 1

successln "All the peers have successfully joined the channel"


