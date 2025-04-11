
.PHONY: test

build:
	@chmod +x docker-entrypoint.sh cgi-bin/*.sh
	@docker build --no-cache -t javanile/proxy .

start: build
	docker run --rm -d -p 80:80 -p 443:443 -v proxy:/data --name proxy javanile/proxy

stop:
	docker stop proxy || true

logs:
	@docker logs -f proxy

validate: build
	@docker run --rm -p 8080:80 -p 8443:443 --name proxy javanile/proxy

release: build
	git config credential.helper 'cache --timeout=3600'
	git add .
	git commit -m "Release" || true
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

test-localhost: build
	@docker kill proxy-test || true
	@docker run -d --rm -p 8080:80 -p 8443:443 --name proxy-test javanile/proxy
	@sleep 1
	@curl -i -H "Custom-Header: test" -H "Host: localhost" -H "Port: 8183" "http://localhost:8080/debug.sh?a=1&b=2" -d '{"a":1,"b":3}'
