//HCAZPLCC  JOB ,NOTIFY=&SYSUID,REGION=0M
//*  Run VTP for HCAZ with CC
//*  IBMUSER.ZUNIT.DLAYDBG.EQAUOPTS has the modules to see on CC
//PLAYBK   EXEC PGM=BZUPLAY,PARM='TRACE=N'
//*PLAYBK   EXEC PGM=BZUPLAY,PARM='TRACE=Y'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD
//* below where is the broken Load module
//         DD DISP=SHR,DSN=IBMUSER.GIT.ZMOBILE.LOAD
//         DD DISP=SHR,DSN=EMPOT.ZMOBILE.TEST.LOAD
//         DD DSN=IBMUSER.LOAD,DISP=SHR
//         DD DSN=IBMUSER.GIT.ZMOBILE.LOAD,DISP=SHR
//         DD  DISP=SHR,DSN=EQAE10.SEQAMOD
//*BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK
//BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK.DEMO
//SYSOUT   DD SYSOUT=*       (this keeps LE output in one spool file)
//BZUMSG  DD SYSOUT=*        (optional, can be a VB output dataset)
//CEEOPTS DD *
      TEST(ALL,,PROMPT,DBMDT:*)
      ENVAR("EQA_STARTUP_KEY=CC,,testid=TEST1")
/*
//*    for Debug ONLY delete the below
//*      ENVAR("EQA_STARTUP_KEY=CC")
//