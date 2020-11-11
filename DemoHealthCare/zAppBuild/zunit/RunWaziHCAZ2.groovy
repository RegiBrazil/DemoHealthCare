// %regi - Nov 11 - Submit WAZI JCL with commarea changed


import com.ibm.dbb.build.CopyToHFS
import com.ibm.dbb.build.DBBConstants
import com.ibm.dbb.build.JCLExec
/**************************************************************************
 * Changed Aug 07, 2020 by Regi - Wazi for HCAZ
 * The following sample shows how to use JCLExec API to execute a ZUnit and
 * display the results in the console.
 * This sample assumes that user has setup the ZUnit and a JCL to execute the
 * ZUnit.
 * This sample requires:
 *    1.  The data set contains the JCL.
 *    2.  The data set contains the output of the Wazi result.
 *    Running Wazi:  'IBMUSER.POT.JCL(HCAZPLA2)'
 *    The JCL Job  completed with Max-RC CC 0000
 *********************************************************************************/
/* DBB_CONF must be set for running JCLExec */
def confDir = "/var/dbb/v.1.0.6/conf"
/* The data set contains the ZUnit JCL */
def jclDataset = "IBMUSER.POT.JCL"
/* The WAZI JCL */
def jclMember =  "HCAZPLA2"

println "Running Wazi VTP using JCL '$jclDataset($jclMember)'"

/* Execute the JCL */
def exec = new JCLExec()
int rc = exec.dataset(jclDataset).member(jclMember).confDir(confDir).execute()

 println "**REGI This is the JCL that will be submitted to batch"
 		println(jclMember)
/* Check the return code from the submitted job */
def maxRC = exec.maxRC
if (maxRC == 'CC 0000')
    println "The JCL Job ${exec.submittedJobId} completed successfully"
else
    println "The JCL Job ${exec.submittedJobId} completed with Max-RC: $maxRC"
  // -- Print the job output
  // File jclOut = new File("/var/jenkins/jclout.out")
  // exec.saveOutput(jclOut)
  // println jclOut.text
 // ------------ Print output written at DD NAME SYSOUT
   def output ="SYSOUT"
   File jclOut = new File("/var/jenkins/jclout.out")
   exec.saveOutput(output,jclOut)
   println jclOut.text
   // ----------------------------------------------------------------