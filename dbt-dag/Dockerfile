FROM astrocrpublic.azurecr.io/runtime:3.0-2

RUN python3 -m venv venv && source venv/bin/activate && \
    pip install --no-cache-dir dbt-snowflake && deactivate