#!/bin/bash

# Configuration
TOKEN=''        # Gitlab Personal Access Token 
PROJECT_PATH='' # Project path
PIPELINE=''     # Pipeline ID
API_URL="https://gitlab.com/api/v4/projects"

jobs=$(curl --header "PRIVATE-TOKEN:${TOKEN}" ${API_URL}/${PROJECT_PATH}/pipelines/${PIPELINE}/jobs | jq --raw-output '.[] | "\(.stage),\(.name),\(.id),\(.status),\(.web_url)"')
mkdir -p output
for job in ${jobs}; do
    job_id=$(echo ${job} | cut -d, -f3)
    job_name=$(echo ${job} | cut -d, -f2)
    curl --header "PRIVATE-TOKEN:${TOKEN}" ${API_URL}/${PROJECT_PATH}/jobs/${job_id}/trace >> output/${job_name}.${job_id}
done
