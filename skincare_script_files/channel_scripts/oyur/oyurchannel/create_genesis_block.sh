set -x

export FABRIC_CFG_PATH=${PWD}/skincare_channel_files/configtx_files/oyurchannel


# Check if the directory doesn't exist, then create it. This is done because during stopping the owner we also delete the folder which stores the block file. So then again during stating we will need a folder. So for that we will create the folder here 

if [ ! -d "${PWD}/skincare_channel_files/channel_artifacts/oyurchannel" ]; then
  mkdir -p "${PWD}/skincare_channel_files/channel_artifacts/oyurchannel"
fi


configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ${PWD}/skincare_channel_files/channel_artifacts/oyurchannel/oyurchannel.block -channelID oyurchannel

{ set +x; } 2>/dev/null
