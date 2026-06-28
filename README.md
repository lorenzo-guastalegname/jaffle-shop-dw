# jaffle-shop-dw

LiteFlow data warehouse project - dual-track Git strategy demo.

## Branch structure

```
main  <------- release/YYYY-MM-DD (release manager merge)
                    ^           ^
                    |           |
          integration/ops    integration/project
           (dev -> test)     (devprj -> sit -> uat)
                ^                    ^
                |                    |
          fix/TICK-*           feat/TICK-*
          hotfix/TICK-*        refactor/TICK-*
```

## Environments

| Branch                  | Auto-deploy | Manual gates      |
|-------------------------|-------------|-------------------|
| `integration/ops`       | `dev`       | `test`            |
| `integration/project`   | `devprj`    | `sit` then `uat`  |
| `main`                  | `prod`      | (protected branch)|

## GitHub Secrets required

Go to Settings -> Secrets and variables -> Actions and add:

| Secret                  | Example value                            |
|-------------------------|------------------------------------------|
| `DATABRICKS_HOST`       | `adb-xxxx.azuredatabricks.net`           |
| `DATABRICKS_HTTP_PATH`  | `/sql/1.0/warehouses/xxxx`               |
| `DATABRICKS_TOKEN`      | Personal Access Token or Service Principal |

## GitHub Environments required

Go to Settings -> Environments and create these (add required reviewers to gate promotions):

- `dev`    - no approval required (auto-deploy)
- `test`   - require approval (ops team)
- `devprj` - no approval required (auto-deploy)
- `sit`    - require approval (QA team)
- `uat`    - require approval (business users)
- `prod`   - require approval (release manager)

## Local setup

```bash
pip install liteflow
cp profiles.yml.example ~/.liteflow/profiles.yml
# fill in your workspace host, http_path, and token
liteflow compile
liteflow run --env dev
```

## Working on the ops track (bugfix)

```bash
git checkout integration/ops
git checkout -b fix/TICK-123-my-fix

# make changes to models/...
git add -A
git commit -m "fix(TICK-123): description of fix"
git push origin fix/TICK-123-my-fix
# open PR -> integration/ops
```

CI auto-deploys to `dev` on merge. Approval required to promote to `test`.

## Working on the project track (feature)

```bash
git checkout integration/project
git checkout -b feat/TICK-456-new-model

# add models/...
git add -A
git commit -m "feat(TICK-456): description of feature"
git push origin feat/TICK-456-new-model
# open PR -> integration/project
```

CI auto-deploys to `devprj` on merge. Approvals required for `sit` then `uat`.

## Release process (release manager)

```bash
# 1. Create release branch from main
git checkout main
git pull origin main
git checkout -b release/2026-07-15

# 2. Merge ops track (bugfixes)
git merge integration/ops
# resolve any conflicts, then commit

# 3. Merge project track (features)
git merge integration/project
# resolve conflicts on shared models (e.g. stg_customers.sql), then commit

# 4. Merge to main -> CI auto-deploys prod
git checkout main
git merge release/2026-07-15
git push origin main
git tag v2026-07-15
git push origin v2026-07-15

# 5. IMPORTANT: sync both tracks from main after release
git checkout integration/ops
git merge main
git push origin integration/ops

git checkout integration/project
git merge main
git push origin integration/project
```

## Simulated dual-track conflict in this repo

Both `integration/ops` and `integration/project` modify `models/staging/stg_customers.sql`:

- `integration/ops`     (TICK-042): adds TRIM() on names/email to fix source data bug
- `integration/project` (TICK-101): adds full_name and customer_tier columns for CRM project

When the release manager runs `git merge integration/project` after merging ops, Git will
flag a conflict in `stg_customers.sql`. The resolution combines both changes:
- Keep the TRIM() fix from ops
- Keep the customer_tier logic from project
- Reconcile the full_name expression (ops uses trimmed values, project uses raw)
