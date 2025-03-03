# Javanile Proxy

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
ssh root@74.208.245.19 bpkg install javanile/proxy
```

Install from source (not required)

```shell
git clone https://github.com/javanile/proxy.git /opt/proxy
cd /opt/proxy
make start
```

## Reload

```shell
ssh root@74.208.245.19 bash -c "cd /opt/proxy && make reload" 
```