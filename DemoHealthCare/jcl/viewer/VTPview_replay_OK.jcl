//VIEWOK JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//*//***************************************************************
//*//***************************************************************
//* Covert into format for VTP Viewer - Run OK
//******************************************************************
//* SET TESTNAME=<JIRA-ID>
// SET TESTNAME=IBMUSER.BZU.#CUST.METADATA.ZTRIAL.OK
//CPYJSON EXEC PGM=BZUPLAY,COND=(4,LT),REGION=0M,
// PARM='RUN=BZURCP'
//STEPLIB  DD DISP=SHR,DSN=BZU.SBZULOAD      Test Runner common
//BZUMETA DD DISP=SHR,DSN=&TESTNAME
//BZUJSON DD PATH='/u/ibmuser/vtp/ZTRIAL.OK.vtptc',
//           PATHDISP=(KEEP,DELETE),
//           PATHOPTS=(OCREAT,ORDWR),
//           PATHMODE=(SIRUSR,SIWUSR),
//           FILEDATA=TEXT
//BZUMSG  DD SYSOUT=*