#!bin/bash

DIR=${HOME}/.ghq/github.com/snakagawax/osx-update
BIN=/usr/local/bin
LAUNCHAGENTS=${HOME}/Library/LaunchAgents

ln -fs ${DIR}/update.sh ${BIN}/
ln -fs ${DIR}/brew_update.sh ${BIN}/
ln -fs ${DIR}/brew_cask_update.sh ${BIN}/
ln -fs ${DIR}/pip_update.sh ${BIN}/
ln -fs ${DIR}/update.plist ${HOME}/Library/LaunchAgents/

launchctl load ${HOME}/Library/LaunchAgents/update.plist
