> [!NOTE]
> 工事中 | Under Construction

# Deployment

## Create custom LXC template
`ubuntu-24.04-2_amd64.tar.zst`の名前で作成する。
[ここ](https://qiita.com/bashaway/items/f79cb6dde2ec4fdf3ae7)がわかりやすい。

## `/docs`に書いてあることをやる
ZFSプールの作成、NFS Exportなど。

## Remotely managed cloudflare tunnelの作成
[このガイド](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/)に従い、Remotely managed cloudflare tunnelを作成する。

## Ansible
```shell
z ansible
ansible-playbook setup_homelab.yaml
```

## kubespray

### venv作成とactivate
```shell
python3 -m venv venv
source venv/bin/activate
```

### requirements.txtのインストール
```bash
python3 -m pip install -r requirements.txt
```

```shell
ansible-playbook -i "../ansible/hosts.yaml" -e "@../kubespray-vars.yaml" kubespray.yaml -b --become-user=root --flush-cache
```

### `kubectl` without sudo
#### Control Plane Node

```shell
mkdir -p /home/$USER/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/$USER/.kube/config
sudo chown $USER:$USER /home/$USER/.kube/config
```

#### Local Machine

```shell
cp ../ansible/artifacts/admin.conf ~/.kube/config
```

## NodeLocal DNS
[Ciliumの公式ドキュメント](https://docs.cilium.io/en/stable/network/kubernetes/local-redirect-policy/#node-local-dns-cache)に従って作業する。
ただし、dnsのsvc名は`kube-dns`ではなく`coredns`であることに注意。
LocalRedirectPolicyも`coredns`にすること。

## ArgoCD & SealedSecrets
暗号鍵の入ったファイルを用意して、`kubectl apply -f key.yaml`を実行する。
Sealed SecretsそのものはArgoCDでDeployする。
https://argo-cd.readthedocs.io/en/stable/ をみながらArgoCDをDeployする。
```shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
できたら、argocd/argo-webui.yamlを適用してweb UIにアクセスする。
```shell
argocd admin initial-password -n argocd
```
Settings/Repositoriesでこのリポジトリを追加し、app-of-appsをDeployして作業完了。
| Key | Value |
|:---:|:-----:|
| via | ssh |
| name | 適当に (e.g. homelab) |
| repo url | git@github.com:bqc0n/homelab.git |

```shell
k apply -f argocd/app-of-apps.yaml
```

## k8up
CRDはHelm Chartに含まれていないので、手動でDeployする。
```shell
kubectl apply -f https://github.com/k8up-io/k8up/releases/download/k8up-4.8.3/k8up-crd.yaml --server-side
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
- [ ] Ciliumの Native Routingを使う。podからipv6 internetにもアクセスしたいけど、GUAのprefixが可変なのをどうするか...ULAをNAPTする?もしくはv6を使わない選択肢。
- [ ] Ciliumに詳しくなる
- [ ] NodeLocal DNSを設定すると. NSを大量にクエリしていた問題の原因究明、なぜ急に治ったかの調査
 