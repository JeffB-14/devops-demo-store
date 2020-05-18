#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name store-api-stack \
  --query "Stacks[0].Outputs[*].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  StoreAPIEnvironment.postman_environment.json > StoreAPIEnvironment.postman_environment.json.tmp \
  && cp StoreAPIEnvironment.postman_environment.json.tmp StoreAPIEnvironment.postman_environment.json \
  && rm StoreAPIEnvironment.postman_environment.json.tmp

echo "Updated StoreAPIEnvironment.postman_environment.json"

cat StoreAPIEnvironment.postman_environment.json