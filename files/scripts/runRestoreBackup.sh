#!/usr/bin/env bash

wanted_date=$(echo $1 | tr ' ' '-' | tr ':' '-' | tr '.' '-')
repo_name=$2
restore_from_backup=$3
topology=$4

echo ${wanted_date}
echo $(date +'%d-%m-%Y-%H-%M')

echo ${restore_from_backup}
echo ${topology}

if [[ $(date +'%d-%m-%Y-%H-%M') == "${wanted_date}" && "${topology}" != "standalone" ]]
then
  if [[ -d ${restore_from_backup} ]]; then
    curl -o response.json -H 'content-type: application/json' -d "{\"type\":\"exec\",\"mbean\":\"ReplicationCluster:name=ClusterInfo\/${repo_name}\",\"operation\":\"restoreFromImage\",\"arguments\":[\"$(echo ${restore_from_backup} | rev | cut -d '/' -f1 | rev )\"]}" http://graphdb-master-1:7200/jolokia/
    if grep -q '"status":200' "response.json"; then
      echo successfully restored
    else
      cat response.json
    fi
  else
    echo no such backup
  fi
fi
