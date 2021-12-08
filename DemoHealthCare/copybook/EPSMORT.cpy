      ******************************************************************
      * Licensed materials - Property of IBM                           *
      * 5724-T07(C) Copyright IBM Corp. 2018                           *
      * All rights reserved                                            *
      * US Government users restricted rights  -  Use, duplication or  *
      * disclosure restricted by GSA ADP schedule contract with IBM    *
      * Corp.                                                          *
      *                                                                *
      * IBM Developer for z/OS (IDz)                                   *
      * IBM z/OS Automated Unit Testing Framework (zUnit)              *
      * Enterprise COBOL zUnit Test Case Sample EPSMORT.cpy            *
      *                                                                *
      * @since   14.1.5.0                                              *
      * @version 14.1.5.0                                              *
      ******************************************************************
       01 EPMENUI.
          02 FILLER                    PIC X(12).
      *
          02 LITLOANL                  PIC S9(4) COMP.
          02 LITLOANF                  PIC X.
          02 FILLER          REDEFINES LITLOANF.
             03 LITLOANA               PIC X.
          02 FILLER                    PIC X(2).
          02 LITLOANI                  PIC X(23).
      *
          02 EPLOANL                   PIC S9(4) COMP.
          02 EPLOANF                   PIC X.
          02 FILLER          REDEFINES EPLOANF.
             03 EPLOANA                PIC X.
          02 FILLER                    PIC X(2).
          02 EPLOANI                   PIC 9(12).
      *
          02 LITYEARSL                 PIC S9(4) COMP.
          02 LITYEARSF                 PIC X.
          02 FILLER          REDEFINES LITYEARSF.
             03 LITYEARSA              PIC X.
          02 FILLER                    PIC X(2).
          02 LITYEARSI                 PIC X(24).
      *
          02 EPYEARSL                  PIC S9(4) COMP.
          02 EPYEARSF                  PIC X.
          02 FILLER          REDEFINES EPYEARSF.
             03 EPYEARSA               PIC X.
          02 FILLER                    PIC X(2).
          02 EPYEARSI                  PIC 9(2).
      *
          02 EPDIFF1L                  PIC S9(4) COMP.
          02 EPDIFF1F                  PIC X.
          02 FILLER          REDEFINES EPDIFF1F.
             03 EPDIFF1A               PIC X.
          02 FILLER                    PIC X(2).
          02 EPDIFF1I                  PIC X(22).
      *
          02 EPRATEL                   PIC S9(4) COMP.
          02 EPRATEF                   PIC X.
          02 FILLER          REDEFINES EPRATEF.
             03 EPRATEA                PIC X.
          02 FILLER                    PIC X(2).
          02 EPRATEI                   PIC 9(5).
      *
          02 EPDIFF2L                  PIC S9(4) COMP.
          02 EPDIFF2F                  PIC X.
          02 FILLER          REDEFINES EPDIFF2F.
             03 EPDIFF2A               PIC X.
          02 FILLER                    PIC X(2).
          02 EPDIFF2I                  PIC X(22).
      *
          02 EPPAYMNTL                 PIC S9(4) COMP.
          02 EPPAYMNTF                 PIC X.
          02 FILLER          REDEFINES EPPAYMNTF.
             03 EPPAYMNTA              PIC X.
          02 FILLER                    PIC X(2).
          02 EPPAYMNTI                 PIC X(12).
      *
          02 MSGERRL                   PIC S9(4) COMP.
          02 MSGERRF                   PIC X.
          02 FILLER          REDEFINES MSGERRF.
             03 MSGERRA                PIC X.
          02 FILLER                    PIC X(2).
          02 MSGERRI                   PIC X(40).
      * *******************************************
       01 EPMENUO REDEFINES EPMENUI.
          02 FILLER                    PIC X(12).
      *
          02 FILLER                    PIC X(3).
          02 LITLOANC                  PIC X.
          02 LITLOANH                  PIC X.
          02 LITLOANO                  PIC X(23).
      *
          02 FILLER                    PIC X(3).
          02 EPLOANC                   PIC X.
          02 EPLOANH                   PIC X.
          02 EPLOANO                   PIC 9(12).
      *
          02 FILLER                    PIC X(3).
          02 LITYEARSC                 PIC X.
          02 LITYEARSH                 PIC X.
          02 LITYEARSO                 PIC X(24).
      *
          02 FILLER                    PIC X(3).
          02 EPYEARSC                  PIC X.
          02 EPYEARSH                  PIC X.
          02 EPYEARSO                  PIC 9(2).
      *
          02 FILLER                    PIC X(3).
          02 EPDIFF1C                  PIC X.
          02 EPDIFF1H                  PIC X.
          02 EPDIFF1O                  PIC X(22).
      *
          02 FILLER                    PIC X(3).
          02 EPRATEC                   PIC X.
          02 EPRATEH                   PIC X.
          02 EPRATEO                   PIC 9(5).
      *
          02 FILLER                    PIC X(3).
          02 EPDIFF2C                  PIC X.
          02 EPDIFF2H                  PIC X.
          02 EPDIFF2O                  PIC X(22).
      *
          02 FILLER                    PIC X(3).
          02 EPPAYMNTC                 PIC X.
          02 EPPAYMNTH                 PIC X.
          02 EPPAYMNTO                 PIC X(12).
      *
          02 FILLER                    PIC X(3).
          02 MSGERRC                   PIC X.
          02 MSGERRH                   PIC X.
          02 MSGERRO                   PIC X(40).