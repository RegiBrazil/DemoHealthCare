@groovy.transform.BaseScript com.ibm.dbb.groovy.ScriptLoader baseScript
// updated to change HLQ to right name (from json file) - June 26, 2020
// updated the loadlib to props.zunit_STEPLIB - Oct 20
// Look for IBMUSER on HLQ now
// fixed " on line 49 that caused bad UTF8 and fail the clone - July 06 2020
import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import com.ibm.dbb.build.*
import groovy.transform.*
import groovy.json.JsonSlurper
import groovy.util.XmlParser
import groovy.util.XmlSlurper

// define script properties
@Field BuildProperties props = BuildProperties.getInstance()
@Field def buildUtils= loadScript(new File("../utilities/BuildUtilities.groovy"))

def member = null
def testCase = null
def playBackFile = null
getTestProperties(args)
	
if (props.buildFile.endsWith(".txt")) {
	if (!props.buildFile.trim().startsWith('/'))
		props.buildFile = "${props.workspace}/${props.buildFile}" as String
	println "** Adding files listed in ${props.buildFile} to test list"

	File jBuildFile = new File(props.buildFile)
	String files = jBuildFile.readLines()
	println files
	String[] strarr = files.split('/')
	member = strarr[strarr.length-1].tokenize(".")[0]
	println member
	runTest(member)
}
// else it's a single file to build
else {
	println "** Adding ${props.buildFile} to test program list"
	runTest(props.buildFile)
}


def runTest(String member) {
	def env=System.getenv()
	String dbb_home = env['DBB_HOME']
	println("dbbconf: ${dbb_home}")
	
 	(testCase,playBackFile) = checkIfTestExists(member)

  // --------------- added by **regi** Suman fix- June 26 , 2020
  //  def Test = playBackFile.replaceAll("<HLQ>",,"JENKINS")
    def Test = playBackFile.replaceAll("<HLQ>",,"IBMUSER")
  	println("test " + Test)
  playBackFile = Test
  println("playbackfile: " + playBackFile)
 // ---------------------------------------------------
	if (testCase) {
		println "**REGI we have a testcase"
		println("playBackFile:" + playBackFile)
		def programName = member.toUpperCase()
		println("for program:" + programName)
	
		//Execute JCL from a String value in the script
		def jcl = "//RUNZUNIT JOB , \n" +
		"// MSGCLASS=H,MSGLEVEL=(1,1),TIME=NOLIMIT,REGION=0M,COND=(16,LT) \n" +
		"//        JCLLIB ORDER=(${props.zunit_ProcLib}) \n" +
		"//* \n" +
		"//RUNNER EXEC PROC=BZUPPLAY, \n" +
		"//  BZUCFG=${props.zunit_ConfFolder}(${testCase}), \n" +
 // - Regi added the IBMUSER.GIT.ZMOBILE.LOAD instead of JENKINS.HEALTH.LOAD
 //		"//  BZUCBK=${props.load_PDS}, \n" +
 //		"//  BZULOD=${props.load_PDS}, \n" +
		"//  BZUCBK=${props.zunit_STEPLIB}, \n" +
		"//  BZULOD=${props.zunit_STEPLIB}, \n" +
		"//  PARM=('STOP=E,REPORT=XML') \n" +
		"//BZUPLAY DD DISP=SHR, \n" +
		"//  DSN=${playBackFile} \n" +
		"//BZURPT DD DISP=SHR, \n" +
		"//  DSN=${props.zunit_ResultsFolder}(${testCase}) \n" +
		"//STEPLIB  DD                       \n" +
		"//         DD                       \n" +
		"//         DD                       \n" +
		"//         DD                       \n" +
		"//         DD                       \n" +
		'//    DD  DISP=SHR,DSN=' + props.zunit_STEPLIB
		if (props.codeCoverage) {
		   jcl = jcl + " \n" +
		   "//CEEOPTS DD *                        \n"   +
		   "TEST(,,,TCPIP&10.1.1.1%8005:*)        \n" +
		   "ENVAR(                                \n" +
		   '"'+"EQA_STARTUP_KEY=CC,${testCase},testid=${testCase},moduleinclude=${programName}" + '")' + "\n" +
		   "/*"
		}
			
		println "**REGI This is the JCL that will be submitted to batch"
// was >		//println(jcl)
		println(jcl)
		def exec = new JCLExec()
		int rc = exec.text(jcl).confDir("${dbb_home}/conf").execute()
		
		/* Check the return code from the submitted job */
		def maxRC = exec.maxRC
		if ((maxRC == 'CC 0000') || (maxRC == 'CC 0004'))
		    println "The JCL Job ${exec.submittedJobId} completed successfully"
		else {
		    println "The JCL Job ${exec.submittedJobId} completed with Max-RC: $maxRC"
		    System.exit(1)
		}
		
		
		/* Copy the result from the data set member to a temporary file on zFS to parse the XML */
		def resultFile = new File("${props.outDir}/${testCase}.bzures")
		def copyRc = new CopyToHFS().dataset(props.zunit_ResultsFolder).member(testCase).file(resultFile).copyMode(DBBConstants.CopyMode.BINARY).execute()
		
		if (copyRc != 0)
		{
		    println "Error copying result file from ${props.zunit_ResultsFolder($testCase)} to ZFS"
		    System.exit(1)
		}
		
		
		def comm = "chtag -tc UTF-8 ${resultFile}"
		Process proc = comm.execute()
		
		/* Parsing the result file and display summary of the result */
		def runnerResult = new XmlParser().parse(resultFile)
		def testCaseResults = runnerResult.testCase
		println "****************** Module ${testCaseResults.@moduleName} ******************"
		println "Name:       ${testCaseResults.@name[0]}"
		println "Status:     ${statusToString(testCaseResults.@result[0])}"
		println "Test cases: ${testCaseResults.@tests[0]} (${testCaseResults.@passed[0]} passed, ${testCaseResults.@failures[0]} failed, ${testCaseResults.@errors[0]} errors)"
		println "Details: "
		
		testCaseResults.test.each { test ->
		    if (test.@result == 'pass')
		        print '    '
		    else {
		        print ' x  '
		        props.error = "true"
		    }
		    println "${test.@name}"
		}
		println "****************** Module ${testCaseResults.@moduleName} ****************** \n"
	}
}

