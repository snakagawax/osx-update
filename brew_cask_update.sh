#!/bin/bash

BREW_DIRECTORY=${LOG_DIRECTORY}/brewcask
BREW_LOG=${BREW_DIRECTORY}/`date "+%Y%m%d"`.log
LIST_BEFORE=${TMP_DIRECTORY}/`date "+%Y%m%d"`_bf.txt
LIST_AFTER=${TMP_DIRECTORY}/`date "+%Y%m%d"`_af.txt
LIST_SUMMARY=${TMP_DIRECTORY}/`date "+%Y%m%d"`_sum.txt

if [ ! -d ${BREW_DIRECTORY} ]; then
  mkdir -p ${BREW_DIRECTORY}
fi

if [ -e ${BREW_LOG} ]; then
  rm ${BREW_LOG}
fi

echo '## brew cask update' 2>&1 | tee -a ${BREW_LOG} ${LOG}
brew cask list --versions > ${LIST_BEFORE}
brew cask outdated >> ${BREW_LOG} 2>&1
brew cask upgrade >> ${BREW_LOG} 2>&1
if [ $? = 0 ]; then
  brew cask list --versions > ${LIST_AFTER}
  diff --suppress-common-lines --side-by-side ${LIST_BEFORE} ${LIST_AFTER} | tr '\t' ' ' | sed 's/ *//g' | sed 's/|/ > /g' 2>&1 | tee -a ${LIST_SUMMARY} ${LOG}
  if [ ! -s ${LIST_SUMMARY} ]; then
    echo 'No update' >> ${LOG}
  else
    UPDATE=`expr 1 + ${UPDATE}`
  fi
else
  echo 'Failed' >> ${LOG}
  FAILED=`expr 1 + ${FAILED}`
fi
rm ${LIST_BEFORE} ${LIST_AFTER} ${LIST_SUMMARY}
