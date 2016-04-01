--------------------------------------------------------
--  DDL for Type T_COUNTERS_RVALUE
--------------------------------------------------------

  CREATE OR REPLACE TYPE "HARRIAGUE"."T_COUNTERS_RVALUE" AS OBJECT
(
  FECHA DATE,
  GWNAME VARCHAR2(50 BYTE),
  SERVID VARCHAR2(100 BYTE),
  SERVNAME VARCHAR2(100 BYTE),
  CVALUE NUMBER,
  PREV_VALUE NUMBER,
  COUNTER_REAL_VALUE NUMBER
);

/
