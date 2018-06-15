import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration
import net.sf.json.JSONObject

if(!binding.hasVariable('master_settings')) {
    master_settings = [:]
}
if(!(master_settings instanceof Map)) {
    throw new Exception('master_settings must be a Map.')
}

master_settings = master_settings as JSONObject

def requiredDefaultValues(def value, List values, def default_value) {
    (value in values)? value : default_value
}

//settings with sane defaults
String frontend_url = master_settings.optString('frontend_url', 'http://localhost:8282/')
String admin_email = master_settings.optString('admin@agilityroots.com')
String system_message = master_settings.optString('Welcome to Immutable Jenkins!')
int quiet_period = master_settings.optInt('quiet_period', 2)
int scm_checkout_retry_count = master_settings.optInt('scm_checkout_retry_count', 0)
int master_executors = master_settings.optInt('master_executors', 5)
String master_labels = master_settings.optString('master_labels')
String master_usage = requiredDefaultValues(master_settings.optString('master_usage').toUpperCase(), ['NORMAL', 'EXCLUSIVE'], 'EXCLUSIVE')
int jnlp_slave_port = master_settings.optInt('jnlp_slave_port', 10005)

Jenkins j = Jenkins.instance
JenkinsLocationConfiguration location = j.getExtensionList('jenkins.model.JenkinsLocationConfiguration')[0]
Boolean save = false

if(location.url != frontend_url) {
    println "Updating Jenkins URL to: ${frontend_url}"
    location.url = frontend_url
    save = true
}
if(admin_email && location.adminAddress != admin_email) {
    println "Updating Jenkins Email to: ${admin_email}"
    location.adminAddress = admin_email
    save = true
}
if(j.systemMessage != system_message) {
    println 'System message has changed.  Updating message.'
    j.systemMessage = system_message
    save = true
}
if(j.quietPeriod != quiet_period) {
    println "Setting Jenkins Quiet Period to: ${quiet_period}"
    j.quietPeriod = quiet_period
    save = true
}
if(j.scmCheckoutRetryCount != scm_checkout_retry_count) {
    println "Setting Jenkins SCM checkout retry count to: ${scm_checkout_retry_count}"
    j.scmCheckoutRetryCount = scm_checkout_retry_count
    save = true
}
if(j.numExecutors != master_executors) {
    println "Setting master num executors to: ${master_executors}"
    j.numExecutors = master_executors
    save = true
}
if(j.labelString != master_labels) {
    println "Setting master labels to: ${master_labels}"
    j.setLabelString(master_labels)
    save = true
}
if(j.slaveAgentPort != jnlp_slave_port) {
    if(jnlp_slave_port <= 65535 && jnlp_slave_port >= -1) {
        println "Set JNLP Slave port: ${jnlp_slave_port}"
        j.slaveAgentPort = jnlp_slave_port
        save = true
    }
    else {
        println "WARNING: JNLP port ${jnlp_slave_port} outside of TCP port range.  Must be within -1 <-> 65535.  Nothing changed."
    }
}
// Configure GIT Settings
def desc = j.getDescriptor("hudson.plugins.git.GitSCM")
desc.setGlobalConfigName("Mr. Jenkins")
desc.setGlobalConfigEmail("jenkins@agilityroots.com")
desc.save()

//save configuration to disk
if(save) {
    j.save()
    location.save()
}
else {
    println 'Nothing changed.  Jenkins settings already configured.'
}