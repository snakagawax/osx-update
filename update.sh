#!bin/bash

DIR=/usr/local/bin
LOG_DIRECTORY=${HOME}/logs
SUMMARY_DIRECTORY=${LOG_DIRECTORY}/update
TMP_DIRECTORY=${HOME}/tmp
LOG=${SUMMARY_DIRECTORY}/`date "+%Y%m%d"`.log
FAILED=0
UPDATE=0

if [ ! -d ${LOG_DIRECTORY} ]; then
  mkdir -p ${LOG_DIRECTORY}
fi

if [ ! -d ${SUMMARY_DIRECTORY} ]; then
  mkdir -p ${SUMMARY_DIRECTORY}
fi

if [ ! -d ${TMP_DIRECTORY} ]; then
  mkdir -p ${TMP_DIRECTORY}
fi

if [ -e ${LOG} ]; then
  rm ${LOG}
fi

which terminal-notifier > /dev/null
if [ $? -eq 1 ]; then
  brew install terminal-notifier
  if [ $? -eq 1 ]; then
    echo 'terminal-notifier could not be installed'
    exit
  fi
fi

source ${DIR}/brew_update.sh
echo '' >> ${LOG} 2>&1

source ${DIR}/brew_cask_update.sh
echo '' >> ${LOG} 2>&1

source ${DIR}/pip_update.sh

if [ ${FAILED} -gt 0 ] ; then
  terminal-notifier -title 'Update' -message "${FAILED} update failed" -execute "qlmanage -p ${LOG}"
  exit 0
fi

if [ ${UPDATE} -eq 0 ] ; then
  terminal-notifier -title 'Update' -message "No update" -execute ""
  rm ${LOG}
else
  terminal-notifier -title 'Update' -message "Update complete!" -execute "qlmanage -p ${LOG}"
fi
