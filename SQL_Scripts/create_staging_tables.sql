create table STG.STG_COUNTRIES
(
  country_id   CHAR(2) not null,
  country_name VARCHAR2(40) not null,
  region_id    NUMBER,
  etl_date     VARCHAR2(8),
  test         VARCHAR2(10),
  test_new_1   NUMBER(8)
);


create table STG.STG_DEPARTMENTS
(
  department_id   NUMBER(4) not null,
  department_name VARCHAR2(30) not null,
  manager_id      NUMBER(6),
  location_id     NUMBER(4),
  etl_date        NUMBER(8)
);

create table STG.STG_EMPLOYEES
(
  employee_id    NUMBER(6) not null,
  first_name     VARCHAR2(20),
  last_name      VARCHAR2(25) not null,
  email          VARCHAR2(25) not null,
  phone_number   VARCHAR2(20),
  hire_date      DATE not null,
  job_id         VARCHAR2(10) not null,
  salary         NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id     NUMBER(6),
  department_id  NUMBER(4),
  etl_date       NUMBER(8)
);

create table STG.STG_LOCATIONS
(
  location_id    NUMBER(4),
  street_address VARCHAR2(40),
  postal_code    VARCHAR2(12),
  city           VARCHAR2(30) not null,
  state_province VARCHAR2(25),
  country_id     CHAR(2),
  etl_date       NUMBER(8)
);

create table STG.STG_REGIONS
(
  region_id   NUMBER not null,
  region_name VARCHAR2(25),
  etl_date    NUMBER(8)
)