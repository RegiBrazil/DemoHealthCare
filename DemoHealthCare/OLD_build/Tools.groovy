import com.ibm.dbb.build.*
import com.ibm.dbb.build.report.*
import com.ibm.dbb.build.html.*
import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import groovy.transform.Field

def parseArgs(String[] cliArgs, String usage) {
	def cli = new CliBuilder(usage: usage)
	cli.s(longOpt:'sourceDir', args:1, argName:'dir', 'Absolute path to source directory')
	cli.w(longOpt:'workDir', args:1, argName:'dir', 'Absolute path to the build output directory')
	cli.b(longOpt:'buildHash', args:1, argName:'hash', 'Git commit hash for the build')
	cli.q(longOpt:'hlq', args:1, argName:'hlq', 'High level qualifier for partition data sets')
	cli.c(longOpt:'collection', args:1, argName:'name', 'Name of the dependency data collection')
	cli.t(longOpt:'team', args:1, argName:'hlq', 'Team build hlq for user build syslib concatenations')
	cli.r(longOpt:'repo', args:1, argName:'url', 'DBB repository URL')
	cli.i(longOpt:'id', args:1, argName:'id', 'DBB repository id')
	cli.p(longOpt:'pw', args:1, argName:'password', 'DBB password')
	cli.P(longOpt:'pwFile', args:1, argName:'file', 'Absolute or relative (from sourceDir) path to file containing DBB password')
	cli.e(longOpt:'logEncoding', args:1, argName:'encoding', 'Encoding of output logs. Default is EBCDIC')
	cli.u(longOpt:'userBuild', 'Flag indicating running a user build')
	cli.E(longOpt:'errPrefix', args:1, argName:'errorPrefix', 'Unique id used for IDz error message datasets')
	cli.h(longOpt:'help', 'Prints this message')
	cli.C(longOpt:'clean', 'Deletes the dependency collection and build reeult group from the DBB repository then terminates (skips build)')

	def opts = cli.parse(cliArgs)
	if (opts.h) { // if help option used, print usage and exit
	 	cli.usage()
		System.exit(0)
	}

    return opts
}

def loadProperties(OptionAccessor opts) {
	// check to see if there is a ./build.properties to load
	def properties = BuildProperties.getInstance()
	def scriptDir = new File(getClass().protectionDomain.codeSource.location.path).parent
	def buildPropFile = new File("$scriptDir/build.properties")
	if (buildPropFile.exists())
   		BuildProperties.load(buildPropFile)

	// set command line arguments
	if (opts.s) properties.sourceDir = opts.s
	if (opts.w) properties.workDir = opts.w
	if (opts.b) properties.buildHash = opts.b
	if (opts.q) properties.hlq = opts.q
	if (opts.c) properties.collection = opts.c
	if (opts.t) properties.team = opts.t
	if (opts.r) properties.repo = opts.r
	if (opts.i) properties.id = opts.i
	if (opts.p) properties.pw = opts.p
	if (opts.P) properties.pwFile = opts.P
	if (opts.e) properties.logEncoding = opts.e
	if (opts.E) properties.errPrefix = opts.E
	if (opts.u) properties.userBuild = "true"
	
	// handle --clean option
	if (opts.C)  {
		println("** Clean up option selected")
		def repo = getDefaultRepositoryClient()
		
		println("* Deleting dependency collection ${properties.collection}")
		repo.deleteCollection(properties.collection)

		println("* Deleting build result group ${properties.collection}Build")
		repo.deleteBuildResults("${properties.collection}Build")
		
		System.exit(0)
	}

	// load datasets.properties containing system specific PDS names used by Mortgage Application build
	properties.load(new File("$properties.sourceDir/DemoHealthCare/build/datasets.properties"))
	// load file.properties containing file specific properties like script mappings and CICS/DB2 content flags
	properties.load(new File("$properties.sourceDir/DemoHealthCare/build/file.properties"))

	println("** Build properties at startup:")
	println(properties.list())

	return properties
}

def validateRequiredProperties(List<String> props) {
    def properties = BuildProperties.getInstance()
    props.each { prop ->
        // handle password special case i.e. can have either pw or pwFile
    	if (prop.equals("password")) {
    		 if (!(properties.pw || properties.pwFile)) {
		     	assert properties.pw : "Missing property pw"
		      	assert properties.pwFile : "Missing property pwFile"
	       }
    	}
    	else {
    		assert properties."$prop" : "Missing property $prop"
    	}
    }
}


def getBuildList(List<String> args) {
    def properties = BuildProperties.getInstance()
    def files = []

	// Set the buildFile or buildList property
	if (args) {
		def buildFile = args[0]
	    if (buildFile.endsWith(".txt")) {
			if (buildFile.startsWith("/"))
				properties.buildListFile = buildFile
		      else
				properties.buildListFile = "$properties.sourceDir/$buildFile".toString()
	  	}
	    else {
			properties.buildFile = buildFile
	    }
	}

	// check to see if a build file was passed in
	if (properties.buildFile) {
		println("** Building file $properties.buildFile")
		files = [properties.buildFile]
	}
	// else check to see if a build list file was passed in
	else if (properties.buildListFile) {
		println("** Building files listed in $properties.buildListFile")
	    files = new File(properties.buildListFile) as List<String>
	}
	// build the entire Mortgage Application listed in files.txt
	else {
	    println("** Building files listed in $properties.sourceDir/DemoHealthCare/build/files.txt")
	    files = new File("$properties.sourceDir/DemoHealthCare/build/files.txt") as List<String>
	}	
	return files
}

