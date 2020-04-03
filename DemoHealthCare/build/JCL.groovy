import com.ibm.dbb.repository.*
import com.ibm.dbb.dependency.*
import com.ibm.dbb.build.*

// Create by REGI as experiment.. COPY JCL members to PDS - No processing

// receive passed arguments
def file = args[0]
println("* Regi Building $file using ${this.class.getName()}.groovy script")

// define local properties
def properties = BuildProperties.getInstance()
def JCLPDS = "${properties.hlq}.JCL"
def member = CopyToPDS.createMemberName(file)

// create a reference to the Tools.groovy utility script
File scriptFile = new File("$properties.sourceDir/DemoHealthCare/build/Tools.groovy")
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(scriptFile)
GroovyObject tools = (GroovyObject) groovyClass.newInstance()

// copy JCL to PDS
println("Copying ${properties.sourceDir}/$file to $JCLPDS($member)")
new CopyToPDS().file(new File("${properties.sourceDir}/$file")).dataset(JCLPDS).member(member).execute()

	