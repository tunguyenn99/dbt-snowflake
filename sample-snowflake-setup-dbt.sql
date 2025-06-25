-- Sử dụng quyền sudo
use role accountadmin;

-- Tạo WH + DB + ROLE 
create warehouse dbt_wh with warehouse_size = 'x-small';
create database dbt_db;
create role dbt_role; 

-- Check Grant quyền WH 
show grants on warehouse dbt_wh

-- Grant quyền usage
grant usage on warehouse dbt_wh to role dbt_role;

-- Grant quyền cho user 
grant role dbt_role to user tunguyen150599;

grant all on database dbt_db to role dbt_role;

-- Switch về role 
use role dbt_role

-- Tạo Schema
create schema dbt_db.dbt_schema