resource "aws_s3_object" "bq_alunos_2023_script" {
  bucket = aws_s3_bucket.glue_scripts.id
  key    = "jobs/bronze/bq-bronze-inep-alfabetizacao-alunos-2023-csv.py"
  source = "../../glue/bronze/bq-bronze-inep-alfabetizacao-alunos-2023-csv.py"
  etag   = filemd5("../../glue/bronze/bq-bronze-inep-alfabetizacao-alunos-2023-csv.py")
}

resource "aws_glue_job" "bq_alunos_2023" {
  name              = "bq-bronze-inep-alfabetizacao-alunos-2023-csv"
  description       = "Reads alunos from BigQuery br_inep_avaliacao_alfabetizacao into S3 bronze layer"
  role_arn          = aws_iam_role.glue_role.arn
  glue_version      = "5.0"
  max_retries       = 0
  timeout           = 60
  number_of_workers = 2
  worker_type       = "G.1X"
  execution_class   = "STANDARD"

  command {
    script_location = "s3://${aws_s3_bucket.glue_scripts.bucket}/jobs/bronze/bq-bronze-inep-alfabetizacao-alunos-2023-csv.py"
    name            = "glueetl"
    python_version  = "3"
  }

  notification_property {
    notify_delay_after = 3
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--continuous-log-logGroup"          = "/aws-glue/jobs"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--enable-job-insights"              = "true"
    "--conf"                             = "spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    "--table"                            = "alunos_2023"
  }

  execution_property {
    max_concurrent_runs = 1
  }

  tags = {
    "Dataset" = "inep_avaliacao_alfabetizacao"
  }
}
