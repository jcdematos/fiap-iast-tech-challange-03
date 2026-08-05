locals {
  inep_alfabetizacao_silver_tables = toset([
    "alunos",
    "meta_alfabetizacao_brasil",
    "meta_alfabetizacao_municipio",
    "meta_alfabetizacao_uf",
    "municipio",
    "uf",
  ])
}

resource "aws_s3_object" "bq_silver_inep_alfabetizacao_script" {
  for_each = local.inep_alfabetizacao_silver_tables

  bucket = aws_s3_bucket.glue_scripts.id
  key    = "jobs/silver/bq-silver-inep-alfabetizacao-${each.key}.py"
  source = "../../glue/silver/bq-silver-inep-alfabetizacao-${each.key}.py"
  etag   = filemd5("../../glue/silver/bq-silver-inep-alfabetizacao-${each.key}.py")
}

resource "aws_glue_job" "bq_silver_inep_alfabetizacao" {
  for_each = local.inep_alfabetizacao_silver_tables

  name              = "bq-silver-inep-alfabetizacao-${each.key}${local.env_suffix}"
  description       = "Reads all tables from S3 bronze layer into S3 silver layer"
  role_arn          = aws_iam_role.glue_role.arn
  glue_version      = "5.0"
  max_retries       = 0
  timeout           = 60
  number_of_workers = 2
  worker_type       = "G.1X"
  execution_class   = "STANDARD"

  command {
    script_location = "s3://${aws_s3_bucket.glue_scripts.bucket}/jobs/silver/bq-silver-inep-alfabetizacao-${each.key}.py"
    name            = "glueetl"
    python_version  = "3"
  }

  notification_property {
    notify_delay_after = 3
  }

  default_arguments = {
    "--job-language"          = "python"
    "--job-bookmark-option"   = "job-bookmark-disable"
    "--enable-metrics"        = ""
    "--enable-job-insights"   = "true"
    "--conf"                  = "spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    "--TempDir"               = "s3://aws-glue-assets-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}/temporary/"
    "--spark-event-logs-path" = "s3://aws-glue-assets-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}/sparkHistoryLogs/"
    "--ENTIDADE"              = each.key
    "--JOB_NAME"              = "bq-silver-inep-alfabetizacao-${each.key}${local.env_suffix}"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = {
    "Enviroment" = "dev"
    "Layer"      = "silver"
    "ManagedBy"  = "glue"
  }
}
