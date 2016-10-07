	def majorVersion = 1
	def minorVersion = 1
	
	def currentBuild = Thread.currentThread().executable
	def scmChanges = 0
	currentBuild.parent.getSCMs().scmName.each {
	    def process = ['cmd', '/C', "\"cd ${currentBuild.workspace}\\${it == null ? "" : it} & git log --pretty=oneline | find /c /v \"\"\""].execute()
	    process.waitFor()
	    scmChanges += process.in.text.tokenize("\n")[0].toInteger()
	}
	def previousBuild = currentBuild.previousBuild
	def previousBuildVersion = previousBuild != null ? previousBuild.environment["VERSION"] : "NULL"
	def previousBuildAttempt = previousBuild != null ? previousBuild.environment["BUILD_ATTEMPT"] : -1
	def buildVersion = "${majorVersion}.${minorVersion}.${String.format( "%d%02d",new Date().month + 1 ,new Date().date )}.${scmChanges}"
	def buildAttempt = previousBuildVersion == "${buildVersion}${previousBuildAttempt}" ? previousBuildAttempt.toInteger() + 1 : 0
	return [VERSION: "${buildVersion}${buildAttempt}", BUILD_ATTEMPT: buildAttempt]