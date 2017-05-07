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

# delete project
oc delete project ${DEV_PROJECT}
oc delete project ${STAGE_PROJECT}
oc delete project ${CICD_PROJECT}

