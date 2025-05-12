# MinIO

落ちたらまずいので、軽率に行われるTerraform destroyの対象にしたくない。
なのでこれは手動で作る。
VmIdは303, 3072 RAMで。
IPv4は`192.168.1.32/24`。

### セットアップ

**PVEのshellで**
```bash
# なければ mkdir /shared/minio
pct set 303 -mp0 /shared/minio,mp=/mnt/minio
```

[ここ](https://min.io/docs/minio/linux/operations/install-deploy-manage/deploy-minio-single-node-single-drive.html#download-the-minio-server)
に従う。
**MinIO LXCのshellで**
```bash
wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20250422221226.0.0_amd64.deb -O minio.deb
sudo dpkg -i minio.deb

# データディレクトリ
mkdir -p /mnt/minio/data
groupadd -r minio-user
useradd -M -r -g minio-user minio-user
chown minio-user:minio-user /mnt/minio/data
```