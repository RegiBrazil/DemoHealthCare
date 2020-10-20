//DB2CRE JOB 241901,'DB2 create',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//*
//*
//JOBLIB   DD DSN=DSNB10.SDSNLOAD,DISP=SHR
//*
//********************************************************************
//*   CREATE STORAGE GROUP/DATABASES/TABLESPACES                     *
//********************************************************************
//CREATE  EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
   DSN SYSTEM(DBBG)
   RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
        LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
  CREATE   STOGROUP HCZMSG02 VOLUMES (USER01) VCAT IBMUSER;

  CREATE   DATABASE HCZMSA1 STOGROUP HCZMSG02
           BUFFERPOOL BP1
           CCSID EBCDIC;
  CREATE   TABLESPACE HCZMTS01 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 20000
      SECQTY 5000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP1;
  CREATE   TABLESPACE HCZMTS02 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 20000
      SECQTY 5000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP1;
  CREATE   TABLESPACE HCZMTS03 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 20000
      SECQTY 5000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP1;
  CREATE   TABLESPACE HCZMTS04 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 40000
      SECQTY 12000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP1;
  CREATE   TABLESPACE HCZMTS05 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 20000
      SECQTY 5000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP32K;
  CREATE   TABLESPACE HCZMTS06 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 40000
      SECQTY 12000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP32K;
  CREATE   TABLESPACE HCZMTS07 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 40000
      SECQTY 12000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP32K;
  CREATE   TABLESPACE HCZMTS08 IN HCZMSA1
    USING STOGROUP HCZMSG02
      PRIQTY 40000
      SECQTY 12000
      ERASE  NO
    CLOSE NO
    CCSID EBCDIC
    BUFFERPOOL BP32K;
