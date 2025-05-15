output "cnpg_backup_secrets" {
  sensitive = true
  value = {
    access_key = minio_accesskey.cloudnative_pg.access_key
    secret_key = minio_accesskey.cloudnative_pg.secret_key
  }
}