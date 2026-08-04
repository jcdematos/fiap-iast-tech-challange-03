locals {
  layers = ["raw/", "bronze/", "silver/", "gold/"]

  datalake_bukcet     = "${var.project-name}"
  glue_scripts_bucket = "${var.project-name}-glue-scripts-bucket"
  athena_queries_bucket = "${var.project-name}-athena-queries-bucket"
}
