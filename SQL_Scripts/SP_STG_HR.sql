
CREATE OR REPLACE PROCEDURE STG.SP_STG_HR
AS
 V_ETL_DATE VARCHAR2(8);
BEGIN 
  V_ETL_DATE = TO_CHAR(SYSDATE,'YYYYMMDD');  
 
----------------- STG_REGIONS ------------------                         
 SP_STG_TRUNCATE_TABLE('STG_REGIONS');
 
 INSERT INTO STG.STG_REGIONS(REGION_ID,
                             REGION_NAME,
                             ETL_DATE)
 SELECT R.REGION_ID,
        R.REGION_NAME,
        V_ETL_DATE
 FROM HR.REGIONS R;

----------------- STG_COUNTRIES ----------------
                             
 STG.SP_STG_TRUNCATE_TABLE('STG.STG_COUNTRIES');
 
 INSERT INTO STG.STG_COUNTRIES(COUNTRY_ID,
                               COUNTRY_NAME,
                               REGION_ID,
                               ETL_DATE)
 SELECT C.COUNTRY_ID,
        C.COUNTRY_NAME,
        C.REGION_ID,
        V_ETL_DATE
 FROM HR.COUNTRIES C;

----------------- STG.STG_DEPARTMENTS------------------                           
 STG.SP_STG_TRUNCATE_TABLE('STG.STG_DEPARTMENTS');

 INSERT INTO STG.STG_DEPARTMENTS(DEPARTMENT_ID,
                                 DEPARTMENT_NAME,
                                 MANAGER_ID,
                                 LOCATION_ID,
                                 ETL_DATE)
 SELECT D.DEPARTMENT_ID,
        D.DEPARTMENT_NAME,
        D.MANAGER_ID,
        D.LOCATION_ID,
        V_ETL_DATE
 FROM HR.DEPARTMENTS D;
------------------ STG.STG_LOCATIONS --------------                           
 STG.SP_STG_TRUNCATE_TABLE('STG.STG_LOCATIONS');

 INSERT INTO STG.STG_LOCATIONS(LOCATION_ID,
                               STREET_ADDRESS,
                               POSTAL_CODE,
                               CITY,
                               STATE_PROVINCE,
                               COUNTRY_ID,
                               ETL_DATE)
 SELECT L.LOCATION_ID,
        L.STREET_ADDRESS,
        L.POSTAL_CODE,
        L.CITY,
        L.STATE_PROVINCE,
        L.COUNTRY_ID,
        V_ETL_DATE
 FROM HR.LOCATIONS L;
-------------------------------------------------------

 COMMIT;

END SP_STG_HR;
