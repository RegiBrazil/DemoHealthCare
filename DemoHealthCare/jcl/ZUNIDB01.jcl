//ZUNIDB01 JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M,COND=(16,LT)
//* Action: Run Test Case... for HCIPDB01
//* Source: IBMUSER.DBB.LOAD(THCIPDB0)
//RUNNER EXEC PROC=BZUPPLAY,
// BZUCFG=IBMUSER.ZUNIT.BZUCFG(THCIPDB0),
// BZUCBK=IBMUSER.DBB.LOAD,
// BZULOD=IBMUSER.DBB.LOAD,
//  PARM=('STOP=E,REPORT=XML')
//BZUPLAY DD DUMMY
//BZURPT DD DISP=SHR,
// DSN=IBMUSER.ZUNIT.BZURES(THCIPDB0)