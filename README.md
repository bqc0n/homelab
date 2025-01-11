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
ansible-playbook -i "../ansible/hosts.yaml" -e "@../kubespray-vars.yaml" kubespray.yaml -b --become-user=root --flush-cache
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
Settings/Repositoriesでこのリポジトリを追加し、app-of-appsをDeployして作業完了。

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