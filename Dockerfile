# 🧱 Base image: lightweight Python with pip
FROM python:3.11-slim

# 📁 Set working directory inside the container
WORKDIR /usr/app/dbt

# 📦 Install dependencies
# First, copy requirements.txt to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 📁 Copy necessary dbt project folders and files
COPY macros/ ./macros/
COPY models/ ./models/
COPY seeds/ ./seeds/
COPY snapshots/ ./snapshots/
COPY tests/ ./tests/

# ⚙️ Copy dbt config files
COPY dbt_project.yml .
COPY packages.yml .
COPY profiles.yml .

# 🧹 Copy SQLFluff configuration files for linting support
COPY .sqlfluff .
COPY .sqlfluffignore .

# 📥 Install dbt packages (dependencies from packages.yml)
RUN dbt deps

# 🚀 Run dbt build by default when the container starts
CMD ["dbt", "build"]
