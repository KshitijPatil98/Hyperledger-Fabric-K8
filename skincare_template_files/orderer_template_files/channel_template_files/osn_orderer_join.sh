export ${ORGNAME_ALL_UPPER}_CA=${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tlsca/tlsca.${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com-cert.pem
export ${ORGNAME_ALL_UPPER}_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.crt
export ${ORGNAME_ALL_UPPER}_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/${ORGNAME_ALL_LOWER}Organizations/${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/users/Admin@${ORGNAME_ALL_LOWER}.${PROJECT_NAME}.com/tls/server.key

#Here remember this script runs from local terminal. So it wont know ${ORGNAME_ALL_LOWER}0.${PROJECT_NAME}.com by its name. If you want you can add an entry in /etc/hosts file of my computer. Instead i will use localhost

osnadmin channel join --channelID ${CHANNELNAME} --config-block ${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}/${CHANNELNAME}.block -o localhost:${ORDERER0_ADMIN} --ca-file "$${ORGNAME_ALL_UPPER}_CA" --client-cert "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_SIGN_CERT" --client-key "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_PRIVATE_KEY"

osnadmin channel join --channelID ${CHANNELNAME} --config-block ${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}/${CHANNELNAME}.block -o localhost:${ORDERER1_ADMIN} --ca-file "$${ORGNAME_ALL_UPPER}_CA" --client-cert "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_SIGN_CERT" --client-key "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_PRIVATE_KEY"

osnadmin channel join --channelID ${CHANNELNAME} --config-block ${PWD}/${PROJECT_NAME}_channel_files/channel_artifacts/${CHANNELNAME}/${CHANNELNAME}.block -o localhost:${ORDERER2_ADMIN} --ca-file "$${ORGNAME_ALL_UPPER}_CA" --client-cert "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_SIGN_CERT" --client-key "$${ORGNAME_ALL_UPPER}_ADMIN_TLS_PRIVATE_KEY"
