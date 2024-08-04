create table DW.DIM_COUNTRIES
(
  country_id   CHAR(2) not null,
  country_name VARCHAR2(40) not null,
  region_id    NUMBER not null,
  region_name  VARCHAR2(25),
  etl_date     NUMBER(8)
);


create table DW.DIM_DEPARTMENTS
(
  department_id      NUMBER(4) not null,
  department_name    VARCHAR2(30),
  manager_id         NUMBER(6),
  manager_first_name VARCHAR2(20),
  manager_last_name  VARCHAR2(25),
  location_id        NUMBER(4),
  country_id         CHAR(2),
  country_name       VARCHAR2(40),
  state_province     VARCHAR2(25),
  city               VARCHAR2(30),
  street_address     VARCHAR2(40),
  postal_code        VARCHAR2(12),
  etl_date           NUMBER(8)
);
