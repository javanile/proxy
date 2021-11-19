

build:
	docker build -t javanile/ionos-proxy .

start: build
	docker run --rm -d -p 80:80 -p 443:443 -p 5000:5000 --name ionos-proxy javanile/ionos-proxy

stop:
	docker stop ionos-proxy
