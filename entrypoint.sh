
#!/usr/bin/env bash
#   ########################################################################
#   Copyright 2021 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 
set -o xtrace

if [[ "${GITHUB_EVENT_NAME}" != "pull_request" ]]
then
    BRANCH_NAME=${GITHUB_REF_NAME}
else
    BRANCH_NAME=${GITHUB_HEAD_REF}
fi

WORKFLOW_NAME=`argo submit -v -o json --from wftmpl/${1} -n ${2} -l workflows.argoproj.io/workflow-template=${1} --argo-base-href '' \
    -p ci-repository-url="https://github.com/${GITHUB_REPOSITORY}.git" \
    -p ci-commit-sha=${BRANCH_NAME} -p delay-destroy=${3} \
    -p addon-url="${4}" \
    -p job-name=${5} \
    -p splunk-version=${6} \
    -p test-type=${7} \
    -p k8s-manifests-branch="${8}" \
    -p pytest-args="${9}" \
    -p addon-name=${11} \
    -p vendor-version=${12}\
    -p sc4s-version=${13} \
    -p install-java=${14} \
    -p sc4s-docker-registry=${15} \
    -p os-name=${16} \
    -p os-version=${17} \
    -l="${10},test-type=${7},splunk-version=${6}" | jq -r .metadata.name`

echo "After argo submit $?"
echo 'WORKFLOW_NAME:' ${WORKFLOW_NAME}
echo "workflow-name=$(echo $WORKFLOW_NAME)" >> $GITHUB_OUTPUT

argo logs --follow ${WORKFLOW_NAME} -n ${2}
