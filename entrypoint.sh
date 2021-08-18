
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
env | grep ARGO

RANDOM_STRING=`head -3 /dev/urandom | tr -cd '[:lower:]' | cut -c -4`
JOB_NAME="${5}-$RANDOM_STRING"

WORKFLOW_NAME=`argo submit -v -o json --from wftmpl/${1} -n ${2} -l workflows.argoproj.io/workflow-template=${1} --argo-base-href '' \
    -p ci-repository-url="git@github.com:${GITHUB_REPOSITORY}.git" -p ci-commit-sha=${GITHUB_SHA} -p run-destroy=${3} \
    -p addon-url="${4}" -p job-name=${JOB_NAME} -p splunk-version=${6} -p test-type=${7} -p test-args="${8}" -l="${9}" | jq -r .metadata.name`

echo "After argo submit $?"
echo 'WORKFLOW_NAME:' ${WORKFLOW_NAME}
echo "::set-output name=workflow-name::$(echo $WORKFLOW_NAME)"

argo logs --follow ${WORKFLOW_NAME} -n ${2}
