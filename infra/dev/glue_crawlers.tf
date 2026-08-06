resource "aws_glue_crawler" "bronze" {
  name          = "fiap-datalake-tech-crawler"
  role          = aws_iam_role.glue_role.name
  database_name = aws_glue_catalog_database.datalake.name
  table_prefix  = "fiap-datalake-glue-"

  s3_target {
    path = "s3://${aws_s3_bucket.datalake.bucket}/bronze"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  lineage_configuration {
    crawler_lineage_settings = "DISABLE"
  }

  configuration = "{\"Version\":1.0,\"CreatePartitionIndex\":true}"
}

resource "aws_glue_crawler" "silver" {
  name          = "silver-crawler"
  role          = aws_iam_role.glue_role.name
  database_name = aws_glue_catalog_database.datalake.name

  s3_target {
    path = "s3://${aws_s3_bucket.datalake.bucket}/silver/"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  lineage_configuration {
    crawler_lineage_settings = "DISABLE"
  }

  configuration = "{\"Version\":1.0,\"CreatePartitionIndex\":true}"
}

resource "aws_glue_crawler" "gold" {
  name          = "gold-crawler"
  role          = aws_iam_role.glue_role.name
  database_name = aws_glue_catalog_database.datalake.name

  s3_target {
    path = "s3://${aws_s3_bucket.datalake.bucket}/gold/"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }

  lineage_configuration {
    crawler_lineage_settings = "DISABLE"
  }

  configuration = "{\"Version\":1.0,\"CreatePartitionIndex\":true}"
}
