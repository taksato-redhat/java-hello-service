node {
             // define commands
             def ocCmd = "/opt/ocp/bin/oc"
             def mvnHome = tool 'M3'
             def mvnCmd = "${mvnHome}/bin/mvn"

             sh "${ocCmd} login -u redhat -p password --server=https://master1-c8f8.oslab.opentlc.com --insecure-skip-tls-verify=true"
            
             stage 'Build'
             git branch: 'master', url: 'https://github.com/taksato-redhat/java-hello-service.git'
             def v = version()
             sh "${mvnCmd} clean install -P openshift -DskipTests=true"
             
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
             sh "${ocCmd} delete bc,dc,svc,route -l app=java-hello-service -n java-hello-service-dev"
             // create build. override the exit code since it complains about exising imagestream
             sh "${ocCmd} new-build --name=java-hello-service --image-stream=jboss-wildfly101 --binary=true --labels=app=java-hello-service -n java-hello-service-dev || true"
             // build image
             sh "${ocCmd} start-build java-hello-service --from-file=deployments/*.ear --wait=true -n java-hello-service-dev"
             // deploy image
             sh "${ocCmd} new-app java-hello-service:latest -n java-hello-service-dev"
             sh "${ocCmd} expose svc/java-hello-service -n java-hello-service-dev"
}

def version() {
            def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
            matcher ? matcher[0][1] : null
}
