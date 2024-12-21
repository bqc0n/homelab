# Restoring InfluxDB Backup
[ここ](https://docs.influxdata.com/influxdb/v2/admin/backup-restore/)に一応こうやってねーみたいなことは書いてあるけど、情報量が少なすぎてハマったのでメモ。

## 基本
```shell
influx backup <backup_name> -t <token>
```
これで<backup_name>というディレクトリが作成され、それがバックアップである。
適当に`tar -cfvz`で圧縮しておく。

解凍して、
```shell
influx restore <backup_name>
```
で復元できるはずだが、すでにbucketが存在していると怒られる。`--full`オプションをつけてなんとかする。

## パスワード
バックアップデータにパスワードも混じってたようで、パスワードが変わった。
面倒だったので、コンテナを再起動して環境変数からパスワードを読み込ませてみる。
するとデータにアクセスできなくなったようで、bucketが空になった。

もう一度full restoreをして、今度はコマンドラインからパスワードを変更する。
```shell
influxdb user password --user <user> --password <password>
```
これでパスワードを戻してやるとうまくいった。

## (多分)正攻法
バックアップ時に`-b`オプションをつけてやると特定のbucketだけバックアップできるっぽいので、
それを使うとうまくいく...かもしれない。 // TODO

## コラ〜〜〜〜〜〜
mountするpath間違っとるやんけ。ほんとうは`influxdb2`。
```yaml
volumeMounts:
- mountPath: /var/lib/influxdb
  name: influxdb-data
```