// Added JCL type - Regi
def createDatasets() {
    def properties = BuildProperties.getInstance()
	def srcOptions = "cyl space(1,1) lrecl(80) dsorg(PO) recfm(F,B) dsntype(library) vol(USER05) msg(1)"
	def loadOptions = "cyl space(1,1) dsorg(PO) recfm(U) blksize(32760) dsntype(library) vol(USER05) msg(1)"
	def srcDatasets = ["COBOL", "COPYBOOK", "OBJ", "BMS", "DBRM", "LINK", "MFS", "JCL"]
	def loadDatasets = ["LOAD", "TFORMAT"]

	srcDatasets.each { dataset ->
		new CreatePDS().dataset("${properties.hlq}.$dataset").options(srcOptions).create()
	}

	loadDatasets.each { dataset ->
		new CreatePDS().dataset("${properties.hlq}.$dataset").options(loadOptions).create()
	}
	
	if (properties.errPrefix) {
	    def xmlOptions = "tracks space(200,40) dsorg(PS) blksize(27998) lrecl(16383) recfm(v,b) new vol(USER05)"
    	new CreatePDS().dataset("${properties.hlq}.${properties.errPrefix}.SYSXMLSD.XML").options(xmlOptions).create()
	}

}

def getDefaultRepositoryClient() {
    def properties = BuildProperties.getInstance()
	def repositoryClient = new RepositoryClient().url(properties.repo)
						     .userId(properties.id)
						     .forceSSLTrusted(true)
    if (properties.pw)
		repositoryClient.setPassword(properties.pw)
    else if (properties.pwFile) {
        def pFile = properties.pwFile
   		if (!pFile.startsWith("/"))
    		pFile = "$properties.sourceDir/$properties.pwFile"
		repositoryClient.setPasswordFile(new File(pFile))
	}
	return repositoryClient
}

def initializeBuildArtifacts() {
    BuildReportFactory.createDefaultReport()
    def properties = BuildProperties.getInstance()
    if (!properties.userBuild) {
        def repo = getDefaultRepositoryClient()
        properties.buildGroup = "${properties.collection}" as String
        properties.buildLabel = "build.${properties.startTime}" as String
        def buildResult = repo.createBuildResult(properties.buildGroup, properties.buildLabel)
        buildResult.setState(buildResult.PROCESSING)
        if (properties.buildHash)
            buildResult.setProperty("buildHash", properties.buildHash)
        buildResult.save()
        println("** Build result created at ${buildResult.getUrl()}")
    }
}

def getBuildResult() {
    def properties = BuildProperties.getInstance()
    def buildResult = null
    if (!properties.userBuild) {
        def repo = getDefaultRepositoryClient()
        buildResult = repo.getBuildResult(properties.buildGroup, properties.buildLabel)
    }
    return buildResult
}

def generateBuildReport() {
    def properties = BuildProperties.getInstance()
    def jsonOutputFile = new File("${properties.workDir}/BuildReport.json")
    def htmlOutputFile = new File("${properties.workDir}/BuildReport.html")

	// create build report data file
	def buildReportEncoding = "UTF-8"
	def buildReport = BuildReportFactory.getBuildReport()
	buildReport.save(jsonOutputFile, buildReportEncoding)

	// create build report html file
	def htmlTemplate = null  // Use default HTML template.
	def css = null       // Use default theme.
	def renderScript = null  // Use default rendering.
	def transformer = HtmlTransformer.getInstance()
	transformer.transform(jsonOutputFile, htmlTemplate, css, renderScript, htmlOutputFile, buildReportEncoding)
	
	return [ jsonOutputFile, htmlOutputFile ]
}

def getDefaultDependencyResolver(String file) {
    def properties = BuildProperties.getInstance()
	def path = new DependencyPath().sourceDir(properties.sourceDir).directory("DemoHealthCare/copybook")
	def rule = new ResolutionRule().library("SYSLIB").path(path)
    def resolver = new DependencyResolver().sourceDir(properties.sourceDir).file(file).rule(rule)
    if (properties.userBuild)
    	resolver.setScanner(new DependencyScanner())
    else {
        path.setCollection(properties.collection)
        resolver.setCollection(properties.collection)
        resolver.setRepositoryClient(getDefaultRepositoryClient())
    }
    return resolver
}

def getDefaultImpactResolver(String file) {
	def properties = BuildProperties.getInstance()
   	def path = new DependencyPath().sourceDir(properties.sourceDir).directory("DemoHealthCare/copybook")
   	def rule = new ResolutionRule().library("SYSLIB").path(path)
   	def resolver = new ImpactResolver().repositoryClient(getDefaultRepositoryClient()).collection(properties.collection).rule(rule).file(file)
   	return resolver
}

def updateBuildResult(Map args) {
    def properties = BuildProperties.getInstance()
    def error = args.rc > args.maxRC
    def errorMsg = null
    if (error) {
        errorMsg = "*! The return code (${args.rc}) for ${args.file} exceeded the maximum return code allowed (${args.maxRC})"
    	println(errorMsg)
    	properties.error = "true"
    }
    	
    if (!properties.userBuild) {
    	def buildResult = getBuildResult()
    	def member =  CopyToPDS.createMemberName(args.file)
		if (error) {
			buildResult.setStatus(buildResult.ERROR)
			buildResult.addProperty("error", errorMsg)
			if (args.log != null)
				buildResult.addAttachment("${member}.log", new FileInputStream(args.log))
		}
		buildResult.save()
	}
}

def finalizeBuildResult(Map args) {
	def properties = BuildProperties.getInstance()
	if (!properties.userBuild) {
		def buildResult = getBuildResult()
		buildResult.setBuildReport(new FileInputStream(args.htmlReport))
		buildResult.setBuildReportData(new FileInputStream(args.jsonReport))
		buildResult.setProperty("filesProcessed", String.valueOf(args.filesProcessed))
		buildResult.setState(buildResult.COMPLETE)
		buildResult.save()
	}
}

