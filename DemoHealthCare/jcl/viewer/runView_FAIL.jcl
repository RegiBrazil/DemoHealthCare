//VIEWFAIL JOB ,'VTP RUN FAILS',CLASS=A,MSGCLASS=H,
//       REGION=0M
//* Creates Metadata with FAIL run
//*********************************************************************
//* Run VTP testing cics/DB2 programs without CICS or DB2 active
//*********************************************************************
//* EXEC PGM=BZUPLAY,PARM='TRACE=N'   > Less trace data
// EXEC PGM=BZUPLAY,PARM='TRACE=Y'
//STEPLIB  DD  DISP=SHR,DSN=BZU.SBZULOAD
//         DD  DISP=SHR,DSN=BZU.SBZULLEP
//         DD  DISP=SHR,DSN=BZU.SBZULMOD
//         DD  DISP=SHR,DSN=BZU.SBZURESL
//         DD  DISP=SHR,DSN=IBMUSER.DBBZUNIT.LOAD  > Developer updates
//         DD  DISP=SHR,DSN=IBMUSER.CB12V51.LOAD   > Original LOADLIB
//* BZUPLAY  DD  DISP=SHR,DSN=IBMUSER.BZU.#CUST.PLAYBACK
//* Below is a copy of the playback file recorded as lab instructions
//BZUPLAY  DD  DISP=SHR,DSN=IBMUSER.BZU.#CUST.PLAYBACK.COPY
//BZUMETA DD DSN=IBMUSER.BZU.#CUST.METADATA.ZTRIAL.FAIL,
//           DISP=(NEW,CATLG),SPACE=(TRK,(100,50)),
//           DCB=(BLKSIZE=8196,LRECL=8192,RECFM=VB)
//