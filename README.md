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

```shell
# at repository root
cp kubespray.yaml kubespray/kubespray.yaml
cd kubespray
```

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

## Cilium

```shell
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.16.5 --atomic \
  --namespace kube-system \
  --values cilium-values.yaml
```

If you're getting an error `cp: cannot create regular file '/hostbin/cilium-mount': Permission denied`,
see [this issue](https://github.com/cilium/cilium/issues/23838).
TLDR: `sudo chown -R root:root /opt/cni/bin` for all nodes.

### Upgrading
```shell
helm upgrade cilium cilium/cilium --version 1.16.5 --atomic \
  --namespace kube-system \
  --values cilium-values.yaml
```


## After the k8s cluster is up and running
暗号鍵の入ったファイルを用意して、`kubectl apply -f key.yaml`を実行する。
Sealed SecretsそのものはArgoCDでDeployする。
https://argo-cd.readthedocs.io/en/stable/ をみながらArgoCDをDeployする。
k8upのCRDも適用する(Helm Chartに含まれていないため)。

```shell
k apply -f node-local-dns.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f https://github.com/k8up-io/k8up/releases/download/k8up-4.8.3/k8up-crd.yaml --server-side
```

To prevent cilium resources from being detected by argoCD, do the following:
```shell
k edit cm -n argocd argocd-cm
```
and paste this
```yaml
data:
  resource.exclusions: |
    - apiGroups:
        - cilium.io
      kinds:
        - CiliumIdentity
      clusters:
        - "*"
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
- [ ] NodeLocal DNSを設定すると. NSを大量にクエリしていた問題の原因究明、なぜ急に治ったかの調査
- [ ] Ingressが動くようにする


- search ip
```shell
kubectl api-resources  -oname |while read r;
do 
     echo -n "$r ----> ";
     kubectl get $r -A -o yaml | egrep '\d+\.\d+\.\d+\.\d+';
     echo "" ;
done
```
 