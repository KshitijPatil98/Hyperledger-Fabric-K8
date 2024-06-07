set -x

export ORDERERNAME=$1
export ORDERERNAME_ALL_LOWER="${ORDERERNAME,,}"
export ORDERERNAME_ALL_UPPER="${ORDERERNAME^^}"
export ORDERERNAME_FIRST_UPPER="${ORDERERNAME_ALL_LOWER^}"


export PROJECT_NAME="skincare"
export CHANNELNAME="oyurchannel"

sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORDERERNAME_ALL_LOWER}/${CHANNELNAME}/osn_orderer_join.sh 
bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${ORDERERNAME_ALL_LOWER}/${CHANNELNAME}/osn_orderer_join.sh


{ set +x; } 2>/dev/null
