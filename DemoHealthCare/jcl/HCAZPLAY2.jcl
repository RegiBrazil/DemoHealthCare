//HCAZPLAY  JOB ,NOTIFY=&SYSUID,REGION=0M
//*  Run WAZI VTP for HCAZ after adding a new field on COMMAREA
//PLAYBK   EXEC PGM=BZUPLAY,PARM='TRACE=N'
//*PLAYBK   EXEC PGM=BZUPLAY,PARM='TRACE=Y'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD
//         DD DISP=SHR,DSN=EMPOT.ZMOBILE.TEST.LOAD
//*BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK
//BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK.DEMO2
//SYSOUT   DD SYSOUT=*       (this keeps LE output in one spool file)
//BZUMSG  DD SYSOUT=*        (optional, can be a VB output dataset)
//