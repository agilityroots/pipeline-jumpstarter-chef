import jenkins.model.Jenkins
import java.util.logging.Logger
def logger = Logger.getLogger("")
def j = Jenkins.instance
if(!j.isQuietingDown()) {
    if(j.isUsageStatisticsCollected()){
        j.setNoUsageStatistics(true)
        j.save()
        logger('Disabled submitting usage stats to Jenkins project.')
    }
    else {
        logger.info('Nothing changed.  Usage stats are not submitted to the Jenkins project.')
    }
}
else {
    logger.info('Shutdown mode enabled.  Disable usage stats SKIPPED.')
}