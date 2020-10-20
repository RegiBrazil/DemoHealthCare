//ZUNITRUN JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M,COND=(16,LT)
//* This JCL will run the test case in batch
//* It can be submited using DBB from a Jenkins Pipeline
//* See one groovy example of using DBB at the location below:
//*  /var/jenkins/workspace/
//*  /HealtCareAndUCD/HealthCareApp/build/RunZUnitJCL.groovy
//*
//* Action: Run Test Case...
//* Source: IBMUSER.POT.LOAD(THCIPDB0)
//RUNNER EXEC PROC=BZUPPLAY,
// BZUCFG=IBMUSER.ZUNIT.BZUCFG(THCIPDB0),
// BZUCBK=IBMUSER.POT.LOAD,
// BZULOD=IBMUSER.POT.LOAD,
//  PARM=('STOP=E,REPORT=XML')
//BZUPLAY DD DISP=SHR,
// DSN=IBMUSER.ZUNIT.PB.HCIPDB01
//BZURPT DD DISP=SHR,
// DSN=IBMUSER.ZUNIT.BZURES(THCIPDB0)