if [ ! -f "csrfProtection.groovy" ]
then
    cat > csrfProtection.groovy <<_EOF_
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

if(!Jenkins.instance.isQuietingDown()) {
    def j = Jenkins.instance
    if(j.getCrumbIssuer() == null) {
        j.setCrumbIssuer(new DefaultCrumbIssuer(true))
        j.save()
        println 'CSRF Protection configuration has changed.  Enabled CSRF Protection.'
    }
    else {
        println 'Nothing changed.  CSRF Protection already configured.'
    }
}
else {
    println "Shutdown mode enabled.  Configure CSRF protection SKIPPED."
}
_EOF_
curl -sS --data-urlencode "script=$(<./csrfProtection.groovy)" http://localhost:8080/scriptText
fi
