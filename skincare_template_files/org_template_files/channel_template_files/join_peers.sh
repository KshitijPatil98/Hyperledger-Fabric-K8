#!/bin/bash

: ${CHANNEL_NAME:="${CHANNELNAME}"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
: ${CONTAINER_CLI:="docker"}

BLOCKFILE="${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}/${CHANNEL_NAME}.block"
export FABRIC_CFG_PATH=${PWD}/../config/

# imports  
. ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/envVar.sh
. ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/utils.sh



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
	verifyResult $res "After $MAX_RETRY attempts, peer${ORG} of ${ORGNAME_ALL_LOWER} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
  PEER=$1
  docker exec cli_${ORGNAME_ALL_LOWER} ./scripts/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh $PEER $CHANNEL_NAME
}


## Join all the peers to the channel
infoln "Joining peer0 of ${ORGNAME_ALL_LOWER} to the channel..."
joinChannel 0
infoln "Joining peer1 of ${ORGNAME_ALL_LOWER} to the channel..."
joinChannel 1


#Here we will use orderer0 of orderer org to send a anchor peer update. For supplier we will use orderer1
## Set the anchor peers for each org in the channel
infoln "Setting peer0 as anchor peer for ${ORGNAME_ALL_LOWER}..."
setAnchorPeer 0
infoln "Anchor peer set for ${ORGNAME_ALL_LOWER}..."

#successln "Channel '$CHANNEL_NAME' joined by peer0 and peer1"
