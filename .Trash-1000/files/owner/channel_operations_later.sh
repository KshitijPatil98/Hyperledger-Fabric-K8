set -x

#HERE AGAIN WE ARE GIVING OWNERNAME AND ORGNAME IN THE INFORMATION FILE DYNAMICALLY BUT CHANNEL NAME AND PROJECT NAME IS HARCODED. SO IF YOU WANT TO CHANGE THOSE GO TO THE INFORMATION FILE AND CHANGE THOSE VALUES 
OWNERNAME=$1
ORGNAME=$2
. ${PWD}/scm_channel_operations/owner/operation_info_later.sh ${OWNERNAME} ${ORGNAME}
. ${PWD}/${PROJECT_NAME}_template_files/org_template_files/channel_template_files/utils.sh

#Remeber the update_sign_channel_config.sh basically updates the channel configuration with new org info. All other orgs and also orderer will now have idea about this new org. We will see a new block seperately created like it got created during setAnchorPeer.sh. This new block will have this channel update. Now all org will have 4 blocks. Now we will join new org peers to the channel.Here remember joining peer just means storing genesis block on this peers. This genesis block will have info of orderer who they should connect to. They will then call orderer and sync up all the blocks and they will now have 4 blocks

infoln "Let us call the update_sign_channel_config.sh file. This file will add a new org to existing channel"

sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/${ORGNAME_ALL_LOWER}/update_sign_channel_config.sh
sudo chmod +x ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/${ORGNAME_ALL_LOWER}/configUpdate.sh

bash ${PWD}/${PROJECT_NAME}_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/${ORGNAME_ALL_LOWER}/update_sign_channel_config.sh

successln "All org ${ORGNAME_ALL_LOWER} information is successfully added to the channel ${CHANNELNAME}. Go ahead and join the peers and also set anchor peer"
