CREATE OR REPLACE PROCEDURE STG.SP_STG_TRUNCATE_TABLE(V_TABLE_NAME IN VARCHAR2)
AS
BEGIN
 EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME ; 
END SP_STG_TRUNCATE_TABLE;