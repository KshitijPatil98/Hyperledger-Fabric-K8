set -x


#VVIPPPPPP

#The LifecycleEndorsement policy is set to only owner meaning only owner need to approve the chaincode and with his approval and his signature the chaincode definition is committed to the channel(REMEMBER DURING COMMIT WE AGAIN NEED SIGNATURE FROM ENOUGH ORGS AS PER THE LIFECYCLE ENDORSEMENT POLICY. FOR US WE HAVE THE LIFECYCLE ENDORSEMENT SET TO OWNER SO ONLY HE NEED TO SIGN DURING COMMIT. For any  other org to use the functions of chaincode they first need to approve the chaincode. Without approval they cannot use the chaincode functions even if its committed 
  
#The sequence of operations
#1) Ownner packages, installs approves, commits and queries the chaincode. It can do all in one flow without approvals because we have set lifecycle endorsement to owner only
#2) The first org(it will be the only org initially apart from owner) packages, installs and approves and queries the committed the chaincode.
#THIS FILE BASICALLY WILL BE CALLED BY ONBOARDED ORGS. JUST MAKE SURE TO CALL THIS FILE WITH PROPER ARGUMENTS AND SEQUENCE


#When we neeed to upgrade the chaincode we will use the same file to upgrade chaincode. 
#WHY DO WE DO THIS? THIS IS BECAUSE WHEN THE OWNER ONBOARDS THE FIRST ORG HE CREATES A CHANNEL BETWEEN THEM AND DEPLOYS A CHAINCODE ON THAT CHANNEL WITH A COLLECTION CONFIG FILE THAT HAS JUST THE COLLECTION JUST BETWEEN ONWER AND THE NEW ORG. NOW WHEN HE ONBOARDS SECOND ORG WE OVERWRITE THE SAME COLLECTION FILE. NOW TO UPGRADE THAT COLLECTION FILE ON OUR CHAINCODE WE NEED TO PERFORM ENTIRE LIFECYCLE OF THE CHAINCODE WITH VERSION AS 2 AND SEQUENCE AS 2. 


#SO THIS IS WHAT WE DO FOR UPDATING THE COLLECTION CONFIG FOR THIS NEW ORG
#1)PACKAGE,INSTALL,APPROVE AND COMMIT VERSION=2 AND SEQUENCE=2 AND WITH UPDATED COLLECTION CONFIG AS OWNER. YOU CAN CALL owner_cc_op.sh with version and sequence as 2.
#2)PACKAGE,INSTALL AND APPROVE VERSION=2 AND SEQUENCE=2 ON THE ORGS ALREADY PRESENT ON CHANNEL AS WELL AS ORG WHICH IS GETTING ONBOARDED.YOU CAN CALL org_cc_op.sh WITH PROPER ORGNAME,SEQUENCE AND VERSION.

#We will accept ownername, channelname, chaincodename ,version and sequence from front end(terminal). We have harcoded the chaincode path and collection config path because it is incovenient to accept it from the frontend 

OWNERNAME=$1
OWNERNAME_ALL_LOWER="${OWNERNAME,,}"

CHANNELNAME="oyurchannel"

CC_NAME="incalus-cc"
CC_SRC_PATH="${PWD}/skincare_cc_files/${CC_NAME}.tgz"

CC_VERSION="$2"
CC_SEQUENCE=$3

#CC_COLL_CONFIG WILL ALWAYS BE HARDCODED SO MAKE SURE TO ADJUST THE PATH ACCORDINGLY. We will use below only during private data collection. If not using pdc then do NA.
#CC_COLL_CONFIG="${PWD}/scm_privatedata_files/scmchannel/collections_config.json"
CC_COLL_CONFIG="${PWD}/skincare_privatedata_files/${CHANNELNAME}/collections_config.json"

#The reason we dont send the channel name as an argument to our package_install_approve_commit_query.sh script is because we have different scripts for different channel. So based on the channel name the script for that channel is automatically selected and that script will have the channel name hardcoded. So that is the reason we dont send it as an argument to the script. It already has it.


sudo chmod +x ${PWD}/skincare_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/install_approve_commit_query.sh
bash ${PWD}/skincare_script_files/channel_scripts/${OWNERNAME_ALL_LOWER}/${CHANNELNAME}/install_approve_commit_query.sh $CC_NAME $CC_SRC_PATH $CC_VERSION $CC_SEQUENCE $CC_COLL_CONFIG





{ set +x; } 2>/dev/null
