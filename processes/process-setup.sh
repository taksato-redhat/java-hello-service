#!/bin/sh

# プロジェクト作成
oc new-project java-hello-service-dev
oc new-project java-hello-service-stage
oc new-project java-hello-service-prod
oc new-project java-hello-service-cicd

# 権限設定
oc policy add-role-to-user edit system:serviceaccount:java-hello-service-cicd:default -n java-hello-service-dev
oc policy add-role-to-user edit system:serviceaccount:java-hello-service-cicd:default -n java-hello-service-stage
oc policy add-role-to-user edit system:serviceaccount:java-hello-service-cicd:default -n java-hello-service-prod

# Gogs コンテナテンプレートの適用
oc process -f java-hello-service-template-gogs.yaml | oc create -f - -n java-hello-service-cicd

# Jenkins コンテナテンプレートの適用
oc process -f java-hello-service-template-jenkins.yaml | oc create -f - -n java-hello-service-cicd