/*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE TABLES AND INDEXES
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE patient TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//*
//CRTABS1  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.patient (
     patientId      INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY
                     (START WITH 0000005, INCREMENT BY 1, CACHE 20),
     userName       CHAR(10) NOT NULL,
     firstName      CHAR(20),
     lastName       CHAR(20),
     dateOfBirth    DATE,
     insCardNumber  CHAR(10),
     address        CHAR(20),
     city           CHAR(20),
     postcode       CHAR(10),
     phonemobile    Char(20),
     emailaddress   Char(50),
   PRIMARY KEY(patientId))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS01;

CREATE UNIQUE INDEX HCZMSA1.iPatient
   ON HCZMSA1.patient (patientId) CLUSTER
   COPY YES ;

CREATE TABLE HCZMSA1.user (
     patientId       INTEGER NOT NULL,
     userName        CHAR(10) NOT NULL,
     userPassword    CHAR(32),
   PRIMARY KEY(userName),
   FOREIGN KEY(patientId)
          REFERENCES HCZMSA1.patient (patientId)
          ON DELETE CASCADE)
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS01;

CREATE UNIQUE INDEX HCZMSA1.iUser
   ON HCZMSA1.user (userName) CLUSTER
   COPY YES ;


//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE medication  TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//CRTABS2  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.medication (
     medicationId     INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY
                       (START WITH 1000005, INCREMENT BY 1, CACHE 20),
     patientId      INTEGER NOT NULL,
     drugName       CHAR(50),
     strength       CHAR(20),
     amount         SMALLINT,
     route          CHAR(20),
     frequency      CHAR(20),
     identifier     CHAR(20),
     type           CHAR(2),
   PRIMARY KEY(medicationId),
   FOREIGN KEY(patientId)
          REFERENCES HCZMSA1.patient (patientId)
          ON DELETE CASCADE)
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS02;

CREATE UNIQUE INDEX HCZMSA1.iMedication
   ON HCZMSA1.medication (medicationId) CLUSTER
   COPY YES ;
CREATE INDEX HCZMSA1.iMedication2
   ON HCZMSA1.medication (patientId)
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE meditation  TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//CRTABS3  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.meditation (
     meditationId     INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY
                       (START WITH 2000002, INCREMENT BY 1, CACHE 20),
     patientId      INTEGER NOT NULL,
     name           CHAR(50),
     type           CHAR(20),
     relief         CHAR(20),
     posture        CHAR(20),
     frequency      CHAR(20),
   PRIMARY KEY(meditationId),
   FOREIGN KEY(patientId)
          REFERENCES HCZMSA1.patient (patientId)
          ON DELETE CASCADE)
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS03;

CREATE UNIQUE INDEX HCZMSA1.iMeditation
   ON HCZMSA1.meditation (meditationId) CLUSTER
   COPY YES ;
CREATE INDEX HCZMSA1.iMeditation2
   ON HCZMSA1.meditation (patientId)
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE prescription  TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//CRTABS4  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.prescription (
     prescriptionId INTEGER NOT NULL,
     patientId      INTEGER NOT NULL,
     pDateTime      TIMESTAMP NOT NULL,
     taken          CHAR(1),
   PRIMARY KEY(patientId, prescriptionId, pDateTime))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS04;

CREATE UNIQUE INDEX HCZMSA1.iPrescription
   ON HCZMSA1.prescription
      (patientId, prescriptionId, pDateTime) CLUSTER
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE threshold TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//*
//CRTABS5  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.threshold (
     patientId      INTEGER NOT NULL,
     heartRate      SMALLINT,
     bloodPressure  CHAR(10),
   PRIMARY KEY(patientId))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS05;

CREATE UNIQUE INDEX HCZMSA1.iThreshold
   ON HCZMSA1.threshold (patientId) CLUSTER
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE heartrate TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//*
//CRTABS6  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.heartrate (
     patientId      INTEGER NOT NULL,
     hrDateTime     TIMESTAMP NOT NULL,
     heartRate      SMALLINT,
   PRIMARY KEY(patientId, hrDateTime))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS06;

CREATE UNIQUE INDEX HCZMSA1.iHeartrate
   ON HCZMSA1.heartrate (patientId, hrDateTime) CLUSTER
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE bloodpressure TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//*
//CRTABS7  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.bloodpressure (
     patientId      INTEGER NOT NULL,
     bpDateTime     TIMESTAMP NOT NULL,
     bloodPressure  CHAR(10),
   PRIMARY KEY(patientId, bpDateTime))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS07;

CREATE UNIQUE INDEX HCZMSA1.iBloodpressure
   ON HCZMSA1.bloodpressure (patientId, bpDateTime) CLUSTER
   COPY YES ;

//*
//* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//*  CREATE session TABLE
//* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//*
//CRTABS8  EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
CREATE TABLE HCZMSA1.session (
     patientId      INTEGER NOT NULL,
     sessionStart   TIMESTAMP NOT NULL,
     sessionEnd     TIMESTAMP NOT NULL,
     medAvg         DOUBLE,
     attnAvg        DOUBLE,
     blinkAvg       DOUBLE,
     luxAvg         DOUBLE,
     latitudeStart  VARCHAR(15),
     longitudeStart VARCHAR(15),
     soundAvg       DOUBLE,
     deltaAvg       DOUBLE,
     thetaAvg       DOUBLE,
     lowAlphaAvg    DOUBLE,
     highAlphaAvg   DOUBLE,
     lowBetaAvg     DOUBLE,
     highBetaAvg    DOUBLE,
     lowGammaAvg    DOUBLE,
     midGammaAvg    DOUBLE,
     notes           VARCHAR(255),
     csvURL         VARCHAR(255),
   PRIMARY KEY(patientId, sessionStart, sessionEnd))
   CCSID EBCDIC
   IN HCZMSA1.HCZMTS08;

CREATE UNIQUE INDEX HCZMSA1.iSession
   ON HCZMSA1.session (patientId, sessionStart, sessionEnd) CLUSTER
   COPY YES ;

//*
//CRGRACC EXEC PGM=IKJEFT01,DYNAMNBR=20 ,COND=(4,LT)
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;
  GRANT DBADM ON DATABASE HCZMSA1        TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS01 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS02 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS03 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS04 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS05 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS06 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS07 TO PUBLIC;
  GRANT USE OF TABLESPACE HCZMSA1.HCZMTS08 TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.patient       TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.medication    TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.meditation    TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.prescription  TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.threshold     TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.heartrate     TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.bloodpressure TO PUBLIC;
  GRANT ALL PRIVILEGES ON TABLE HCZMSA1.session       TO PUBLIC;
/*
//*
//********************************************************************
//INSERT  EXEC PGM=IKJEFT01,DYNAMNBR=20
//*STEPLIB  DD DSN=DB2.V10R1M0.SDSNLOAD,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBBG)
 RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA11) -
      LIB('DSNB10.DBBG.RUNLIB.LOAD')
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  SET CURRENT SQLID='IBMUSER' ;

  Insert Into HCZMSA1.patient (
     patientId                                      ,
     userName                                       ,
     firstName                                      ,
     lastName                                       ,
     dateOfBirth                                    ,
     insCardNumber                                  ,
     address                                        ,
     city                                           ,
     postcode                                       ,
     phonemobile                                    ,
     emailaddress)
         Values (
    0000001                                         ,
    'ralphd'                                        ,
    'Ralph'                                         ,
    'DAlmeida'                                      ,
    '1980-07-11'                                    ,
    '9627811234'                                    ,
    '34 Main Street'                                ,
    'Toronto'                                       ,
    'M5H 1T1'                                       ,
    '077-123-9987'                                  ,
    'RalphD@ibm.com');

  Insert Into HCZMSA1.user (
     patientId                                      ,
     userName                                       ,
     userPassword)
         Values (
    0000001                                         ,
    'ralphd'                                        ,
    'ralphd');

  Insert Into HCZMSA1.patient (
     patientId                                      ,
     userName                                       ,
     firstName                                      ,
     lastName                                       ,
     dateOfBirth                                    ,
     insCardNumber                                  ,
     address                                        ,
     city                                           ,
     postcode                                       ,
     phonemobile                                    ,
     emailaddress)
         Values (
    0000002                                         ,
    'johns'                                         ,
    'John'                                          ,
    'Smith'                                         ,
    '1965-09-30'                                    ,
    '1127811234'                                    ,
    '2 Smith Street'                                ,
    'New York'                                      ,
    '12345'                                         ,
    '001-911-9113'                                  ,
    'JohnSmith@email.com');

  Insert Into HCZMSA1.user (
     patientId                                      ,
     userName                                       ,
     userPassword)
         Values (
    0000002                                         ,
    'johns'                                         ,
    'johns');

  Insert Into HCZMSA1.patient (
     patientId                                      ,
     userName                                       ,
     firstName                                      ,
     lastName                                       ,
     dateOfBirth                                    ,
     insCardNumber                                  ,
     address                                        ,
     city                                           ,
     postcode                                       ,
     phonemobile                                    ,
     emailaddress)
         Values (
    0000003                                         ,
    'johnn'                                         ,
    'John'                                          ,
    'Noakes'                                        ,
    '1934-03-06'                                    ,
    '2714323455'                                    ,
    '70 Bellevue Ave'                               ,
    'Newport'                                       ,
    'HX116BP'                                       ,
    '09008 329855'                                  ,
    'Noaksey@beebhouse.com');

  Insert Into HCZMSA1.user (
     patientId                                      ,
     userName                                       ,
     userPassword)
         Values (
    0000003                                         ,
    'johnn'                                         ,
    'johnn');

  Insert Into HCZMSA1.patient (
     patientId                                      ,
     userName                                       ,
     firstName                                      ,
     lastName                                       ,
     dateOfBirth                                    ,
     insCardNumber                                  ,
     address                                        ,
     city                                           ,
     postcode                                       ,
     phonemobile                                    ,
     emailaddress)
         Values (
    0000004                                         ,
    'tomo'                                          ,
    'Tom'                                           ,
    'Otto'                                          ,
    '1960-12-12'                                    ,
    '1234567891'                                    ,
    '43 Marvel Ave'                                 ,
    'Gotham'                                        ,
    '98273'                                         ,
    '8884266840'                                    ,
    'tomo@me.com');

  Insert Into HCZMSA1.user (
     patientId                                      ,
     userName                                       ,
     userPassword)
         Values (
    0000004                                         ,
    'tomo'                                          ,
    'tomo');

  Insert Into HCZMSA1.medication (
     medicationId                                   ,
     patientId                                      ,
     drugName                                       ,
     strength                                       ,
     amount                                         ,
     route                                          ,
     frequency                                      ,
     identifier                                     ,
     type)
         Values (
    1000001                                         ,
    0000001                                         ,
    'Metoprolol'                                    ,
    '100 mg'                                        ,
    1                                               ,
    'oral route'                                    ,
    '2'                                             ,
    'redtablet'                                     ,
    'bp');

  Insert Into HCZMSA1.medication (
     medicationId                                   ,
     patientId                                      ,
     drugName                                       ,
     strength                                       ,
     amount                                         ,
     route                                          ,
     frequency                                      ,
     identifier                                     ,
     type)
         Values (
    1000002                                         ,
    0000001                                         ,
    'ACE inhibitors'                                ,
    '5 mg'                                          ,
    1                                               ,
    'oral route'                                    ,
    '2'                                             ,
    'bluecapsule'                                   ,
    'hr');

  Insert Into HCZMSA1.medication (
     medicationId                                   ,
     patientId                                      ,
     drugName                                       ,
     strength                                       ,
     amount                                         ,
     route                                          ,
     frequency                                      ,
     identifier                                     ,
     type)
         Values (
    1000003                                         ,
    0000001                                         ,
    'Vitamin D'                                     ,
    '1000 IU'                                       ,
    1                                               ,
    'oral route'                                    ,
    '1'                                             ,
    'yellowcapsule'                                 ,
    'na');

  Insert Into HCZMSA1.meditation (
     meditationId                                   ,
     patientId                                      ,
     name                                           ,
     type                                           ,
     relief                                         ,
     posture                                        ,
     frequency)
         Values (
    2000001                                         ,
    0000001                                         ,
    'Adho Mukha Savasana'                           ,
    'Yoga'                                          ,
    'back pain'                                     ,
    'downward dog'                                  ,
    'every 24 hour' );

  Insert Into HCZMSA1.prescription (
     patientId                                      ,
     prescriptionId                                 ,
     pDateTime                                      ,
     taken)
         Values (
    0000001                                         ,
    1000001                                         ,
    '2014-09-22-12.13.01.610208'                    ,
    'Y' );

  Insert Into HCZMSA1.threshold (
     patientId                                      ,
     heartrate                                      ,
     bloodpressure)
         Values (
    0000001                                         ,
    80                                              ,
    '136/90' );

  Insert Into HCZMSA1.threshold (
     patientId                                      ,
     heartrate                                      ,
     bloodpressure)
         Values (
    0000002                                         ,
    90                                              ,
    '130/88' );

  Insert Into HCZMSA1.threshold (
     patientId                                      ,
     heartrate                                      ,
     bloodpressure)
         Values (
    0000003                                         ,
    88                                              ,
    '128/89' );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000001                                         ,
    '2014-09-22-08.03.38.610208'                    ,
    60 );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000001                                         ,
    '2014-09-22-11.33.41.610208'                    ,
    58 );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000001                                        ,
    '2014-09-22-12.13.01.610208'                    ,
    55 );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000002                                         ,
    '2014-06-11-10.22.38.610208'                    ,
    52 );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000002                                         ,
    '2014-08-22-11.33.41.610208'                    ,
    57 );

  Insert Into HCZMSA1.heartrate (
     patientId                                      ,
     hrdatetime                                     ,
     heartrate)
         Values (
    0000002                                         ,
    '2014-07-24-07.03.16.610208'                    ,
    61 );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000001                                         ,
    '2014-09-22-08.03.38.610208'                    ,
    '136/88' );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000001                                         ,
    '2014-09-22-11.33.41.610208'                    ,
    '124/92' );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000001                                         ,
    '2014-09-22-12.13.01.610208'                    ,
    '120/80' );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000002                                         ,
    '2014-06-11-10.22.38.610208'                    ,
    '122/81' );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000002                                         ,
    '2014-08-22-11.33.41.610208'                    ,
    '121/82' );

  Insert Into HCZMSA1.bloodpressure (
     patientId                                      ,
     bpdatetime                                     ,
     bloodpressure)
         Values (
    0000002                                         ,
    '2014-07-24-07.03.16.610208'                    ,
    '110/85' );