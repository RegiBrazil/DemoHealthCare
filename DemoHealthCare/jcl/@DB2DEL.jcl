//HCZMDB2 JOB ,'DB2 DELETE',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//JOBLIB   DD DSN=DSNC10.SDSNLOAD,DISP=SHR
//* Modified by Regi Feb 2021 to fit on wazi Developer
//********************************************************************
//*   CREATE STORAGE GROUP/DATABASES/TABLESPACES                     *
//********************************************************************
//DELETE  EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
   DSN SYSTEM(DBCG)
   RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA12) -
        LIB('DSNC10.DBCG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
    DROP     TABLE      HCZMSA1.patient;
    DROP     TABLE      HCZMSA1.user;
    DROP     TABLE      HCZMSA1.medication;
    DROP     TABLE      HCZMSA1.meditation;
    DROP     TABLE      HCZMSA1.prescription;
    DROP     TABLE      HCZMSA1.threshold;
    DROP     TABLE      HCZMSA1.heartrate;
    DROP     TABLE      HCZMSA1.bloodpressure;
    DROP     TABLE      HCZMSA1.session;
    DROP     TABLESPACE HCZMSA1.HCZMTS01;
    DROP     TABLESPACE HCZMSA1.HCZMTS02;
    DROP     TABLESPACE HCZMSA1.HCZMTS03;
    DROP     TABLESPACE HCZMSA1.HCZMTS04;
    DROP     TABLESPACE HCZMSA1.HCZMTS05;
    DROP     TABLESPACE HCZMSA1.HCZMTS06;
    DROP     TABLESPACE HCZMSA1.HCZMTS07;
    DROP     TABLESPACE HCZMSA1.HCZMTS08;
    commit;
    DROP     DATABASE   HCZMSA1;
    commit;
    DROP     STOGROUP   HCZMSG02;
/*