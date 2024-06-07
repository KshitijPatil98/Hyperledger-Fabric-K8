set -x

#IN THE INFORMATION FILE WE HAVE HARDCODED THE PROJECT NAME AND CHANNEL NAME BECAUSE THOSE ARE ONE TIME ACTIVITIES. IF YOU WANT TO CHANGE THOSE GO TO THE INFO DIRECTORY AND MAKE THE CHANGES. WE ARE SENDING ORGNAMES DYNAMICALLY. 
ORGNAME=$1
. ${PWD}/skincare_channel_operations/org/operation_info.sh ${ORGNAME}
. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh

infoln "Let us now join peers of ${ORGNAME_ALL_LOWER} organization to the channel named ${CHANNELNAME}.We will also set an anchor peer for the ${ORGNAME_ALL_LOWER} organization"

#We set the anchor peer in the join_orgname_peers.sh file itself. So its necessary to give permission to setAnchorPeer file as well.
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/join_${ORGNAME_ALL_LOWER}_peers.sh 
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh
 
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORGNAME_ALL_LOWER}/${CHANNELNAME}/join_${ORGNAME_ALL_LOWER}_peers.sh

successln "All the peers of ${ORGNAME_ALL_LOWER} have successfully joined the  ${CHANNELNAME}"

{ set +x; } 2>/dev/null
