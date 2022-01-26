
.PHONY: test

build:
	docker build --no-cache -t javanile/ionos-proxy .

start: build
	docker run --rm -d -p 80:80 -p 443:443 -v ionos-proxy:/data --name ionos-proxy javanile/ionos-proxy

stop:
	docker stop ionos-proxy

validate: build
	@docker run --rm -p 8080:80 -p 8443:443 --name ionos-proxy javanile/ionos-proxy

release:
	git add .
	git commit -m "Release"
	git push

update: stop
	git pull
	make -s start

test:
	@#bash test/webrequest-test.sh
	@bash test/binst-test.sh
