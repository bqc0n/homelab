> [!NOTE]
> 工事中 | Under Construction

# TODO
- [ ] READMEを書く
- [ ] Credits をしっかり書く
- [ ] ディレクトリ構造の整理
- [ ] ドキュメントの整理
- [ ] Ciliumの Native Routing
- [ ] NixOS
- [ ] 全貌がわかる図
- [ ] Terraform Remote State
- [ ] Renovate
- [ ] HA k8s
- [ ] https://github.com/actualbudget/actual

# Requirements

- [`terraform`](https://github.com/hashicorp/terraform) / [`opentofu`](https://github.com/opentofu/opentofu)
- [`sops`](https://github.com/getsops/sops)

# Credits
|                                 Name                                  |                                License                                |
|:---------------------------------------------------------------------:|:---------------------------------------------------------------------:|
| [Proxmox Virtual Environment](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) | [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.html#license-text) |
| [geraldwuhoo/homelab-iac](https://github.com/geraldwuhoo/homelab-iac) | [MIT](https://github.com/geraldwuhoo/homelab-iac/blob/master/LICENSE) |

- search ip
```shell
kubectl api-resources  -oname |while read r;
do 
     echo -n "$r ----> ";
     kubectl get $r -A -o yaml | egrep '\d+\.\d+\.\d+\.\d+';
     echo "" ;
done
```
 