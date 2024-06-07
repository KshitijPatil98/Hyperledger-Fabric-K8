#!/bin/bash


:'Here remember we are using some setting of the fabric 2.3.2 version. In latest version compose files there is no core vm endpoint and a volume mapping present in compose files of peers. 
So during peer chaincode install it was throwing some errors related to docker unix. So i added the core vm endpoint and some one other env variable and one volume mapping and it solved that
error. One solution is this and other solution is to use latest peer images. Maybe i am having old images and that is the reason it is throwing such errors.  


- CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
- CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=fabric_test (this should be same as the name of your docker network)
- /var/run/docker.sock:/host/var/run/docker.sock

Adding these 3 variables solved the issues. Also latest image version doesnt requirwe 
'

#Here we are not setting ORGCA because only the owner is committing the chaincode definition. Other orgs are not doing anything and we need that CA cert during this time 
source ${PWD}/skincare_script_files/channel_scripts/lab/utils.sh


: ${CHANNEL_NAME:="oyurchannel"}
: ${CC_SRC_LANGUAGE:="javascript"}
#Below 5 values will be sent as env variables while calling this file
  CC_NAME=${1}
  CC_SRC_PATH=${2}
  CC_VERSION=${3}
  CC_SEQUENCE=${4}
  CC_COLL_CONFIG=${5}
: ${CC_END_POLICY:="NA"}
: ${CC_COLL_CONFIG:="NA"}
: ${CC_INIT_FCN:="NA"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
: ${DOCKER_SOCK:="unix:///var/run/docker.sock"}


println "executing with the following"
println "- CHANNEL_NAME: ${C_GREEN}${CHANNEL_NAME}${C_RESET}"
println "- CC_NAME: ${C_GREEN}${CC_NAME}${C_RESET}"
println "- CC_SRC_PATH: ${C_GREEN}${CC_SRC_PATH}${C_RESET}"
println "- CC_SRC_LANGUAGE: ${C_GREEN}${CC_SRC_LANGUAGE}${C_RESET}"
println "- CC_VERSION: ${C_GREEN}${CC_VERSION}${C_RESET}"
println "- CC_SEQUENCE: ${C_GREEN}${CC_SEQUENCE}${C_RESET}"
println "- CC_END_POLICY: ${C_GREEN}${CC_END_POLICY}${C_RESET}"
println "- CC_COLL_CONFIG: ${C_GREEN}${CC_COLL_CONFIG}${C_RESET}"
println "- CC_INIT_FCN: ${C_GREEN}${CC_INIT_FCN}${C_RESET}"
println "- DELAY: ${C_GREEN}${DELAY}${C_RESET}"
println "- MAX_RETRY: ${C_GREEN}${MAX_RETRY}${C_RESET}"
println "- VERBOSE: ${C_GREEN}${VERBOSE}${C_RESET}"


#ALWAYS USE EXPORT HERE ELSE IT WILL THROW AN ERROR
#AS we are runnning inside cli so we wont need it. When running on local machine always do the below step
#export FABRIC_CFG_PATH=$PWD/../config/

#User has not provided a name
if [ -z "$CC_NAME" ] || [ "$CC_NAME" = "NA" ]; then
  fatalln "No chaincode name was provided. Valid call example: ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go"

# User has not provided a path
elif [ -z "$CC_SRC_PATH" ] || [ "$CC_SRC_PATH" = "NA" ]; then
  fatalln "No chaincode path was provided. Valid call example: ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go"

# User has not provided a language
elif [ -z "$CC_SRC_LANGUAGE" ] || [ "$CC_SRC_LANGUAGE" = "NA" ]; then
  fatalln "No chaincode language was provided. Valid call example: ./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go"

## Make sure that the path to the chaincode exists
elif [ ! -d "$CC_SRC_PATH" ] && [ ! -f "$CC_SRC_PATH" ]; then
  fatalln "Path to chaincode does not exist. Please provide different path."
fi

CC_SRC_LANGUAGE=$(echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:])

# do some language specific preparation to the chaincode before packaging
if [ "$CC_SRC_LANGUAGE" = "go" ]; then
  CC_RUNTIME_LANGUAGE=golang

  infoln "Vendoring Go dependencies at $CC_SRC_PATH"
  pushd $CC_SRC_PATH
  GO111MODULE=on go mod vendor
  popd
  successln "Finished vendoring Go dependencies"

elif [ "$CC_SRC_LANGUAGE" = "java" ]; then
  CC_RUNTIME_LANGUAGE=java

  rm -rf $CC_SRC_PATH/build/install/
  infoln "Compiling Java code..."
  pushd $CC_SRC_PATH
  ./gradlew installDist
  popd
  successln "Finished compiling Java code"
  CC_SRC_PATH=$CC_SRC_PATH/build/install/$CC_NAME

elif [ "$CC_SRC_LANGUAGE" = "javascript" ]; then
  CC_RUNTIME_LANGUAGE=node

elif [ "$CC_SRC_LANGUAGE" = "typescript" ]; then
  CC_RUNTIME_LANGUAGE=node

  infoln "Compiling TypeScript code into JavaScript..."
  pushd $CC_SRC_PATH
  npm install
  npm run build
  popd
  successln "Finished compiling TypeScript code into JavaScript"

else
  fatalln "The chaincode language ${CC_SRC_LANGUAGE} is not supported by this script. Supported chaincode languages are: go, java, javascript, and typescript"
  exit 1
fi

INIT_REQUIRED="--init-required"
# check if the init fcn should be called
if [ "$CC_INIT_FCN" = "NA" ]; then
  INIT_REQUIRED=""
fi

if [ "$CC_END_POLICY" = "NA" ]; then
  CC_END_POLICY=""
else
  CC_END_POLICY="--signature-policy $CC_END_POLICY"
fi

if [ "$CC_COLL_CONFIG" = "NA" ]; then
  CC_COLL_CONFIG=""
else
  CC_COLL_CONFIG="--collections-config $CC_COLL_CONFIG"
fi

# import utils
.  ${PWD}/skincare_script_files/channel_scripts/lab/envVar.sh
.  ${PWD}/skincare_script_files/channel_scripts/lab/oyurchannel/ccutils.sh

#Here i have added packageChaincode as well because query installed need a package id variable set and that is set by package chaincode function. If it is not set then an error is thrown. So i have added it and called it which stores the package id in the variable
calculatePackageId() {
  set -x
  PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ${CC_SRC_PATH})
  { set +x; } 2>/dev/null
  verifyResult $res "Chaincode packaging has failed"
  successln "Chaincode is packaged"
}

## package the chaincode
#During chaincode as a service we dont package the chaincode. We do create a tar.gz file during the bootstrap process. SO here we wont do anything. We directly find the package id.

infoln "Let us find the package id first."
calculatePackageId
## Install chaincode on peer0.org1 and peer0.org2
infoln "Installing chaincode on peer0 of lab..."
installChaincode 0

## query whether the chaincode is installed
infoln "Let us query the  chaincode on peer0 of lab..."
queryInstalled 0

## approve the definition for org1
infoln "Let us approve the definition for chaincode on peer0 of lab..."
approveForMyOrg 0

#COMMENTING THE CHECK COMMIT READINESS BECAUSE DONT REALLY NEED IT AS ONLY OWNER IS GOING TO APPROVE
## check whether the chaincode definition is ready to be committed
## expect org1 to have approved and org2 not to
#checkCommitReadiness 0 "\"LabMSP\": ${ORGSTATUS}" "\"${OTHERORGNAME_FIRST_UPPER}MSP\": ${OTHERORGSTATUS}"

infoln "Here we wont commit the chaincode as it is already done by owner. We will just query the committed chaincode"
queryCommitted 0



