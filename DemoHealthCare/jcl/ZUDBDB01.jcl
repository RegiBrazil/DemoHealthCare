//ZUDBDB01   JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M,COND=(16,LT)
//* This JCL will run the test case DB in batch for HCIPDB01
//* It can be submited using DBB from a Jenkins Pipeline
//* See one groovy example of using DBB at the location below:
//*  /var/jenkins/workspace/
//*  /HealtCareAndUCD/HealthCareApp/build/RunZUnitJCLDB01.groovy
//*
//* Action: Run Test Case...
//* Source: IBMUSER.DBB.LOAD(THCIPDB0)
//RUNNER EXEC PROC=BZUPPLAY,
// BZUCFG=IBMUSER.ZUNIT.BZUCFG(THCIPDB0),
// BZUCBK=IBMUSER.DBB.LOAD,
// BZULOD=IBMUSER.DBB.LOAD,
//  PARM=('STOP=E,REPORT=XML')
//CEEOPTS DD *
   TEST(ALL,,PROMPT,DBMDT%IBMUSER:*)
 /*
//* when having the playback file the below must be there
//BZUPLAY DD DISP=SHR,
// DSN=IBMUSER.ZUNIT.PB.HCIPDB01
//*BZUPLAY DD DUMMY
//BZURPT DD DISP=SHR,
// DSN=IBMUSER.ZUNIT.BZURES(THCIPDB0)