cat > disableUsageStats.groovy <<_EOF_
import jenkins.model.Jenkins

def j = Jenkins.instance
if(!j.isQuietingDown()) {
    if(j.isUsageStatisticsCollected()){
        j.setNoUsageStatistics(true)
        j.save()
        println 'Disabled submitting usage stats to Jenkins project.'
    }
    else {
        println 'Nothing changed.  Usage stats are not submitted to the Jenkins project.'
    }
}
else {
    println 'Shutdown mode enabled.  Disable usage stats SKIPPED.'
}
_EOF_
timeout 300 bash -c -- 'while [ $(curl --write-out %{http_code} --silent --output /dev/null http://localhost:8080/api/json) -ne 200 ]; do echo "." > /dev/null;done'
curl -sS --data-urlencode "script=$(<./disableUsageStats.groovy)" http://localhost:8080/scriptText