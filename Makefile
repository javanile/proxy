
.PHONY: test

build:
	docker build --no-cache -t javanile/proxy .

start: build
	docker run --rm -d -p 80:80 -p 443:443 -v proxy:/data --name proxy javanile/proxy

stop:
	docker stop proxy || true

validate: build
	@docker run --rm -p 8080:80 -p 8443:443 --name proxy javanile/proxy

release:
	git add .
	git commit -m "Release"
	git push

update: stop
	@git pull
	@make -s start

test:
	@#bash test/webrequest-test.sh
	@bash test/binst-test.sh

test-binst:
	@bash test/binst-test.sh
