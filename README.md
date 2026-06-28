# jaffle-shop-dw

LiteFlow data warehouse project â€” dual-track Git strategy demo.

## Branch structure

```
main  â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â–¶  prod
              â–²                              â–²
         release/YYYY-MM-DD  (release manager)
              â–²                    â–²
       integration/ops      integration/project
       (dev â†’ test)         (devprj â†’ sit â†’ uat)
           â–²                        â–²
      fix/TICK-*             feat/TICK-*
      hotfix/TICK-*          refactor/TICK-*
```

## Environments

| Branch              | Auto-deploy | Manual gates        |
|---------------------|-------------|---------------------|
| `integration/ops`   | `dev`       | `test`              |
| `integration/project` | `devprj`  | `sit` â†’ `uat`       |
| `main`              | `prod`      | â€”                   |

## GitHub secrets required

| Secret                  | Description                             |
|-------------------------|-----------------------------------------|
| `DATABRICKS_HOST`       | e.g. `adb-xxxx.azuredatabricks.net`     |
| `DATABRICKS_HTTP_PATH`  | e.g. `/sql/1.0/warehouses/xxxx`         |
| `DATABRICKS_TOKEN`      | Personal Access Token or Service Principal |

## Local setup

```bash
pip install liteflow
cp profiles.yml.example ~/.liteflow/profiles.yml
# fill in your workspace values
liteflow compile
liteflow run --env dev
```

## Release process

```bash
# 1. Create release branch from main
git checkout main && git checkout -b release/$(date +%Y-%m-%d)

# 2. Merge ops track (bugfixes)
git merge integration/ops

# 3. Merge project track (features) â€” resolve conflicts here
git merge integration/project

# 4. Merge to main â†’ auto-deploys prod
git checkout main && git merge release/$(date +%Y-%m-%d)

# 5. Sync both tracks from main (IMPORTANT)
git checkout integration/ops     && git merge main
git checkout integration/project && git merge main
```
