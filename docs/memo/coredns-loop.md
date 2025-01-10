nodelocaldnsでループが発生していた。
```
[FATAL] plugin/loop: Loop (**) detected for zone "ip6.arpa.", see https://coredns.io/plugins/loop#troubleshooting. Query: "...."
```

ip6.arpaのforwardを書き換えた。
これで一度様子見。

k8sでのCoreDNSの挙動についても調べる TODO。

```diff
ip6.arpa:53 {
    errors
    cache 30
    reload
    loop
    bind 169.254.25.10
-   forward . 10.233.0.3 {
+   forward . 1.1.1.1 {
        force_tcp
    }
    prometheus :9253
}
```