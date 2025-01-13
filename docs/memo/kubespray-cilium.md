# Installing Cilium with Kubespray

kubesprayを利用している時、`kube_network_plugin: cilium`とすることでCiliumをCNIとしてインストールできる。
がしかし、この方法だと細かいカスタマイズが非常にやりにくい。

## 問題点

### 公式ドキュメントはHelm Chart前提
[Ciliumの公式ドキュメント](https://docs.cilium.io/en/stable/configuration/index.html)をみてみると、

> Your Cilium installation is configured by one or more Helm values - see Helm Reference. 
 
と書かれている。
加えて、多くの場面で「これを使うにはこのHelm valueを変更してね」という記述になっている。

一方で、kubesprayでciliumを設定する場合、

1. まず[変数のデフォルト値](https://github.com/kubernetes-sigs/kubespray/blob/master/roles/network_plugin/cilium/defaults/main.yml)を参照し、目的の設定が可能か確認する。
2. 無理なら、[CiliumのHelm Template](https://github.com/cilium/cilium/blob/main/install/kubernetes/cilium/templates/cilium-configmap.yaml)をみて、目的の設定がどのConfigMap Keyに対応しているか確認する。
3. 目的の設定をAnsible変数`cilium_config_extra_vars`に設定する。

という手順が必要であり、非常に面倒である。Helm valueがConfigMap以外にも影響するなら、それの把握は困難であり、問題を発生させる可能性がある。

