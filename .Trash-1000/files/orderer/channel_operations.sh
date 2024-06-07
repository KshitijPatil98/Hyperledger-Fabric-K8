set -x

#This script will run in orderer machine

ORDERERNAME=$1
. ${PWD}/skincare_channel_operations/orderer/operation_info.sh ${ORDERERNAME}
. ${PWD}/${PROJECT_NAME}_template_files/orderer_template_files/channel_template_files/utils.sh

infoln "Let us join orderer nodes to the channel"
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORDERERNAME_ALL_LOWER}/${CHANNELNAME}/osn_orderer_join.sh 
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORDERERNAME_ALL_LOWER}/${CHANNELNAME}/osn_orderer_join.sh
successln "Orderer nodes have joined the channel"

{ set +x; } 2>/dev/null
