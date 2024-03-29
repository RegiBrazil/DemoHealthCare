//BZUCOLL  JOB ,NOTIFY=&SYSUID
//*
//* see https:
//*www.ibm.com/docs/en/zvtp/2.0?topic=cases-setting-up-using-vtp-viewer
//*        JCLLIB ORDER=BZU.#CUST.PROCLIB
//*         INCLUDE MEMBER=BZUINCL
//*         SET PLAYBACK=BZU100.ZUNIT.PLAYBACK
//*         SET JSON=BZU100.HCAZ.PB.JSON
//         SET BZU='BZU100'
//         SET PLAYBACK=BZU100.ZUNIT.PLAYBACK.DEMO
//         SET TESTNAME=ZTRIAL
//*
//JSON     EXEC PGM=BZUPLAY,COND=(4,LT),REGION=0M,
//            PARM='RUN=BZUTCP'
//STEPLIB  DD DISP=SHR,DSN=&BZU..SBZULOAD
//BZUMETA  DD DISP=SHR,DSN=BZU100.ZUNIT.METADATA.OK
//*BZUJSON  DD DISP=(NEW,CATLG),DSN=&JSON,SPACE=(TRK,(15,15),RLSE),
//*            DCB=(RECFM=FB,LRECL=80,BLKSIZE=0),UNIT=SYSALLDA,
//*            VOL=SER=USER04
//BZUJSON DD PATH='/u/ibmuser/vtpviewer/&TESTNAME..vtptc',
//           PATHDISP=(KEEP,DELETE),
//           PATHOPTS=(OCREAT,ORDWR),
//           PATHMODE=(SIRUSR,SIWUSR),
//           FILEDATA=TEXT
//BZUMSG  DD SYSOUT=*
//*