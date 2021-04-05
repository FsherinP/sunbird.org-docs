#!/bin/bash
# wget https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64
# chmod +x yq_linux_amd64
# mv yq_linux_amd64 yq

echo -e "Generating the proxy validator yaml by merging all the API definition into 1"
completeFile=$(yaml-merge $(find apis -name *.yaml | tr "\n" " "))
echo "$completeFile" > main.yml
tmpFile=""
patterns=("servers" "paths.*.*.description" "paths.*.*.operationId" "paths.*.*.tags" "paths.*.*.responses.*.content.*.example" "paths.*.*.responses.*.content.*.examples" "tags" "security" "externalDocs" "paths.*.*.requestBody.content.*.examples" "paths.*.*.requestBody.content.*.example")


# Remove the unwanted fields from the proxyvalidator
# Now clean the intermediate file
echo -e "Cleaning the files to have minimal and required fileds"
for pattern in ${patterns[@]};
do
  echo "Removing $pattern from the yaml file"
  tmpFile=$(echo "$completeFile" | ./yq delete - $pattern)
  completeFile=$tmpFile
done

echo "$completeFile" > spec_for.yml
echo -e "Find the final validated file \"spec.yml\""
mv intermediate-12.yml spec.yml
rm -rf intermediate-*.yml
