#!/bin/bash

read -p 'Alias: ' ALIAS
read -p 'Duration: ' DURATION

PACKAGE_VERSION_ID=""

if [ "$#" -eq 1 ]; then
  DURATION=$1
fi

#Create scratch org with a custom alias
sfdx force:org:create -a $ALIAS -s -f config/project-scratch-def.json -d $DURATION

#Set default org 
sfdx force:config:set defaultusername=$ALIAS

#Push source to scracth org
sfdx force:source:push

#Open scracth org
sfdx force:org:open -p /lightning/page/home

#Feedback to user
echo "Org is set up"