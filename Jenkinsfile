          node('maven') {
            // define commands
            def mvnCmd = "mvn -s configuration/settings.xml"

            stage 'Build'
            git branch: 'master', url: 'http://gogs:3000/gogs/java-hello-service.git'
            def v = version()
            sh "${mvnCmd} clean install -DskipTests=true -Popenshift"

            stage 'Test'
            sh "${mvnCmd} org.jacoco:jacoco-maven-plugin:prepare-agent test"
            step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])

            stage 'Deploy DEV'
            sh "oc project sis4-dev"
            // clean up. keep the image stream
            sh "oc delete bc,dc,svc,route -l app=sis4-app -n sis4-dev"
            // create build. override the exit code since it complains about exising imagestream
            sh "oc new-build --name=sis4-app --image-stream=jboss-eap70-openshift --binary=true --labels=app=sis4-app -n sis4-dev || true"
            // build image
            sh "oc start-build sis4-app --from-dir=deployments --wait=true -n sis4-dev"
            // deploy image
            sh "oc new-app sis4-app:latest -n sis4-dev"
            sh "oc expose svc/sis4-app -n sis4-dev"

          }

          def version() {
            def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
            matcher ? matcher[0][1] : null
          }
