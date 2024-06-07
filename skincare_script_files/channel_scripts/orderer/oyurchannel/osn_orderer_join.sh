export ORDERER_CA=${PWD}/organizations/ordererOrganizations/orderer.skincare.com/tlsca/tlsca.orderer.skincare.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/orderer.skincare.com/users/Admin@orderer.skincare.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/orderer.skincare.com/users/Admin@orderer.skincare.com/tls/server.key

#Here remember this script runs from local terminal. So it wont know orderer0.skincare.com by its name. If you want you can add an entry in /etc/hosts file of my computer. Instead i will use localhost

osnadmin channel join --channelID oyurchannel --config-block ${PWD}/skincare_channel_files/channel_artifacts/oyurchannel/oyurchannel.block -o orderer0:9046 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

osnadmin channel join --channelID oyurchannel --config-block ${PWD}/skincare_channel_files/channel_artifacts/oyurchannel/oyurchannel.block -o orderer1:9047 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"

osnadmin channel join --channelID oyurchannel --config-block ${PWD}/skincare_channel_files/channel_artifacts/oyurchannel/oyurchannel.block -o orderer2:9048 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
