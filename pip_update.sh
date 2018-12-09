#!bin/bash

PIP_DIRECTORY=${LOG_DIRECTORY}/pip
PIP_LOG=${PIP_DIRECTORY}/`date "+%Y%m%d"`.log
LIST_BEFORE=${TMP_DIRECTORY}/`date "+%Y%m%d"`_bf.txt
LIST_AFTER=${TMP_DIRECTORY}/`date "+%Y%m%d"`_af.txt
LIST_SUMMARY=${TMP_DIRECTORY}/`date "+%Y%m%d"`_sum.txt

if [ ! -d ${PIP_DIRECTORY} ]; then
  mkdir -p ${PIP_DIRECTORY}
fi

if [ -e ${PIP_LOG} ]; then
  rm ${PIP_LOG}
fi

echo '## pip update' 2>&1 | tee -a ${PIP_LOG} ${LOG}
which pip-review > /dev/null
if [ $? -eq 1 ]; then
  pip3 install pip-review
  if [ $? -eq 1 ]; then
    echo 'pip-review could not be installed'
    return 2> /dev/null
    exit
  fi
fi
pip-review >> ${PIP_LOG} 2>&1
pip3 list > ${LIST_BEFORE}

echo '' >> ${PIP_LOG} 2>&1
echo '## pip-review --auto' >> ${PIP_LOG} 2>&1
pip-review --auto >> ${PIP_LOG} 2>&1
if [ $? = 0 ]; then
  pip3 list > ${LIST_AFTER}
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
