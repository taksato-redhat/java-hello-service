# OpenShift POC - CI/CD 環境ガイド - OpenShift Container Platform 3.4

このリポジトリは OpenShift による CI/CD の検証を行うためのものです。  

## 構成概要

![](images/env.png)

その他詳細は[ドキュメント](docs/OpenShiftPOC.pptx)を参照

## 構築手順
OpenShift にログインして CI/CD 環境構築用のシェルを実行します。

```
$ oc login -u devops -p ***** --server=https://ocp-master1.rhdevops.net:443
$ ./java-hello-service-setup.sh
```

シェルを実行すると下記のようにプロジェクトが作成された後、CI/CD テンプレートをもとに設定オブジェクトおよびコンテナがデプロイされます。

```
Now using project "java-hello-service-dev" on server "https://ocp-master1.rhdevops.net:443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
Now using project "java-hello-service-cicd" on server "https://ocp-master1.rhdevops.net:443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
route "jenkins" created
deploymentconfig "jenkins" created
rolebinding "default_edit" created
service "jenkins-jnlp" created
service "jenkins" created
buildconfig "java-hello-service-pipeline" created
service "gogs" created
service "postgresql-gogs" created
route "gogs" created
imagestream "gogs" created
deploymentconfig "gogs" created
deploymentconfig "postgresql-gogs" created
pod "install-gogs" created
configmap "gogs-install" created
service "postgresql-sonarqube" created
service "sonarqube" created
route "sonarqube" created
imagestream "sonarqube" created
deploymentconfig "postgresql-sonarqube" created
deploymentconfig "sonarqube" created
```

java-hello-service-cicd プロジェクトのコンテナがすべて起動する (STATUS が Running になる) まで待ちます。

```
$ oc get pods -n java-hello-service-cicd
NAME                           READY     STATUS      RESTARTS   AGE
gogs-1-e8q7d                   1/1       Running     1          4h
install-gogs                   0/1       Completed   0          4h
jenkins-1-wvl0u                1/1       Running     1          4h
postgresql-gogs-1-96d6j        1/1       Running     1          4h
postgresql-sonarqube-1-73mgg   1/1       Running     1          4h
sonarqube-1-fe5hm              1/1       Running     2          4h
```

コンテナの状況は Web コンソールからも確認できます。コンテナがすべて起動したら構築は完了です。

![](images/cicd-pod-status.png)

## 検証手順

1. java-hello-service プロジェクトのソースをリポジトリに push (初回のみ実行)

    下記シェルを実行すると ID/PASS が求められるので gogs/password と入力し push を完了させます。 

    ```
    $ ./java-hello-service-push.sh
    ```

2. CI/CD パイプラインの実行

    ソースの push をトリガに自動的に CI/CD パイプラインが実行されます。実行されたパイプラインの進捗を Web コンソールまたは Jenkins コンソールで確認します。Jenkins コンソールには admin/password でログインできます。

3. アプリケーションの確認

    パイプラインの実行が完了したらアプリケーションが表示されることを確認します。

    http://java-hello-service-java-hello-service-dev.apps.rhdevops.net/hello/rs/hello-service/hello?name=RedHat

## CI/CD テンプレート概要

[テンプレート](java-hello-service-template.yaml) には下記の OpenShift オブジェクト設定が含まれます。

- Jenkins Master
    - Route
    - Service
    - DeploymentConfig
    - Rolebinding
- Pipeline
    - BuildConfig
    - Jenkinsfile
- Gogs
    - Service
    - DeploymentConfig
    - ImageStream
- Gogs (PostgreSQL)
    - Service
    - DeploymentConfig
- Gogs Installer
    - Pod
    - ConfigMap
- SonarQube
    - Route
    - Service
    - DeploymentConfig
    - ImageStream
- SonarQube (PostgreSQL)
    - Service
    - DeploymentConfig

## その他の設定
- Persistent Volume について

    コンテナは停止時にデータが消えてしまうため、DB などデータの永続化が必要なコンテナでは Persistent Volume 設定を使用してデータを永続化します。しかし、この設定は若干複雑であり、基礎理解のフェーズでは理解の妨げになる可能性があるため、今回はシンプルさを優先させ設定していません。
