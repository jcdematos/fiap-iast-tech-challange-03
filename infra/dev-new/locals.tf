locals {
  layers = ["raw/", "bronze/", "silver/", "gold/"]

  env_suffix = "-${lower(var.environment)}"

  datalake_bukcet       = "${var.project-name}${local.env_suffix}"
  glue_scripts_bucket   = "${var.project-name}-glue-scripts-bucket${local.env_suffix}"
  athena_queries_bucket = "${var.project-name}-athena-queries-bucket${local.env_suffix}"
}
