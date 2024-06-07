#!/bin/bash
set -x

#Never give a gap between equal sign. Both LHS and RHS should be closely sticked to equal signs.

#Manufacturer1 is ORG 
export ORGNAME=$1
export ORGNAME_ALL_LOWER="${ORGNAME,,}"
export ORGNAME_ALL_UPPER="${ORGNAME^^}"
export ORGNAME_FIRST_UPPER="${ORGNAME_ALL_LOWER^}"

export PROJECT_NAME="skincare"
export CHANNELNAME="oyurchannel"

#Which peer do you want to set as anchor peer. 0 or 1 
export PEER=0

. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh


   #We set the anchor peer in the join_orgname_peers.sh file itself. So its necessary to give permission to setAnchorPeer file as well.
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/join_${ORGNAME_ALL_LOWER}_peers.sh 
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh
#bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/join_${ORGNAME_ALL_LOWER}_peers.sh  
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh ${PEER} ${CHANNELNAME}


