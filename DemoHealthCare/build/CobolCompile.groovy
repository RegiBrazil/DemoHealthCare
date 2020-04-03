import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import com.ibm.dbb.build.*

// receive passed arguments
def file = args[0]
println("* Building $file using ${this.class.getName()}.groovy script")

// define local properties
def properties = BuildProperties.getInstance()
def cobolPDS = "${properties.hlq}.COBOL"
def copybookPDS = "${properties.hlq}.COPYBOOK"
def objectPDS = "${properties.hlq}.OBJ"
def loadPDS = "${properties.hlq}.LOAD"
def dbrmPDS = "${properties.hlq}.DBRM"
def member = CopyToPDS.createMemberName(file)
def logFile = new File("${properties.workDir}/${member}.log")

// create a reference to the Tools.groovy utility script
File scriptFile = new File("$properties.sourceDir/DemoHealthCare/build/Tools.groovy")
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(scriptFile)
GroovyObject tools = (GroovyObject) groovyClass.newInstance()

// define the BPXWDYN options for allocated temporary datasets
def tempCreateOptions = "cyl space(5,5) unit(vio) blksize(80) lrecl(80) recfm(f,b) new"

// copy program to PDS
println("Copying ${properties.sourceDir}/$file to $cobolPDS($member)")
new CopyToPDS().file(new File("${properties.sourceDir}/$file")).dataset(cobolPDS).member(member).execute()

//resolve program dependencies and copy to PDS
println("Resolving dependencies for file $file and copying to $copybookPDS")
def resolver = tools.getDefaultDependencyResolver(file)
def deps = resolver.resolve()
new CopyToPDS().dependencies(deps).dataset(copybookPDS).execute()

// compile and link-edit the build file
println("Compiling and link editing program $file")	
def logicalFile = resolver.getLogicalFile()

// create the appropriate compile parm list
def compileParms = "LIB,TEST"
if (logicalFile.isCICS()) {
    compileParms = "$compileParms,DYNAM,CICS"
}
if (logicalFile.isSQL()) {
    compileParms = "$compileParms,SQL"
}
if (properties.errPrefix) {
    compileParms = "$compileParms,ADATA,EX(ADX(ELAXMGUX))"
}

// define the MVSExec command to compile the program
def compile = new MVSExec().file(file).pgm("IGYCRCTL").parm(compileParms)

// add DD statements to the compile command
compile.dd(new DDStatement().name("SYSIN").dsn("$cobolPDS($member)").options("shr").report(true))
compile.dd(new DDStatement().name("SYSLIN").dsn("&&TEMPOBJ").options(tempCreateOptions).pass(true))
compile.dd(new DDStatement().name("SYSPRINT").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT1").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT2").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT3").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT4").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT5").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT6").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT7").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT8").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT9").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT10").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT11").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT12").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT13").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT14").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT15").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT16").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSUT17").options(tempCreateOptions))
compile.dd(new DDStatement().name("SYSMDECK").options(tempCreateOptions))

// add a syslib to the compile command with optional CICS concatenation
compile.dd(new DDStatement().name("SYSLIB").dsn(copybookPDS).options("shr"))
if (properties.team) {
       // for user builds concatenate the team build copbook pds
       compile.dd(new DDStatement().dsn("${properties.team}.COPYBOOK").options("shr"))
}
if (logicalFile.isCICS()) {
    // create a DD statement without a name to concatenate to the last named DD
    compile.dd(new DDStatement().dsn(properties.SDFHCOB).options("shr"))
}

// add a tasklib to the compile command with optional CICS, DB2, and IDz concatenations
compile.dd(new DDStatement().name("TASKLIB").dsn(properties.SIGYCOMP).options("shr"))
if (logicalFile.isCICS()) {
    compile.dd(new DDStatement().dsn(properties.SDFHLOAD).options("shr"))
}
if (logicalFile.isSQL()) {
    compile.dd(new DDStatement().dsn(properties.SDSNLOAD).options("shr"))
}
if (properties.SFELLOAD) {
    compile.dd(new DDStatement().dsn(properties.SFELLOAD).options("shr"))
}

// add optional DBRMLIB if build file contains DB2 code
if (logicalFile.isSQL()) {
    compile.dd(new DDStatement().name("DBRMLIB").dsn("$dbrmPDS($member)").options("shr").output(true).deployType("DBRM"))
}	

