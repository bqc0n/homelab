> [!NOTE]
> 工事中 | Under Construction

# Pre-deployment steps

## Create custom LXC template
`ubuntu-24.04-2_amd64.tar.zst`の名前で作成する。
[ここ](https://qiita.com/bashaway/items/f79cb6dde2ec4fdf3ae7)がわかりやすい。

## `/docs`に書いてあることをやる
ZFSプールの作成、NFS Exportなど。

## `required_nfs_dirs`を実行
`ansible` ディレクトリに行って、
```shell
ansible-playbook required_nfs_dirs.yml
```
を実行する。

# Credits
| Name | License |
| :---: | :---: |
| [geraldwuhoo/homelab-iac](https://github.com/geraldwuhoo/homelab-iac) | [MIT](https://github.com/geraldwuhoo/homelab-iac/blob/master/LICENSE) |
