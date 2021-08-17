RANDOM_STRING=`head -3 /dev/urandom | tr -cd '[:lower:]' | cut -c -4`
echo 'RANDOM_STRING: ${RANDOM_STRING}'
JOB_NAME="$5-$RANDOM_STRING"

WORKFLOW_NAME=`argo submit -o json --from wftmpl/$1 -n $2 -l workflows.argoproj.io/workflow-template=$1 \
    -p ci-repository-url="git@github.com:${GITHUB_REPOSITORY}.git" -p ci-commit-sha=${GITHUB_SHA} -p run-destroy=$3 \
    -p addon-url="$4" -p job-name=${JOB_NAME} -p splunk-version=$6 -p test-type=$7 -p test-args="$8" $9 | jq -r .metadata.name`
echo "After argo submit $?"
echo 'WORKFLOW_NAME:' ${WORKFLOW_NAME}
echo "::set-output name=workflow-name::$(echo $WORKFLOW_NAME)"

argo logs --follow ${WORKFLOW_NAME} -n $2