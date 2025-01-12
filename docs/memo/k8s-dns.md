# 問題
[これ](https://docs.cilium.io/en/latest/network/kubernetes/local-redirect-policy/#node-local-dns-cache)をやると名前解決がおかしくなる。


普通の時
```shell
ubuntu@k8s-worker-02:~$ sudo tcpdump -i any -n port 53
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
11:37:53.535293 lxc5230b2f4bf5f In  IP 10.233.67.138.57412 > 10.233.66.131.53: 21832+ A? youtube.com. (29)
11:37:53.535329 cilium_vxlan Out IP 10.233.67.138.57412 > 10.233.66.131.53: 21832+ A? youtube.com. (29)
11:37:53.535431 lxc5230b2f4bf5f In  IP 10.233.67.138.57412 > 10.233.66.131.53: 21833+ AAAA? youtube.com. (29)
11:37:53.535442 cilium_vxlan Out IP 10.233.67.138.57412 > 10.233.66.131.53: 21833+ AAAA? youtube.com. (29)
11:37:53.542984 cilium_vxlan P   IP 10.233.66.131.53 > 10.233.67.138.57412: 21832 1/0/0 A 142.250.199.110 (56)
11:37:53.560667 cilium_vxlan P   IP 10.233.66.131.53 > 10.233.67.138.57412: 21833 1/0/0 AAAA 2404:6800:4004:810::200e (68)
```
普通ではない時
```shell
11:35:37.751527 lxcfbef1b153eb7 In  IP 10.233.65.101.55150 > 1.1.1.2.53: 11894+ NS? . (17)
11:35:37.751543 eth0  Out IP 192.168.1.61.55150 > 1.1.1.2.53: 11894+ NS? . (17)
11:35:37.756754 eth0  In  IP 1.1.1.2.53 > 192.168.1.61.55150: 11894 13/0/0 NS a.root-servers.net., NS b.root-servers.net., NS c.root-servers.net., NS d.root-servers.net., NS e.root-servers.net., NS f.root-servers.net., NS g.root-servers.net., NS h.root-servers.net., NS i.root-servers.net., NS j.root-servers.net., NS k.root-servers.net., NS l.root-servers.net., NS m.root-servers.net. (228)
11:35:38.184092 lxcfbef1b153eb7 In  IP 10.233.65.101.46673 > 1.0.0.2.53: 44325+ NS? . (17)
11:35:38.184116 eth0  Out IP 192.168.1.61.46673 > 1.0.0.2.53: 44325+ NS? . (17)
11:35:38.188381 eth0  In  IP 1.0.0.2.53 > 192.168.1.61.46673: 44325 13/0/0 NS a.root-servers.net., NS b.root-servers.net., NS c.root-servers.net., NS d.root-servers.net., NS e.root-servers.net., NS f.root-servers.net., NS g.root-servers.net., NS h.root-servers.net., NS i.root-servers.net., NS j.root-servers.net., NS k.root-servers.net., NS l.root-servers.net., NS m.root-servers.net. (228)
...
...
...
```

node local dnsのimageをupdateしたら、治った。TODO: Changelogをみてみる。