> [!NOTE]
> 工事中 | Under Construction

# Pre-deployment steps

## Create custom LXC template
`ubuntu-24.04-2_amd64.tar.zst`の名前で作成する。
[ここ](https://qiita.com/bashaway/items/f79cb6dde2ec4fdf3ae7)がわかりやすい。

## `/docs`に書いてあることをやる
ZFSプールの作成、NFS Exportなど。

## Remotely managed cloudflare tunnelの作成
[このガイド](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/)に従い、Remotely managed cloudflare tunnelを作成する。

## kubespray

### venv作成
```shell
python3 -m venv venv
```

### activate
```shell
source venv/bin/activate
```

### requirements.txtのインストール
```bash
python3 -m pip install -r requirements.txt
```

```shell
ansible-playbook -i hosts.yml -e "@../kubespray-vars.yaml" cluster.yml -b --become-user=root --flush-cache
```

## `kubectl` without sudo

```shell
mkdir -p /home/$USER/.kube
cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
chown $USER:$USER /home/$USER/.kube/config
```

# 注意事項

## CI Template
cloud initのイメージを作る時は、boot diskの大きさは最低限にすること。大きすぎると、migrateに無駄な時間を要する。

## 仮想化
新しいNodeを追加する時は、BIOSで仮想化を有効にすること。

## nfs-common
nfsをmountする時は、`nfs-common`をインストールすること。

# Credits
|                                 Name                                  |                                License                                |
|:---------------------------------------------------------------------:|:---------------------------------------------------------------------:|
| [geraldwuhoo/homelab-iac](https://github.com/geraldwuhoo/homelab-iac) | [MIT](https://github.com/geraldwuhoo/homelab-iac/blob/master/LICENSE) |

# TODO
- [ ] ディレクトリ構造の整理
- [ ] ドキュメントの整理
- [ ] 1つのtemplateから複数nodeにVMをdeployする方法
- kubesealを試す https://developer.mamezou-tech.com/blogs/2022/06/05/introduce-sealedsecrets/