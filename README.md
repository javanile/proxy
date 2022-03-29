# IONOS Proxy

```text
US Proxy - IP 74.208.245.19
```

## Install

Preparing server 

```shell
curl get.bpkg.sh | ssh root@74.208.245.19
```

Install proxy server

```shell
ssh root@74.208.245.19 bpkg install javanile/ionos-proxy
```

Install from source (not required)

```shell
git clone https://github.com/javanile/ionos-proxy.git /opt/ionos-proxy
cd /opt/ionos-proxy
make start
```
