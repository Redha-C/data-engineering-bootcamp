# Data Engineering Bootcamp

This project allows to acquire necessary skills for data engineering in the context of the modern data stack.

It’s designed to help you master the modern data stack through practical, end-to-end projects.

By working with this repository, you will learn how to:

- Build a modular and scalable data pipeline using dbt
- Implement a full CI/CD pipeline to test and deploy your code
- Deploy your project to Google Cloud Platform (GCP)
- Orchestrate workflows using Apache Airflow

📍 Goal: By the end, you’ll have the skills to design, deploy, and maintain production-grade analytics pipelines — just like in real-world data teams.

# 🧰 Tech Stack
- dbt Core (transforms, tests, docs)
- BigQuery (warehouse)
- sqlfluff (SQL linting)
- Airflow (orchestration) – see airflow/
- GitHub Actions (CI on PRs, optional CD)
- Docker (containerize & ship) – see Dockerfile

# 📁 Repository Structure
```
.github/            # CI/CD workflows (lint/build/test)   
airflow/            # Airflow DAGs & configs
macros/             # dbt macros
models/             # dbt models (staging, marts, etc.)
seeds/              # CSV seeds for dbt
snapshots/          # dbt snapshots (if used)
tests/              # dbt generic & singular tests
dbt_project.yml     # dbt project config
packages.yml        # dbt packages
profiles.yml        # dbt profile for BigQuery
requirements.txt    # Python deps (dbt, sqlfluff, etc.)
Dockerfile          # Container for CI/CD or local runs
````

# 🚀 Quickstart (Local)
1) Clone & create a venv

```
git clone https://github.com/Redha-C/data-engineering-bootcamp.git
cd data-engineering-bootcamp

python3 -m venv .venv               # you can use uv if you want
source .venv/bin/activate           # Windows: .venv\Scripts\activate
pip install -r requirements.txt
````

2) Configure BigQuery credentials
Create a GCP Service Account with at least:

- `BigQuery Data Viewer`, `BigQuery Job User` (and `BigQuery Data Editor` if you’re writing tables)
- If you’ll use seeds/snapshots in GCS, add the relevant Storage roles
- Download the JSON key → save it in the root of the repo

3) Point dbt to the included profile
You can either copy profiles.yml into your dbt home, or point to the repo:

```
# Option A: copy profile
mkdir -p ~/.dbt
cp profiles.yml ~/.dbt/profiles.yml

# Option B: use repo profile without copying
export DBT_PROFILES_DIR=$(pwd)
```

4) Run dbt
```
dbt deps
dbt debug               # verify connection
dbt build               # builds the entire project
dbt docs generate && dbt docs serve  # open docs locally
```

# 🧪 Linting (sqlfluff)
```
# Check formatting
sqlfluff lint .

# Fix what can be auto-fixed
sqlfluff fix .
```
Tip: keep .sqlfluff and .sqlfluffignore up to date with your conventions.

# 🐙 CI (GitHub Actions)
This repo is set up to:

- Run sqlfluff lint on pull requests
- Run dbt build (compile + run + test) on pull requests
- Deploy to GCP on dev, preprod and prod environments

Look in .github/workflows/ for the exact pipelines.
Typical PR workflow:

- Create a feature branch
- Commit your changes
- Open a PR → CI runs (lint + dbt build)
- Merge once checks pass and approval from the owner

# ⏱ Orchestration (Airflow)
Inside `airflow/`:
- Put your DAG(s) calling dbt build (or dbt run/test separately)


# 🧭 Contributing (for students)
- Follow GitHub Flow: branch → PR → merge once CI passes
- Keep models modular (staging → intermediate → marts)
- Add tests for new models
- Run sqlfluff lint locally before opening a PR
- Update README/docs when adding meaningful features

# 🆘 Troubleshooting
- **dbt can’t connect to BigQuery**

Check DBT_PROFILES_DIR and your profiles.yml values. Ensure the SA has BigQuery roles.

- **sqlfluff fails on dialect**

Confirm the dialect in `.sqlfluff` (e.g., dialect = bigquery).

- **Airflow import errors**

Make sure your Python path and dependencies match requirements.txt. Re-init the Airflow DB if needed.
