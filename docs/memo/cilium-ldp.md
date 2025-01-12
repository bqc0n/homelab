# Local Redirect Policy
```shell
ubuntu@k8s-worker-02:~$ sudo tcpdump -i any -n port 80
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
10:22:31.318024 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [S], seq 4243633323, win 64860, options [mss 1410,sackOK,TS val 2560009293 ecr 0,nop,wscale 7], length 0
10:22:31.318067 lxcab616b1b83ab In  IP 10.233.67.121.80 > 10.233.67.167.33638: Flags [S.], seq 3612930975, ack 4243633324, win 64308, options [mss 1410,sackOK,TS val 2107616323 ecr 2560009293,nop,wscale 7], length 0
10:22:31.318089 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [.], ack 1, win 507, options [nop,nop,TS val 2560009293 ecr 2107616323], length 0
10:22:31.318173 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [P.], seq 1:96, ack 1, win 507, options [nop,nop,TS val 2560009293 ecr 2107616323], length 95: HTTP: HEAD /index.html HTTP/1.1
10:22:31.318183 lxcab616b1b83ab In  IP 10.233.67.121.80 > 10.233.67.167.33638: Flags [.], ack 96, win 502, options [nop,nop,TS val 2107616323 ecr 2560009293], length 0
10:22:31.318768 lxcab616b1b83ab In  IP 10.233.67.121.80 > 10.233.67.167.33638: Flags [P.], seq 1:239, ack 96, win 502, options [nop,nop,TS val 2107616323 ecr 2560009293], length 238: HTTP: HTTP/1.1 200 OK
10:22:31.318850 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [.], ack 239, win 506, options [nop,nop,TS val 2560009293 ecr 2107616323], length 0
10:22:31.319042 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [F.], seq 96, ack 239, win 506, options [nop,nop,TS val 2560009294 ecr 2107616323], length 0
10:22:31.319154 lxcab616b1b83ab In  IP 10.233.67.121.80 > 10.233.67.167.33638: Flags [F.], seq 239, ack 97, win 502, options [nop,nop,TS val 2107616324 ecr 2560009294], length 0
10:22:31.319226 lxcd44936859658 In  IP 10.233.67.167.33638 > 10.233.67.121.80: Flags [.], ack 240, win 506, options [nop,nop,TS val 2560009294 ecr 2107616324], length 0
```