// add IDz User Build Error Feedback DDs
if (properties.errPrefix) {
    compile.dd(new DDStatement().name("SYSADATA").options("DUMMY"))
    compile.dd(new DDStatement().name("SYSXMLSD").dsn("${properties.hlq}.${properties.errPrefix}.SYSXMLSD.XML").options("mod keep"))
}

// add a copy command to the compile command to copy the SYSPRINT from the temporary dataset to an HFS log file
compile.copy(new CopyToHFS().ddName("SYSPRINT").file(logFile).hfsEncoding(properties.logEncoding))


// define the MVSExec command to link edit the program
def linkedit = new MVSExec().file(file).pgm("IEWBLINK").parm("MAP,RENT,COMPAT(PM5)")
	
// add DD statements to the linkedit command
linkedit.dd(new DDStatement().name("SYSLMOD").dsn("$loadPDS($member)").options("shr").output(true).deployType("LOAD"))
linkedit.dd(new DDStatement().name("SYSPRINT").options(tempCreateOptions))
linkedit.dd(new DDStatement().name("SYSUT1").options(tempCreateOptions))
linkedit.dd(new DDStatement().name("SYSLIB").dsn(objectPDS).options("shr"))
linkedit.dd(new DDStatement().dsn(properties.SCEELKED).options("shr"))
if (logicalFile.isCICS()) {
    linkedit.dd(new DDStatement().dsn(properties.SDFHLOAD).options("shr"))
}

// add a copy command to the linkedit command to append the SYSPRINT from the temporary dataset to the HFS log file
linkedit.copy(new CopyToHFS().ddName("SYSPRINT").file(logFile).hfsEncoding(properties.logEncoding).append(true))


// use MVSJob start and stop commands to handle passed DDs
def job = new MVSJob()
job.start()

rc = compile.execute()
tools.updateBuildResult(file:"$file", rc:rc, maxRC:4, log:logFile)

if (rc <= 4) {
	rc = linkedit.execute()
    tools.updateBuildResult(file:"$file", rc:rc, maxRC:0, log:logFile)
}

//  added by Regi - invoke rexx to do a DBRM BIND - March 15 2018
// Add a conditional bind step
    if (logicalFile.isSQL() && rc <= 0) {
    // ** Variables that need to be configured **
        def confDir = "/var/dbb/conf"
// full bind    def rexxScript = "IBMUSER.GIT.ZMOBILE.REXX(BINDHC)"
        def rexxScript = "IBMUSER.GIT.ZMOBILE.REXX(BINDHC2)"
//*
    // create the command script dataset
        def cmdscp = "${properties.hlq}.ISPFGWY.EXEC"
        def cmdscpOptions = "tracks space(1,1) lrecl(80) dsorg(PS) recfm(F,B) msg(1) new"
        new CreatePDS().dataset(cmdscp).options(cmdscpOptions).execute()

    // define the TSOExec command to execute the bind rexx script
        def bindLogFile = new File("${properties.workDir}/${member}_bind.log")
// ------------------------------------------------------------------------------
//  def bind = new TSOExec().file(file).command("exec '$rexxScript'").options("'$member'")
//                         .confDir(confDir)
//                         .logFile(bindLogFile)
//  bind.dd(new DDStatement().name("CMDSCP").dsn(cmdscp).options("shr"))
// ------------------------------------------------------------------------------
 //  added as bypass by Regi given by Dan -March 24
 //* From Dan: in the beta the method is called TSOExec.toolkitDir.
//* We changed the name in the GA because we really want the toolkit sub-directory called 'conf' i.e. the directory where runIspf.sh is.
//* The conf directory contains files that may need to be modified and since SMPE usually installs into read only locations,
//* customers may end up having the conf directory installed to another location.
//   def bind = new TSOExec().command("exec '$rexxScript'").options("'$member'")
//                          .toolkitDir(confDir)
//                          .logFile(bindLogFile)
//  bind.setFile(file)
//  bind.dd(new DDStatement().name("CMDSCP").dsn(cmdscp).options("shr"))
// ------------------------------------------------------------------------------
//* The GA version is below:
 //  added as bypass by Regi given by Dan -March 23
       def bind = new TSOExec().command("exec '$rexxScript'").options("'$member'")
                         .confDir(confDir)
                         .logFile(bindLogFile)
       bind.setFile(file)
       bind.dd(new DDStatement().name("CMDSCP").dsn(cmdscp).options("shr"))
// ------------------------------------------------------------------------------
//      execute the bind rexx script and update the build result
       rc = bind.execute()
        tools.updateBuildResult(file:"$file", rc:rc, maxRC:0, log:bindLogFile)
     }
//      end of BIND invocation

job.stop()
