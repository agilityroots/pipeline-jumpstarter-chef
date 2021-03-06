import jenkins.*;
import hudson.*;
import jenkins.model.*;
import jenkins.model.*
import hudson.security.*
import java.util.logging.Logger
def logger = Logger.getLogger("")
def mavenName = "maven-3"
def mavenVersion = "3.5.3"
logger.info("Checking Maven installations...")

mavenPlugin = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]

maven3Install = mavenPlugin.installations.find {
    install -> install.name.equals(mavenName)
}

if(maven3Install == null) {
    logger.info("No Maven install found. Adding...")
 
    newMavenInstall = new hudson.tasks.Maven.MavenInstallation('maven-3', null,
        [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller(mavenVersion)])]
    )
 
    mavenPlugin.installations += newMavenInstall
    mavenPlugin.save()
 
    logger.info("Maven install added.")
} else {
    logger.info("Maven install found. Done.")
}
