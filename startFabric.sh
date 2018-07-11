#!/bin/bash

export FABRIC_CFG_PATH=${PWD}

function generateCerts(){
  which cryptogen
  echo
  echo "##########################################################"
  echo "##### Generate certificates using cryptogen tool #########"
  echo "##########################################################"
  set -x
  cryptogen generate --config=./crypto-config.yaml --output ./crypto-config
  set +x
  echo
}

function generateChannelArtifacts() {
  which configtxgen
  echo "##########################################################"
  echo "#########  Generating Orderer Genesis block ##############"
  echo "##########################################################"
  # Note: For some unknown reason (at least for now) the block file can't be
  # named orderer.genesis.block or the orderer will fail to launch!
  set -x
  mkdir channel-artifacts
  configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo
  echo "#################################################################"
  echo "### Generating channel configuration transaction 'channel.tx' ###"
  echo "#################################################################"
  set -x
  configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi
  
  echo
  echo "#################################################################"
  echo "#######    Generating anchor peer update for Org1MSP   ##########"
  echo "#################################################################"
  set -x
  configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for Org1MSP..."
    exit 1
  fi

  # echo
  # echo "#################################################################"
  # echo "#######    Generating anchor peer update for Org2MSP   ##########"
  # echo "#################################################################"
  # set -x
  # configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
  # res=$?
  # set +x
  # if [ $res -ne 0 ]; then
    # echo "Failed to generate anchor peer update for Org2MSP..."
    # exit 1
  # fi
  # echo
}

CHANNEL_NAME="mychannel"
#step 1 : 1 peers, 1 orderer
generateCerts
#step 2
generateChannelArtifacts
