locals {
  raw_alunos_files = {
    "2023" = "TS_ALUNO_2023.csv"
    "2024" = "TS_ALUNO_2024.csv"
    "2025" = "TS_ALUNO_2025.csv"
  }
}

resource "aws_s3_object" "raw_alunos" {
  for_each = local.raw_alunos_files

  bucket = aws_s3_bucket.datalake.id
  key    = "raw/alunos_${each.key}/${each.value}"
  source = "../../data/raw/alunos_${each.key}/${each.value}"

  # These files are large enough to trigger a multipart upload, whose
  # resulting S3 ETag is not a plain MD5 - use source_hash (Terraform-only
  # bookkeeping) instead of etag to detect local content changes.
  source_hash = filemd5("../../data/raw/alunos_${each.key}/${each.value}")
}
