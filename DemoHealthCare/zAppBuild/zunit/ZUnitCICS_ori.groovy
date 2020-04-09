@groovy.transform.BaseScript com.ibm.dbb.groovy.ScriptLoader baseScript
import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import com.ibm.dbb.build.*
import groovy.transform.*

// define script properties
@Field BuildProperties props = BuildProperties.getInstance()
@Field def buildUtils= loadScript(new File("${props.zAppBuildDir}/utilities/BuildUtilities.groovy"))

println("** Building files mapped to ${this.class.getName()}.groovy script")

def env=System.getenv()
String dbb_home = env['DBB_HOME']  
println("dbbconf: ${dbb_home}")
println("program: ${argMap.program}")
def zUnitFail = 0

// verify required test properties
buildUtils.assertBuildProperties(props.zunit_requiredBuildProperties)

//println("testcase: ${argMap.testcase}")
//println("playbackfile: ${argMap.playBackFile}")
//println("codecoverage: ${argMap.codeCoverage}")
//println("proclib: ${props.zunit_ProcLib}")
//println("conf: ${props.zunit_ConfFolder}")
//println("results: ${props.outDir} and ${props.zunit_ResultsFolder}")
//println("maxRC: ${props.zunit_maxRC}")
//println("steplib: ${props.zunit_STEPLIB}")

//Execute JCL from a String value in the script
def jcl = "//RUNZUNIT JOB , \n" +                                                           
"// MSGCLASS=H,MSGLEVEL=(1,1),TIME=NOLIMIT,REGION=0M,COND=(16,LT) \n" + 
"//        JCLLIB ORDER=(${props.zunit_ProcLib}) \n" +
"//* \n" +
"//RUNNER EXEC PROC=BZUPPLAY, \n" +
"//  BZUCFG=${props.zunit_ConfFolder}(${argMap.testcase}), \n" +
"//  BZUCBK=${props.cobol_loadPDS}, \n" + 
"//  BZULOD=${props.cobol_loadPDS}, \n" +
"//  PARM=('STOP=E,REPORT=XML') \n" +
"//BZUPLAY DD DISP=SHR, \n" +
"//  DSN=${argMap.playBackFile} \n" +
"//BZURPT DD DISP=SHR, \n" + 
"//  DSN=${props.zunit_ResultsFolder}(${argMap.testcase}) \n" + 
"//STEPLIB  DD                       \n" + 
"//         DD                       \n" + 
"//         DD                       \n" +
"//         DD                       \n" +
"//         DD                       \n" +
'//    DD  DISP=SHR,DSN=' + props.zunit_STEPLIB 
if (argMap.codeCoverage) {
   jcl = jcl + " \n" +
   "//CEEOPTS DD *                        \n"   + 
   "TEST(ALL,,PROMPT,DBMDT%IBMUSER:*)  \n" +
   "ENVAR(                                \n" +
   '"'+ "EQA_STARTUP_KEY=CC,${argMap.testcase},testid=${argMap.testcase},moduleinclude=${argMap.program}" + '")' + "\n" +
   "/*"
}
	
//println(jcl)
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
def resultFile = new File("${props.outDir}/${argMap.testcase}.bzures")
def copyRc = new CopyToHFS().dataset(props.zunit_ResultsFolder).member(argMap.testcase).file(resultFile).copyMode(DBBConstants.CopyMode.BINARY).execute()

if (copyRc != 0)
{
    println "Error copying result file from ${props.zunit_ResultsFolder($argMap.testcase)} to ZFS"
    System.exit(1)
}

def comm = "chtag -tc ISO8859-1 ${resultFile}"
Process proc = comm.execute()

/* Parsing the result file and display summary of the result */
def runnerResult = new XmlParser().parse(resultFile)
def testCase = runnerResult.testCase
println "****************** Module ${testCase.@moduleName} ******************"
println "Name:       ${testCase.@name[0]}"
println "Status:     ${statusToString(testCase.@result[0])}"
println "Test cases: ${testCase.@tests[0]} (${testCase.@passed[0]} passed, ${testCase.@failures[0]} failed, ${testCase.@errors[0]} errors)"
println "Details: "

testCase.test.each { test ->
    if (test.@result == 'pass')
        print '    '
    else {
        print ' x  '
        zUnitFail = 1
        props.error = "true"
    }
    println "${test.@name}"
}
println "****************** Module ${testCase.@moduleName} ****************** \n"
return zUnitFail


/**
 * A helper to display the status as either PASS or FAIL
 * @param status the status from the zunit runner
 * @return a string representing the status
 */
static def statusToString(def status)
{
    return status.equalsIgnoreCase('pass') ? 'PASS' : 'FAIL'
}