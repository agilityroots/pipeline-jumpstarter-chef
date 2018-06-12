if [ ! -f "loadPlugins.groovy" ]
then
    cat > loadPlugins.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger
def logger = Logger.getLogger("")
def installed = false
def initialized = false
def pluginParameter="git github github-organization-folder github-branch-source maven-plugin credentials ssh-credentials credentials-binding nested-view copyartifact build-user-vars-plugin envinject groovy-postbuild violations ssh-slaves job-dsl cloudbees-folder view-job-filters ws-cleanup timestamper build-timeout email-ext mailer parameterized-trigger run-condition conditional-buildstep build-pipeline-plugin matrix-auth workflow-aggregator sonar sonar-quality-gates docker-plugin docker-workflow pipeline-github-lib"
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
curl -sS --data-urlencode "script=$(<./loadPlugins.groovy)" http://localhost:8080/scriptText
fi