//VTP#HCAZ  JOB ,NOTIFY=&SYSUID,REGION=0M
//*  Run VTP for HCAZ
//*  BZU100.ZUNIT.PLAYBACK is your play back file (recording)
//*  IBMUSER.GIT.ZMOBILE.LOAD are the Application load modules updated
//*  BZU100.SBZULOAD where VTP is installed
//RUNNER   EXEC PGM=BZUPLAY,PARM='TRACE=Y,STOP=E'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD
//         DD DISP=SHR,DSN=IBMUSER.GIT.ZMOBILE.LOAD
//BZUPLAY  DD DISP=SHR,DSN=BZU100.ZUNIT.PLAYBACK.BLOG
//SYSOUT   DD SYSOUT=*
//BZUMSG  DD SYSOUT=*
//CEEOPTS DD *
//
//