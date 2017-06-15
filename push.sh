#!/bin/sh

if [ $# -ne 1 ] ; then
  echo "usage: `basename $0` <Project ID>"
  echo "  Project ID: CI/CD target project ID. Same as repository name."
  exit
fi

PROJECT_ID=$1

DEV_PROJECT=${PROJECT_ID}-dev
STAGE_PROJECT=${PROJECT_ID}-stage
CICD_PROJECT=${PROJECT_ID}-cicd

GOGS_ROUTE=`oc get route -n ${CICD_PROJECT} | grep gogs | awk '{print $2}'`

# push source to gogs 
cd ${PROJECT_ID}
git init
git remote rm origin
git remote add origin http://$GOGS_ROUTE/gogs/${PROJECT_ID}.git
git add -A
git commit -m 'Initial commit.'
git push -u origin master
