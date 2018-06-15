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

/* 
   Configure the content security policy to be less strict so reports can be
   loaded.  This is necessary for reporting tools which embed unsafe inline
   JavaScript and CSS.

   Note: if this is undesirable, then you can override this script to disable
   it in a local bootstrapper.  Example:

       mkdir scripts/init.groovy.d
       touch scripts/init.groovy.d/set-content-security-policy.groovy

   By having an empty file in your local bootstrapper, this script will get
   overwritten by it and never execute.  Alternatively, you could copy this
   script to your local bootstrapper and customize the content security policy
   yourself.

   See also https://wiki.jenkins.io/display/JENKINS/Configuring+Content+Security+Policy
*/

System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "default-src 'self' ${Jenkins.instance.rootUrl -~ '/$'} 'unsafe-inline'")

// Disable Update Site

for(UpdateSite site : jenkins.getUpdateCenter().getSiteList()) {
    site.neverUpdate = true
    site.data = null
    site.dataLastReadFromFile = -1
    site.dataTimestamp = 0
    new File(jenkins.getRootDir(), "updates/${site.id}.json").delete()
}

//https://wiki.jenkins-ci.org/display/JENKINS/Features+controlled+by+system+properties
System.setProperty('hudson.model.UpdateCenter.never', 'true')
logger.info("Disabled Jenkins Update Site")