// end script

/**
 * A helper to display the status as either PASS or FAIL
 * @param status the status from the zunit runner
 * @return a string representing the status
 */
static def statusToString(def status)
{
    return status.equalsIgnoreCase('pass') ? 'PASS' : 'FAIL'
}



def getTestProperties(String[] args) {

	def zAppBuildDir =  getScriptDir()
	props.zAppBuildDir = zAppBuildDir
	println(zAppBuildDir)
	
	String usage = 'ZUnitExecute.groovy [options] programFile'
	String header =  '''programFile (mandatory):  Program(s) to be tested. \
	If programFile is a text file (*.txt) then it is assumed to be a list .
	options:
		'''
		
	def cli = new CliBuilder(usage:usage,header:header)
	cli.o(longOpt:'outDir', args:1, 'Absolute path to the test results root directory')
	cli.c(longOpt:'testConf', args:1, 'Absolute path to the zUnit properties directory')
	cli.h(longOpt:'hlq', args:1, 'High level qualifier for partition data sets')
	cli.l(longOpt:'loadlib', args:1, 'Loadlib containing test case binaries')
	cli.w(longOpt:'workspace', args:1, 'Absolute path to workspace (root) directory containing all required source directories')
	cli.cc(longOpt:'codeCov', 'Flag to initiate code coverage collection with the tests')
	
	def opts = cli.parse(args)
	if (!opts) {
		println(header)
		System.exit(1)
	}

	if (opts.o) props.outDir = opts.o
	if (opts.c) props.testConf = opts.c
	if (opts.h) props.hlq = opts.h
	if (opts.l) props.load_PDS = opts.l
	else props.load_PDS = props.hlq + ".LOAD"
	if (opts.w) props.workspace = opts.w
	buildUtils.assertBuildProperties('outDir,load_PDS')
	if (opts.cc) props.codeCoverage = 'true'
		
	if (!props.zunitDirs) {
	   buildUtils.assertBuildProperties('testConf')
	}

	println("** Building files mapped to ${this.class.getName()}.groovy script")

	if (opts.arguments()) {
	    props.buildFile = opts.arguments()[0].trim()
	    println(props.buildFile)
	} else {
		println(header)
		System.exit(1)
	}	

	if (props.testConf) {
		props.load(new File("${props.testConf}/zunit.properties"))
	}

	// verify required test properties
    buildUtils.assertBuildProperties(props.zunit_requiredBuildProperties)
//	
//	println("proclib: ${props.zunit_ProcLib}")
//	println("conf: ${props.zunit_ConfFolder}")
//	println("results: ${props.outDir} and ${props.zunit_ResultsFolder}")
//	println("maxRC: ${props.zunit_maxRC}")
//	println("steplib: ${props.zunit_STEPLIB}")
}

def checkIfTestExists(String member) {
	println member
	testCase = ''
	playBackFile = ''
	def testfile = new File("${props.workspace}/${props.zunitDirs}/${member}.json")
	println testfile

    if (testfile.exists()) {
       (testCase,playBackFile) = retrieveTestparms(testfile)
       println("Execute testcase ${testCase} and playback file ${playBackFile}")
    }
    else println("No testcases exist for the program ${member}")

	return [testCase,playBackFile]
}

def retrieveTestparms(File testfile) {
    testCase = ''
    playBackFile = ''
    def InputJSON = new JsonSlurper().parseText(testfile.text)

    def testCaseInfo = InputJSON.get('config')
       // println "testCaseInfo:" +  testCaseInfo

    def genXML = testCaseInfo.keySet().iterator().next
    xmlText = genXML.getValue()
    def list = new XmlSlurper().parseText(xmlText)

    testCase = list."OutputProgramArray"."OutputProgram".@fileName.text()

    playBackFile = list."PlaybackFileArray"."PlaybackFile".@name.text()
    return [testCase.toUpperCase(),playBackFile.toUpperCase()]

}