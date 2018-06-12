FROM jenkins/jenkins:lts
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
RUN /usr/local/bin/install-plugins.sh git github github-organization-folder github-branch-source maven-plugin credentials ssh-credentials credentials-binding nested-view copyartifact build-user-vars-plugin envinject groovy-postbuild violations ssh-slaves job-dsl cloudbees-folder view-job-filters ws-cleanup timestamper build-timeout email-ext mailer parameterized-trigger run-condition conditional-buildstep build-pipeline-plugin matrix-auth workflow-aggregator sonar sonar-quality-gates docker-plugin docker-workflow pipeline-github-lib 
COPY maven.groovy /usr/share/jenkins/ref/init.groovy.d/maven.groovy
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
