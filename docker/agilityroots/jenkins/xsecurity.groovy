import jenkins.model.Jenkins
import java.util.logging.Logger
def logger = Logger.getLogger("")
// Diable CLI Remoting
jenkins.model.Jenkins.instance.getDescriptor("jenkins.CLI").get().setEnabled(false)
logger.info("Disabled CLI Remoting")
// Enable CSRF
def jenkins = Jenkins.instance
if(jenkins.getCrumbIssuer() == null) {
    jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true))
    jenkins.save()
    logger.info('CSRF Protection configuration has changed.  Enabled CSRF Protection.') 
}
else {
    logger.info('Nothing changed.  CSRF Protection already configured.')
}
//Enable Slave -> Master Access Control (Enterprises Distributed Builds Only)
jenkins.injector.getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false);
jenkins.save()
logger.info('Enabled Slave -> Master Access Control')