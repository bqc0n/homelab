# RPi IP 設定

```shell
nmcli c show
```
DEVICEに対応する名前を覚える。

以下のコマンドで名前を変更する。DEVICEと同じように、`eth0`とかでいいと思う。
今回は`eth0`を使用する。
```shell
sudo nmcli c modify <NAME> connection.id <NEW_NAME>
```

以下のコマンドで諸々設定する。
```shell
nmcli con modify eth0 ipv4.addresses 192.168.1.4/24
nmcli con modify eth0 ipv4.method manual
nmcli con modify eth0 ipv4.dns 1.1.1.2
nmcli con modify eth0 ipv4.gateway 192.168.1.1
sudo nmcli connection reload
sudo nmcli connection up eth0
```
