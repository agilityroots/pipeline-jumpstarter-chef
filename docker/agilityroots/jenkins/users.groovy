import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;
import hudson.model.*
import jenkins.model.*
import hudson.security.*

global_domain = Domain.global()
credentials_store =
  Jenkins.instance.getExtensionList(
    'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
  )[0].getStore()

credentials = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,null,"root",new BasicSSHUserPrivateKey.UsersPrivateKeySource(),"","")

credentials_store.addCredentials(global_domain, credentials)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def adminUsername = System.getenv('JENKINS_ADMIN_USERNAME') ?: 'admin'
def adminPassword = System.getenv('JENKINS_ADMIN_PASSWORD') ?: 'J5nkins@AR#2018'
hudsonRealm.createAccount(adminUsername, adminPassword)
hudsonRealm.createAccount("engineer", "Engin55r@AR#2018")

def instance = Jenkins.getInstance()
instance.setSecurityRealm(hudsonRealm)
instance.save()

def strategy = new GlobalMatrixAuthorizationStrategy()

// Setting anonymous permissions
strategy.add(hudson.model.Hudson.READ,'anonymous')
strategy.add(hudson.model.Item.READ,'anonymous')

//TODO - Setting Logged in User Permisions

// Setting Admin Permissions
strategy.add(Jenkins.ADMINISTER, "admin")

instance.setAuthorizationStrategy(strategy)
instance.save()