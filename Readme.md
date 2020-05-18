1. clone repo: https://github.com/JeffB-14/devops-demo-store

2. open terminal

3. navigate to repo folder
cd ~/Documents/repos/demo/devops_demo

4. export myBucket=demo-store-api

5. aws s3 mb s3://$myBucket

6. update store-api-buildspec.yml
sed -i'.original' -e 's/\<REPLACE_ME_WITH_UNIQUE_BUCKET_NAME\>/'"${myBucket}"'/g' api/store-api-buildspec.yml

7. aws s3 cp tests/StoreAPI.postman_collection.json \
s3://$myBucket/postman-env-files/StoreAPI.postman_collection.json

8. aws s3 cp tests/StoreAPIEnvironment.postman_environment.json \
s3://$myBucket/postman-env-files/StoreAPIEnvironment.postman_environment.json


9. create the stack
aws cloudformation create-stack --stack-name store-api-pipeline \
--template-body file://./store-api-pipeline.yaml \
--parameters \
ParameterKey=BucketRoot,ParameterValue=$myBucket \
ParameterKey=GitHubBranch,ParameterValue=master \
ParameterKey=GitHubRepositoryName,ParameterValue=devops-demo-store \
ParameterKey=GitHubToken,ParameterValue=$GitHubToken \
ParameterKey=GitHubUser,ParameterValue=JeffB-14 \
--capabilities CAPABILITY_NAMED_IAM



20. empty the S3 artifact bucket including all versions
21. delete the stack
aws cloudformation delete-stack --stack-name store-api-pipeline