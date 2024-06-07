set -x

OWNERNAME=$1
. ${PWD}/skincare_channel_operations/owner/operation_info_initial.sh ${OWNERNAME} 
. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh


infoln "Let us first create a genesis block for the channel ${CHANNELNAME}"

sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/create_genesis_block.sh
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/create_genesis_block.sh

successln "The genesis block is successfully created. You can go ahead and join the ordering nodes to channel followed by peers"

{ set +x; } 2>/dev/null
