# Xây dựng Data Marts cơ bản với DBT và Snowflake

![Banner](https://img.shields.io/badge/Tech%20Stack-Python%20|%20DBT%20|%20Snowflake%20|%20Docker%20|%20Astro%20Cosmos%20|%20Apache%20Airflow-blue)  
**Hệ điều hành**: Ubuntu  
**Mô tả**: Dự án triển khai Data Warehouse (DWH) sử dụng DBT kết hợp Snowflake, tích hợp pipeline với Apache Airflow thông qua Docker và Astro Cosmos.

---

## 📋 Yêu cầu công nghệ

| Công nghệ          | Phiên bản/Thông tin                     |
|--------------------|-----------------------------------------|
| Hệ điều hành       | Ubuntu                                 |
| Ngôn ngữ lập trình | Python 3.x                             |
| Công cụ DWH        | DBT (dbt-snowflake)                    |
| Database           | Snowflake                              |
| Orchestration      | Apache Airflow (Astro Cosmos)          |
| Containerization   | Docker                                 |

![Banner](https://media.licdn.com/dms/image/v2/D4D10AQGvGTJ0d90WkA/image-shrink_800/image-shrink_800/0/1707302479959?e=2147483647&v=beta&t=gn4nz7vAe8PkwdGp3I3sHQSmBaufD__nn1Hr0sbt2AQ)  

---

## 🛠 Hướng dẫn Setup và Triển khai

### 1. Snowflake ❄️

1. **Tạo tài khoản Snowflake**  
   - Truy cập [Snowflake Signup](https://signup.snowflake.com/) để đăng ký tài khoản.

2. **Cấu hình Snowflake**  
   Đăng nhập và thiết lập các thành phần cần thiết: DATABASE, WAREHOUSE, SCHEMA, ROLE.

   ```sql
   -- Chuyển sang role ACCOUNTADMIN
   USE ROLE ACCOUNTADMIN;

   -- Tạo warehouse
   CREATE WAREHOUSE dbt_wh WITH WAREHOUSE_SIZE = 'X-SMALL';

   -- Tạo database
   CREATE DATABASE dbt_db;

   -- Tạo role cho DBT
   CREATE ROLE dbt_role;

   -- Kiểm tra quyền trên warehouse
   SHOW GRANTS ON WAREHOUSE dbt_wh;

   -- Gán quyền sử dụng warehouse
   GRANT USAGE ON WAREHOUSE dbt_wh TO ROLE dbt_role;

   -- Gán role cho user
   GRANT ROLE dbt_role TO USER tunguyen150599;

   -- Cấp toàn bộ quyền trên database
   GRANT ALL ON DATABASE dbt_db TO ROLE dbt_role;

   -- Chuyển sang role DBT
   USE ROLE dbt_role;

   -- Tạo schema
   CREATE SCHEMA dbt_db.dbt_schema;
   ```

---

### 2. Python và DBT 🐍

1. **Cài đặt Visual Studio Code**  
   - Tải và cài đặt [VS Code](https://code.visualstudio.com/) trên Ubuntu.

2. **Tạo môi trường ảo (venv)**  
   - Tạo thư mục dự án và khởi tạo môi trường ảo:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Cài extension DBT Power User**  
   - Cài đặt [DBT Power User](https://marketplace.visualstudio.com/items?itemName=innoverio.vscode-dbt-power-user) trên VS Code.

4. **Tạo thư mục `.dbt`**  
   - Tạo thư mục `.dbt` tại `$HOME` để lưu trữ cấu hình bảo mật:

   ```bash
   cd $HOME
   mkdir .dbt
   ```

5. **Cài đặt DBT**  
   - Quay lại thư mục dự án và cài đặt `dbt-snowflake`:

   ```bash
   pip install dbt-snowflake
   ```

   - Khởi tạo dự án DBT:

   ```bash
   dbt init
   ```

6. **Cấu hình dự án DBT**  
   - Điền thông tin cấu hình khi chạy `dbt init`:
     - **Project Name**: `my_dbt_project`
     - **Database**: `[1] snowflake`
     - **Account**: `ABC-XYZ` (dạng `ABC-XYZ.snowflakecomputing.com`)
     - **User**: `[Snowflake User]`
     - **Authentication**: `[1] password`
     - **Password**: `[Snowflake Password]`
     - **Role**: `DBT_ROLE`
     - **Warehouse**: `DBT_WH`
     - **Database**: `DBT_DB`
     - **Schema**: `DBT_SCHEMA`
     - **Threads**: `1`

7. **Kiểm tra kết nối**  
   - Chạy lệnh kiểm tra:

   ```bash
   dbt debug
   ```

   - Nếu gặp lỗi, chỉnh sửa file `profiles.yml`:

   ```bash
   cd $HOME/.dbt
   nano profiles.yml
   ```

   - Lưu file: `Ctrl + O`, `Enter`, thoát: `Ctrl + X`.

8. **Cấu hình bổ sung cho DBT**  
   - Chỉnh sửa `dbt_project.yml` để phân vùng dữ liệu:

   ```yaml
   models:
       my_dbt_project:
           staging:
               +materialized: view
               snowflake_warehouse: DBT_WH
           marts:
               +materialized: table
               snowflake_warehouse: DBT_WH
   ```

   - Tạo thư mục `staging` và `marts` trong thư mục `models`.

   - Tạo file `packages.yml` để cài đặt package bổ sung:

   ```yaml
   packages:
     - package: dbt-labs/dbt_utils
       version: 1.1.1
   ```

   - Cài đặt package:

   ```bash
   dbt deps
   ```

9. **Cấu trúc dự án DBT**  
   - **model-paths**: ["models"]  
     - Tạo file `.sql` trong thư mục `models` để định nghĩa bảng. Sử dụng Jinja để tham chiếu bảng ([Tài liệu Jinja](https://docs.getdbt.com/docs/build/jinja-macros)).
     - Chạy toàn bộ model:

     ```bash
     dbt run
     ```

     - Hoặc chạy một file cụ thể:

     ```bash
     dbt run -s ten_file_sql.sql
     ```

   - **analysis-paths**: ["analyses"]  
     - Lưu trữ các phân tích SQL.

   - **test-paths**: ["tests"]  
     - **Generic Test** (file `.yml` trong `models/marts` hoặc `models/staging`):

     ```yaml
     models:
       - name: fct_orders
         columns:
           - name: order_key
             tests:
               - not_null
               - unique
               - relationships:
                   to: ref('stg_tpch_orders')
                   field: order_key
                   severity: warn
           - name: order_status
             tests:
               - accepted_values:
                   values: ['F', 'O', 'P']
     ```

     - **Static Test** (file `.sql` trong `tests`):

     ```sql
     SELECT *
     FROM {{ ref('fct_orders') }} as oi
     WHERE oi.total_discount_amount > 0
     ```

     - Chạy test:

     ```bash
     dbt test
     ```

   - **seed-paths**: ["seeds"]  
     - Lưu trữ file tĩnh (ví dụ: bảng Master CSV).

   - **macro-paths**: ["macros"]  
     - Tạo macro trong file `.sql` ([Tài liệu Macro](https://docs.getdbt.com/docs/build/jinja-macros)):

     ```sql
     {% macro discounted_amount(extended_price, discount_percentage, scale=2) %}
         (-1 * {{ extended_price }} * {{ discount_percentage }})::decimal(16, {{ scale }})
     {% endmacro %}
     ```

   - **snapshot-paths**: ["snapshots"]  
     - Hỗ trợ incremental models.

---

### 3. Docker + Airflow + Astro Cosmos 🐳

1. **Cài đặt Docker**  
   - Tham khảo hướng dẫn tại [Docker Docs](https://docs.docker.com/engine/install/ubuntu/) hoặc [Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04).

2. **Cài đặt Astro CLI**  
   - Chạy lệnh cài đặt:

   ```bash
   curl -sSL https://install.astronomer.io | sudo bash
   astro version
   ```

3. **Tạo thư mục DAGs**  
   - Tạo thư mục riêng cho DAGs:

   ```bash
   cd ../
   mkdir dbt-dag
   cd dbt-dag
   ```

4. **Khởi động Astro**  
   - Tạo file `Dockerfile`:

   ```dockerfile
   FROM astrocrpublic.azurecr.io/runtime:3.0-2

   RUN python3 -m venv venv && source venv/bin/activate && \
       pip install --no-cache-dir dbt-snowflake && deactivate
   ```

   - Tạo file `requirements.txt`:

   ```text
   astronomer-cosmos
   apache-airflow-providers-snowflake
   ```

   - Khởi tạo dự án Astro:

   ```bash
   astro dev init
   ```

   - Astro sẽ tự động kéo image và chạy container, truy cập Airflow tại `localhost:8080`.

5. **Tạo thư mục DBT trong DAGs**  
   - Tạo thư mục `dbt` trong `dags`:

   ```bash
   cd dags
   mkdir dbt
   cd dbt
   ```

6. **Sao chép dự án DBT**  
   - Copy thư mục `my_dbt_project` vào `dags/dbt`.

7. **Tạo DAG đầu tiên**  
   - Tạo file DAG (ví dụ: `dbt_dag.py`) trong thư mục `dags`:

   ```python
   import os
   from datetime import datetime
   from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
   from cosmos.profiles import SnowflakeUserPasswordProfileMapping

   profile_config = ProfileConfig(
       profile_name="default",
       target_name="dev",
       profile_mapping=SnowflakeUserPasswordProfileMapping(
           conn_id="snowflake_conn",
           profile_args={"database": "dbt_db", "schema": "dbt_schema"},
       )
   )

   dbt_snowflake_dag = DbtDag(
       project_config=ProjectConfig("/usr/local/airflow/dags/dbt/my_dbt_project"),
       operator_args={"install_deps": True},
       profile_config=profile_config,
       execution_config=ExecutionConfig(dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/venv/bin/dbt"),
       schedule_interval="@daily",
       start_date=datetime(2023, 9, 10),
       catchup=False,
       dag_id="dbt_dag",
   )
   ```

   - **Lưu ý**: Đảm bảo đường dẫn trong `ProjectConfig` và `dbt_executable_path` khớp với cấu hình `venv`.

---

## 🚀 Bắt đầu

1. Hoàn thành các bước cài đặt Snowflake, DBT, và Airflow theo hướng dẫn.
2. Chạy lệnh `dbt run` để xây dựng các model trong Snowflake.
3. Kích hoạt DAG trong Airflow để tự động hóa pipeline.
4. Theo dõi và kiểm tra kết quả qua giao diện Airflow tại `localhost:8080`.

---

## 📚 Tài liệu tham khảo

- [DBT Documentation](https://docs.getdbt.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [Astro Cosmos Documentation](https://astronomer.io/docs/)
- [Apache Airflow Documentation](https://airflow.apache.org/docs/)

---

## 🙌 Đóng góp

Nếu bạn có ý tưởng cải thiện dự án, vui lòng tạo **Pull Request** hoặc mở **Issue** trên repository!