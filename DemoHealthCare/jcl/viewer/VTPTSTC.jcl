//VTPTSTC JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//*//***************************************************************
//*  From Joe
//* Covert into format for VTP Viewer
//******************************************************************
//* SET JIRAID=?
// SET TESTNAME=ZJOE
// SET SEARCH=BZU100.ZUNIT.PLAYBACK.DEMO
// SET DSNMETA=BZU100.ZUNIT.METADATA.OK
//* SET DSNJSON=?
//*
//STEP001 EXEC PGM=IEFBR14
//BZUMETA DD DSN=&DSNMETA,
//           DISP=(MOD,DELETE),SPACE=(TRK,1)
//*BZUJSON DD DSN=&DSNMETA,
//*           DISP=(MOD,DELETE),SPACE=(TRK,1)
//*
//STEP002 EXEC PGM=BZUPLAY,COND=(4,LT),REGION=0M,
// PARM='RUN=BZUMETA,SEARCH=&SEARCH'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD
//BZUMETA DD DSN=&DSNMETA,
//           DISP=(NEW,CATLG),SPACE=(TRK,(100,50)),
//           DCB=(BLKSIZE=8196,LRECL=8192,RECFM=VB)
//BZUMSG  DD SYSOUT=*
//*
//CPYJSON EXEC PGM=BZUPLAY,COND=(4,LT),REGION=0M,
// PARM='RUN=BZUTCP'
//STEPLIB  DD DISP=SHR,DSN=BZU100.SBZULOAD      Test Runner common
//BZUMETA DD DISP=SHR,DSN=&DSNMETA
//*//BZUJSON DD DISP=(NEW,CATLG),DSN=&DSNJSON,
//*//           SPACE=(TRK,(10,5)),UNIT=SYSDA,
//*//           DCB=(BLKSIZE=80,LRECL=80,RECFM=FB)
//BZUJSON DD PATH='/u/ibmuser/vtpviewer/&TESTNAME..vtptc',
//           PATHDISP=(KEEP,DELETE),
//           PATHOPTS=(OCREAT,ORDWR),
//           PATHMODE=(SIRUSR,SIWUSR),
//           FILEDATA=TEXT
//BZUMSG  DD SYSOUT=*