CREATE OR REPLACE PROCEDURE DW.SP_DIM_HR
AS
 V_ETL_DATE VARCHAR2(8);
BEGIN
  V_ETL_DATE:= TO_CHAR(SYSDATE,'YYYYMMDD');

-------------- DIM_COUNTRIES -----------------
   DELETE DW.DIM_COUNTRIES DC
   WHERE DC.ETL_DATE = V_ETL_DATE;
     
   MERGE INTO DW.DIM_COUNTRIES DC
   USING(
         SELECT C.COUNTRY_ID,
                C.COUNTRY_NAME,
                R.REGION_ID,
                R.REGION_NAME,
                V_ETL_DATE ETL_DATE
          FROM STG.STG_REGIONS R
          INNER JOIN STG.STG_COUNTRIES C ON C.REGION_ID = R.REGION_ID
  )S ON(S.COUNTRY_ID = DC.COUNTRY_ID)
   WHEN MATCHED THEN
   UPDATE 
    SET DC.COUNTRY_NAME = S.COUNTRY_NAME,
        DC.REGION_ID = S.REGION_ID,
        DC.REGION_NAME = S.REGION_NAME,
        DC.ETL_DATE = S.ETL_DATE
     
   WHEN NOT MATCHED THEN 
    INSERT (COUNTRY_ID, COUNTRY_NAME, REGION_ID, REGION_NAME, ETL_DATE)
    VALUES( S.COUNTRY_ID, S.COUNTRY_NAME, S.REGION_ID, S.REGION_NAME, S.ETL_DATE);

-------------- DIM_DEPARTMENTS ------------------
   DELETE DW.DIM_DEPARTMENTS DD
   WHERE DD.ETL_DATE = V_ETL_DATE;
   
   INSERT INTO DW.DIM_DEPARTMENTS(DEPARTMENT_ID,
                                  DEPARTMENT_NAME,
                                  MANAGER_ID,
                                  MANAGER_FIRST_NAME,
                                  MANAGER_LAST_NAME,
                                  LOCATION_ID,
                                  COUNTRY_ID,
                                  COUNTRY_NAME,
                                  STATE_PROVINCE,
                                  CITY,
                                  STREET_ADDRESS,
                                  POSTAL_CODE,
                                  ETL_DATE)
   SELECT 
         D.DEPARTMENT_ID,
         D.DEPARTMENT_NAME,
         D.MANAGER_ID,
         E.FIRST_NAME MANAGER_FIRST_NAME,
         E.LAST_NAME MANAGER_LAST_NAME,
         L.LOCATION_ID,
         L.COUNTRY_ID,
         C.COUNTRY_NAME,
         L.STATE_PROVINCE,
         L.CITY,
         L.STREET_ADDRESS,
         L.POSTAL_CODE,
         V_ETL_DATE etl_date
   FROM STG.STG_DEPARTMENTS D
   LEFT JOIN STG.STG_LOCATIONS L ON L.LOCATION_ID = D.LOCATION_ID
   LEFT JOIN STG.STG_COUNTRIES C ON C.COUNTRY_ID = L.COUNTRY_ID
   LEFT JOIN HR.EMPLOYEES E ON E.EMPLOYEE_ID = D.MANAGER_ID;
   
----------------- OTHER DIM TABLES ----------------------------------

 COMMIT;
 
END SP_DIM_HR;
