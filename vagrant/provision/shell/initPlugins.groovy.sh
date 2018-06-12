if [ ! -f "loadPlugins.groovy" ]
then
    cat > loadPlugins.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger
def logger = Logger.getLogger("")
def installed = false
def initialized = false
def pluginParameter="git credentials ssh-credentials git-client scm-api github github-api github-oauth mailer javadoc maven-plugin jquery dashboard-view parameterized-trigger token-macro run-condition conditional-buildstep build-pipeline-plugin cloudbees-folder job-dsl view-job-filters embeddable-build-status groovy dashboard-view rich-text-publisher-plugin console-column-plugin docker-plugin ws-cleanup timestamper ssh-slaves peline-github-lib workflow-aggregator matrix-auth github-branch-source email-ext build-timeout sonar sonar-quality-gates nexus-jenkins-plugin docker-workflow credentials-binding github-organization-folder nested-view copyartifact build-blocker-plugin build-user-vars-plugin envinject groovy-postbuild violations"
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
plugins.each {
    logger.info("Checking " + it)
    if (!pm.getPlugin(it)) {
        logger.info("Looking UpdateCenter for " + it)
        if (!initialized) {
            uc.updateAllSites()
            initialized = true
        }
        def plugin = uc.getPlugin(it)
        if (plugin) {
            logger.info("Installing " + it)
            def installFuture = plugin.deploy()
                while(!installFuture.isDone()) {
                logger.info("Waiting for plugin install: " + it)
                sleep(3000)
            }
            installed = true
        }
    }
}
if (installed) {
    logger.info("Plugins installed, initializing a restart!")
    instance.save()
    instance.restart()
}  
_EOF_
curl  --data-urlencode "script=$(<./loadPlugins.groovy)" http://localhost:8080/scriptText
fi