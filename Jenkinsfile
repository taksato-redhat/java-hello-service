node('maven') {
             // define commands
             //def ocCmd = "/opt/ocp/bin/oc"
             //def ocCmd = "oc"
             //def mvnHome = tool 'maven350'
             //def mvnCmd = "${mvnHome}/bin/mvn"
             def mvnCmd = "mvn"

             def prjName = "java-hello-service-dev"

             //sh "${ocCmd} login -u devops -p RedHat2017 --server=https://ocp-master1.rhdevops.net --insecure-skip-tls-verify=true"
            
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
                     //sh "${mvnCmd} sonar:sonar -Dsonar.host.url=http://sonarqube:9000 -DskipTests=true"
                 }
             )
             
             stage 'Deploy DEV'
             sh "${ocCmd} delete bc,dc,svc,route -l app=java-hello-service -n ${prjName}"

             // create build. override the exit code since it complains about exising imagestream
             sh "${ocCmd} new-build --name=java-hello-service --image-stream=wildfly-101-centos7 --binary=true --labels=app=java-hello-service -n ${prjName} || true"

             // build image
             sh "${ocCmd} start-build java-hello-service --from-file=./deployments/hello-1.0.0-SNAPSHOT-dev.ear --wait=true -n ${prjName}"

             // deploy image
             sh "${ocCmd} new-app java-hello-service:latest -n ${prjName}"
             sh "${ocCmd} expose svc/java-hello-service -n ${prjName}"
}

def version() {
            def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
            matcher ? matcher[0][1] : null
}
