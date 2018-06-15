FROM jenkins/jenkins:lts
RUN /usr/local/bin/install-plugins.sh git git github github-organization-folder github-branch-source maven-plugin credentials ssh-credentials credentials-binding nested-view copyartifact build-user-vars-plugin groovy-postbuild violations ssh-slaves job-dsl cloudbees-folder view-job-filters ws-cleanup timestamper build-timeout email-ext mailer parameterized-trigger run-condition conditional-buildstep build-pipeline-plugin matrix-auth workflow-aggregator sonar sonar-quality-gates docker-plugin docker-workflow pipeline-github-lib nexus-jenkins-plugin
COPY disableUsageStats.groovy /usr/share/jenkins/ref/init.groovy.d/disableUsageStats.groovy
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY jenkinsSettings.groovy /usr/share/jenkins/ref/init.groovy.d/jenkinsSettings.groovy
COPY jdk.groovy /usr/share/jenkins/ref/init.groovy.d/jdk.groovy
COPY maven.groovy /usr/share/jenkins/ref/init.groovy.d/maven.groovy
COPY xsecurity.groovy /usr/share/jenkins/ref/init.groovy.d/xsecurity.groovy
COPY users.groovy /usr/share/jenkins/ref/init.groovy.d/users.groovy
RUN echo 2.60.3 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo 2.60.3 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion