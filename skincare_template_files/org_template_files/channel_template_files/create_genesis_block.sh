set -x

export FABRIC_CFG_PATH=${PWD}/${PROJECT_NAME}_channel_files/configtx_files/${CHANNELNAME}


# Check if the directory doesn't exist, then create it. This is done because during stopping the owner we also delete the folder which stores the block file. So then again during stating we will need a folder. So for that we will create the folder here 

if [ ! -d "${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}" ]; then
  mkdir -p "${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}"
fi


configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}/${CHANNELNAME}.block -channelID ${CHANNELNAME}

{ set +x; } 2>/dev/null
