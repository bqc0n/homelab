> [!NOTE]
> 工事中 | Under Construction

# Wireguard

## 概要
自宅のGlobal IPは晒したくないし、ポートも開けたくない。
そこで、クラウドやVPSなどからWireguardを用いて自宅のPodにトンネルを張り、Forwardingを行う。

## 手順
* Wireguardをインストール
```shell
sudo apt update && sudo apt install wireguard-tools -y
```

* 鍵
クラウド側、ローカル側の両方で鍵を作成する。
```shell
wg genkey > /etc/wireguard/key
wg pubkey < /etc/wireguard/key # 公開鍵の取得
```
公開鍵はメモしておく。

## クラウド側の設定
適当に設定を書く。
```toml
[Interface]
PrivateKey = <クラウド側の秘密鍵>
Address = fe80::1/64
ListenPort = 51820 # ポートは適当に

[Peer]
PublicKey = <ローカル側の公開鍵>
AllowedIPs = fe80::2/128
```

以下のコマンドを実行するとwg0という名前でwireguardのインターフェースが作成される。
```shell
wg-quick up wg0
```

ポートを開けておくのを忘れずに。
```shell
sudo iptables -I INPUT 1 -p udp --dport 51820 -j ACCEPT
```

> [!NOTE]
> Appendだと、最後にALL REJECTのルールがある場合にうまくいかない。
> その状態でもなぜか`nc -uvz`が成功したんだよなあ...なんでだろう。情報求む。


## 参考
* [クラウドのサーバーに届いたパケットをVPN経由でローカルに引き込む方法](https://blog.silolab.net/article/open-port-via-cloud-using-vpn-port-forwarding)
* [Wireguard | QuickStart](https://www.wireguard.com/quickstart/)