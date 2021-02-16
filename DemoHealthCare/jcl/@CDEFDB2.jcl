//HCZACSD JOB ,'CSD GENERATE',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//*****
//* Modified by Regi Feb 2021 to use on Wazi Developer
// SET HLQ=IBMUSER
// SET CICSHLQ=DFH550.CICS
//***** CSD definitions for zMobile Health Care App
//*****
//CSDDEFS  EXEC PGM=DFHCSDUP,REGION=1M
//STEPLIB  DD DISP=SHR,DSN=&CICSHLQ..SDFHLOAD
//DFHCSD   DD DSN=DFH550.CICS.DFHCSD,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(1024,(100,100))
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
**********************************************************

***** DB2 Attachment
Define DB2Conn(DSNZ)     Group(HCAZMOBL)  DB2ID(DBCG)
       NONtermrel(No)    ResyncMember(No)
       MSGqueue1(CSMT)   StatsQueue(CSMT)
       TCBlimit(400)     ThreadError(Abend)
       AccountRec(Txid)  AuthType(Userid)
       Drollback(Yes)    ThreadLimit(250)

***** DB2 Entry supports 3270 transactions and JSON services
Define DB2Entry(DBCGJSN) Group(HCAZMOBL)      Transid(HC*)
       Authid(IBMUSER)     AccountRec(Txid)
       Plan(HCZPLAN)     ThreadLimit(250)