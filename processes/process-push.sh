#!/bin/sh

# ソース commit & push
echo "'oc get pods install-gogs' が Complete となって、 Gogs のインストールが完了したら Enter を押してください。"
read
GOGS_ROUTE=`oc get route -n java-hello-service-cicd | grep gogs | awk '{print $2}'`

cd ../java-hello-service
git init
git remote rm origin
git remote add origin http://$GOGS_ROUTE/gogs/java-hello-service.git
git add -A
git commit -m 'Initial commit.'
git push -u origin master
