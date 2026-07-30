resource "aws_s3_object" "gold_alfabetizacao_municipio_script" {
  bucket = "aws-glue-assets-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  key    = "scripts/gold-alfabetizacao-municipio.py"
  source = "../../glue/gold/gold-alfabetizacao-municipio.py"
  etag   = filemd5("../../glue/gold/gold-alfabetizacao-municipio.py")
}

resource "aws_glue_job" "gold_alfabetizacao_municipio" {
  name              = "gold-alfabetizacao-municipio"
  role_arn          = aws_iam_role.glue_role.arn
  glue_version      = "5.0"
  max_retries       = 0
  timeout           = 480
  number_of_workers = 3
  worker_type       = "G.1X"
  execution_class   = "STANDARD"

  command {
    script_location = "s3://${aws_s3_object.gold_alfabetizacao_municipio_script.bucket}/scripts/gold-alfabetizacao-municipio.py"
    name            = "glueetl"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                = "python"
    "--job-bookmark-option"         = "job-bookmark-disable"
    "--enable-metrics"              = ""
    "--enable-glue-datacatalog"     = ""
    "--enable-spark-ui"             = "true"
    "--enable-job-insights"         = "true"
    "--enable-observability-metrics" = "true"
    "--conf"                        = "spark.eventLog.rolling.enabled=true --conf spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    "--CONF"                        = "spark.eventLog.rolling.enabled=true --conf spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    "--TempDir"                     = "s3://${aws_s3_object.gold_alfabetizacao_municipio_script.bucket}/temporary/"
    "--spark-event-logs-path"       = "s3://${aws_s3_object.gold_alfabetizacao_municipio_script.bucket}/sparkHistoryLogs/"
    "--BUCKET_PRINCIPAL"            = "fiap-datalake-tech"
    "--PASTA_SILVER"                = "silver"
    "--PASTA_GOLD"                  = "gold"
    "--ALUNOS"                      = "alunos"
    "--JOB_NAME"                    = "gold-alfabetizacao-municipio"
  }

  execution_property {
    max_concurrent_runs = 1
  }
}
