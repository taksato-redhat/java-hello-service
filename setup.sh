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

# create project
oc new-project ${DEV_PROJECT}
oc new-project ${STAGE_PROJECT}
oc new-project ${CICD_PROJECT}

# set permission
oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:default -n ${DEV_PROJECT}
oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:default -n ${STAGE_PROJECT}

# deploy CI/CD components
oc process -f ${PROJECT_ID}-template.yaml -v DEV_PROJECT=${DEV_PROJECT} -v STAGE_PROJECT=${STAGE_PROJECT} | oc create -f - -n ${CICD_PROJECT}
