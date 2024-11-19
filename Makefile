
.PHONY: test

build:
	docker build --no-cache -t javanile/proxy .

start: build
	docker run --rm -d -p 80:80 -p 443:443 -v proxy:/data --name proxy javanile/proxy

stop:
	docker stop proxy || true

logs:
	@docker logs -f proxy

validate: build
	@docker run --rm -p 8080:80 -p 8443:443 --name proxy javanile/proxy

release:
	git config credential.helper 'cache --timeout=3600'
	git add .
	git commit -m "Release"
	git push

update: stop
	@git pull
	@make -s start

test:
	@#bash tests/webrequest-test.sh
	@bash tests/binst-test.sh

test-binst:
	@bash tests/binst-test.sh

test-log:
	@bash tests/log-test.sh
