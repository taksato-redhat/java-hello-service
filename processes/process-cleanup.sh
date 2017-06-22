#!/bin/sh

# プロジェクト削除
oc delete project java-hello-service-dev
oc delete project java-hello-service-stage
oc delete project java-hello-service-prod
oc delete project java-hello-service-cicd
