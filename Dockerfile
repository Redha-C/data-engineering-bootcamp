# 🧱 Use a slim Python image as the base
FROM python:3.11-slim

# 📁 Set working directory inside the container
WORKDIR /usr/app/dbt

# 📦 Install dependencies
# Copy the requirements first to leverage Docker caching
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 📂 Copy dbt project folders
COPY macros macros
COPY models models
COPY seeds seeds
COPY snapshots snapshots
COPY tests tests

# ⚙️ Copy dbt config files
COPY dbt_project.yml dbt_project.yml
COPY packages.yml packages.yml
COPY profiles.yml profiles.yml

# 🧹 Copy SQLFluff configuration files for linting support
COPY .sqlfluff .sqlfluff
COPY .sqlfluffignore .sqlfluffignore

# 📥 Install dbt packages from packages.yml
RUN dbt deps

# ❌ No CMD defined — Airflow as the orchestrator will handle execution
