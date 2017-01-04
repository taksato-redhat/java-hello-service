node {
             // define commands
             def ocCmd = "/opt/ocp/bin/oc --token=`cat /var/run/secrets/kubernetes.io/serviceaccount/token` --server=https://master1-5f26.oslab.opentlc.com --certificate-authority=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
             def mvnHome = tool 'M3'
             def mvnCmd = "${mvnHome}/bin/mvn"
            
             stage 'Build'
             git branch: 'master', url: 'https://github.com/taksato-redhat/java-hello-service.git'
             def v = version()
             sh "${mvnCmd} clean package -P jenkins"
             
             stage 'Test and Analysis'
             parallel (
                 'Test': {
                     sh "${mvnCmd} test"
                     step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                 },
                 'Static Analysis': {
                     sh "${mvnCmd} sonar:sonar -Dsonar.host.url=http://localhost:9000 -DskipTests=true"
                 }
             )
             
             stage 'Deploy DEV'
             sh "${ocCmd} delete bc,dc,svc,route -l app=java-hello-service -n dev"
             // create build. override the exit code since it complains about exising imagestream
             sh "${ocCmd} new-build --name=java-hello-service --image-stream=jboss-wildfly101 --binary=true --labels=app=java-hello-service -n dev || true"
             // build image
             sh "${ocCmd} start-build java-hello-service --from-dir=oc-build --wait=true -n dev"
             // deploy image
             sh "${ocCmd} new-app java-hello-service:latest -n dev"
             sh "${ocCmd} expose svc/java-hello-service -n dev"
}

def version() {
            def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
            matcher ? matcher[0][1] : null
}
