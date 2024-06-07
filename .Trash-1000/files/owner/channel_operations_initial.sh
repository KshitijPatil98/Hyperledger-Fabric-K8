set -x


#HERE CHANNEL NAME AND PROJECT NAME IS HARCODED IN THE INFORMATION FILE AS IT IS A ONE TIME ACTIVITY. ONLY OWNER NAME  IS DYNAMIC. IF YOU WANT TO CHANGE CHANNEL NAME AND PROJECT NAME GO IN THE INFO DIRECTORY AND CHANGE THE HARDCODED VALUES.
 
OWNERNAME=$1
. ${PWD}/skincare_channel_operations/owner/operation_info_initial.sh ${OWNERNAME} 
. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh


infoln "Let us now join peers of ${OWNERNAME_ALL_LOWER} organization to the channel named ${CHANNELNAME}.We will also set an anchor peer for the ${OWNERNAME_ALL_LOWER} organization"

#We set the anchor peer in the join_orgname_peers.sh file itself. So its necessary to give permission to setAnchorPeer file as well.
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/join_${OWNERNAME_ALL_LOWER}_peers.sh 
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/setAnchorPeer.sh
 
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/join_${OWNERNAME_ALL_LOWER}_peers.sh

successln "All the nodes of ${ORDERERNAME_ALL_LOWER} have successfully joined the  ${CHANNELNAME}"

