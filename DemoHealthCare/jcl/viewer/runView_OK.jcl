//VIEWOK  JOB ,'VTP RUN OK',NOTIFY=&SYSUID,REGION=0M
//*  Run VTP for HCAZ Run OK
//*  BZU100.ZUNIT.PLAYBACK is your play back file (recording)
//*  IBMUSER.GIT.ZMOBILE.LOAD are the Application load modules updated
//*  BZU100.SBZULOAD where VTP is installed
//RUNNER   EXEC PGM=BZUPLAY,PARM='TRACE=Y,STOP=E'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD
//         DD DISP=SHR,DSN=IBMUSER.GIT.ZMOBILE.LOAD
//BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK.DEMO
//BZUMETA DD DSN=BZU100.ZUNIT.METADATA.OK,
//           DISP=(NEW,CATLG),SPACE=(TRK,(20,10)),
//           DCB=(BLKSIZE=8196,LRECL=8192,RECFM=VB),VOL=SER=USER04
//SYSOUT   DD SYSOUT=*
//BZUMSG  DD SYSOUT=*
//CEEOPTS DD *
//
//