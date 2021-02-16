//ALLOC  JOB ,
// MSGCLASS=H,TIME=(,4),REGION=28M,COND=(16,LT)
//*
//*  SETUP JOB FOR IDz  POT - Feb 2021- Regi
//DELIST EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
  DELETE IBMUSER.GIT.ZMOBILE.COBOL
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.BMS
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.COPYLIB
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.OBJ
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.LISTING
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.LOAD
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.JCL
  IF LASTCC = 8 THEN SET MAXCC = 4
  DELETE IBMUSER.GIT.ZMOBILE.DBRM
  IF LASTCC = 8 THEN SET MAXCC = 4
/*
//* *************************************************************
//* STEP: ALLOC
//*  ALLOCATE DATASETS NEEDED FOR ZMOBILE
//* *************************************************************
//*
//ALLOC EXEC PGM=IEFBR14,COND=(4,LT)
//JCLSRC DD DSN=IBMUSER.GIT.ZMOBILE.JCL,DISP=(NEW,CATLG,DELETE),
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20))
//BMSSRC DD DSN=IBMUSER.GIT.ZMOBILE.BMS,DISP=(NEW,CATLG,DELETE),
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20))
//COBSRC DD DSN=IBMUSER.GIT.ZMOBILE.COBOL,DISP=(NEW,CATLG,DELETE),
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20))
//COBCPY DD DSN=IBMUSER.GIT.ZMOBILE.BMS.COPYLIB,
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20)),
//      DISP=(NEW,CATLG,DELETE)
//COBOBJ DD DSN=IBMUSER.GIT.ZMOBILE.OBJ,
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20)),
//      DISP=(NEW,CATLG,DELETE)
//COBLST DD DSN=IBMUSER.GIT.ZMOBILE.LISTING,
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FBA,LRECL=133,BLKSIZE=1330,SPACE=(CYL,(1,1,20)),
//      DISP=(NEW,CATLG,DELETE)
//LOADL DD DSN=IBMUSER.GIT.ZMOBILE.LOAD,RECFM=U,
//      BLKSIZE=6233,SPACE=(CYL,(1,1,20)),
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      DISP=(NEW,CATLG,DELETE)
//LAB802 DD DSN=IBMUSER.GIT.ZMOBILE.DBRM,DISP=(NEW,CATLG,DELETE),
//      DSNTYPE=LIBRARY,VOL=SER=B4USR1,
//      RECFM=FB,LRECL=80,BLKSIZE=8000,SPACE=(CYL,(1,1,20))
//*
//
