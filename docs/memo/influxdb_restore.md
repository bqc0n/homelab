# Restoring InfluxDB Backup
[ここ](https://docs.influxdata.com/influxdb/v2/admin/backup-restore/)に一応こうやってねーみたいなことは書いてあるけど、情報量が少なすぎてハマったのでメモ。

## 基本
### Backup
```shell
influx backup <backup_name> -t <token>
```
これで<backup_name>というディレクトリが作成され、それがバックアップである。
適当に`tar -cf`で圧縮しておく。


### Restore
解凍して、
```shell
influx restore <backup_name>
```
で復元できるはずだが、すでにbucketが存在していると怒られる。
なので、まずbucketを削除してからrestoreする。
```shell
influx bucket delete --name <bucket_name>
influx restore <backup_name>
```
これでうまくいく。