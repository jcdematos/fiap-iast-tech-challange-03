# Terraform TODO / Infra Drift Tracker

Backlog of infra/dev items that still need Terraform coverage, plus tracking of drift between AWS and this codebase.

- [ ] Make it so this can be run under everyone's own AWS account without issue, so we can use it with temporary credits

## Bucket
- [x] Validate all buckets are created using Terraform
  - [ ] Properly tag all buckets
- [x] Athena bucket may not be created on Terraform — verify
- [x] Add `raw/` layer through Terraform

## Network
- [ ] Tag all network components properly

## Glue

- [x] Verify all the jobs below and move to Terraform the ones that are not

| Job | Status |
|---|---|
| bq-bronze-inep-alfabetizacao-meta_alfabetizacao_brasil | no drift |
| bq-bronze-inep-alfabetizacao-meta_alfabetizacao_municipio | no drift |
| bq-bronze-inep-alfabetizacao-meta_alfabetizacao_uf | no drift |
| bq-bronze-inep-alfabetizacao-municipio | no drift |
| bq-bronze-inep-alfabetizacao-uf | no drift |
| bq-bronze-inep-alfabetizacao-alunos-2023-csv | no drift |
| bq-bronze-inep-alfabetizacao-alunos-2024-csv | no drift |
| bq-bronze-inep-alfabetizacao-alunos-2025-csv | no drift |
| bq-silver-inep-alfabetizacao-alunos | no drift |
| bq-silver-inep-alfabetizacao-meta_alfabetizacao_brasil | no drift |
| bq-silver-inep-alfabetizacao-meta_alfabetizacao_municipio | no drift |
| bq-silver-inep-alfabetizacao-meta_alfabetizacao_uf | no drift |
| bq-silver-inep-alfabetizacao-municipio | no drift |
| bq-silver-inep-alfabetizacao-uf | no drift |
| gold-alfabetizacao-municipio | no drift |

15/15 jobs covered — all Glue jobs now have Terraform coverage.

- [ ] Import all crawlers

## Athena
- [ ] Create Athena configuration on Terraform?

## Cloudwatch
- [ ] (nothing tracked yet)

## IAM
- [ ] Create all IAM roles using Terraform
  - [ ] Properly tag them for environment
- [x] `glue-role` (used by all `bq-*`/`gold-*` jobs) now has Terraform coverage in `infra/dev/iam_glue_role.tf`
  - [ ] Still needs to be imported (`tofu import`) before the next apply, otherwise it'll fail with `EntityAlreadyExists`

## Secrets
- [ ] Create all secrets using Terraform

## Monitoring
- [ ] Validate how `glue-job-failure-alerts` is created
