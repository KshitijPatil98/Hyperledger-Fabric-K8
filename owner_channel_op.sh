#!/bin/bash
set -x

#Never give a gap between equal sign. Both LHS and RHS should be closely sticked to equal signs.

#Manufacturer1 is owner 
export OWNERNAME=$2
export OWNERNAME_ALL_LOWER="${OWNERNAME,,}"
export OWNERNAME_ALL_UPPER="${OWNERNAME^^}"
export OWNERNAME_FIRST_UPPER="${OWNERNAME_ALL_LOWER^}"

export PROJECT_NAME="skincare"
export CHANNELNAME="oyurchannel"

#Which peer do you want to set as anchor peer. 0 or 1 
export PEER=0

. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh


if [ "$1" = "create" ]; then
   sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/create_genesis_block.sh
   bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/create_genesis_block.sh
elif [ "$1" = "initial" ]; then
   #We set the anchor peer in the join_orgname_peers.sh file itself. So its necessary to give permission to setAnchorPeer file as well.
   sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/join_${OWNERNAME_ALL_LOWER}_peers.sh 
   sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh
   bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/join_${OWNERNAME_ALL_LOWER}_peers.sh  
   bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh ${PEER} ${CHANNELNAME}
elif [ "$1" = "later" ]; then
   echo "In the later section"      
else
    echo "Invalid argument. Please provide 'create' or 'initial' or 'later' and try again."
fi


