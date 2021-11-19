

build:
	docker build -t javanile/ionos-proxy .

start: build
	docker run --rm -p 80:80 -p 443:443 --name ionos-proxy javanile/ionos-proxy

logs:
