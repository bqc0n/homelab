> [!NOTE]
> 工事中 | Under Construction

# Homelab

#### Hardware
There are 3 nodes.

| Node |            CPU            | RAM  |
|:----:|:-------------------------:|:----:|
| pve01 |   4C/4T (Core i3-8100)    | 32GB |
| pve02 | 8C/16T (Xeon Silver 4108) | 64GB |
| pve03 |   6C/6T (Ryzen 5 3500)    | 32GB |

#### Virtualization
[Proxmox Virtual Environment](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview)

#### VM/LXC Management
[Terraform](https://github.com/hashicorp/terraform)/[opentofu](https://github.com/opentofu/opentofu) and [Telmate/terraform-provider-proxmox](https://github.com/Telmate/terraform-provider-proxmox)

#### Software Management
[Ansible](https://github.com/ansible/ansible). Playbooks are located in [`ansible/`](ansible/).

#### Application Deployment
[Kubernetes](https://kubernetes.io), and [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) for GitOps.
manifests are located in [`argocd/`](argocd/).

# TODO
- [ ] README を書く
- [ ] Credits をしっかり書く
- [ ] ディレクトリ構造の整理
- [ ] ドキュメントの整理
- [ ] Cilium の Native Routing
- [ ] NixOS
- [ ] 全貌がわかる図
- [ ] Terraform Remote State
- [ ] Renovate Bot
- [ ] HA k8s
- [ ] Apt cache server

# Requirements

- [`terraform`](https://github.com/hashicorp/terraform) / [`opentofu`](https://github.com/opentofu/opentofu)
- [`sops`](https://github.com/getsops/sops)

# Credits
|                                 Name                                  |                                License                                |
|:---------------------------------------------------------------------:|:---------------------------------------------------------------------:|
| [Proxmox Virtual Environment](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) | [AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.html#license-text) |
| [geraldwuhoo/homelab-iac](https://github.com/geraldwuhoo/homelab-iac) | [MIT](https://github.com/geraldwuhoo/homelab-iac/blob/master/LICENSE) |