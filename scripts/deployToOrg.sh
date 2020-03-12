#!/bin/bash

read -p 'Username: ' USERNAME
# convert Source to metadata
sfdx force:source:convert --rootdir force-app --outputdir deployment
# zip converted source
zip -r -X deployment.zip deployment
# delete converted file
rm -r deployment
# deploy changes to specified username
sfdx force:mdapi:deploy --zipfile deployment.zip --targetusername $USERNAME -w 10
# delete zip file
rm deployment.zip

echo 'complete'