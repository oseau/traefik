SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset

init: ## create docker networks
	docker network create tunnels-traefik || true
	docker network create traefik-containers || true

up: ## run service
	docker compose up --force-recreate --build -d

down: ## stop service
	docker compose down

log: ## check logs
	docker compose logs -f --tail 100 --since 1h

rsync: ## rsync to server
	@source .env && rsync -azvhP --exclude='.env' $(shell pwd) $$DEST/repos

# https://www.gnu.org/software/make/manual/html_node/Options-Summary.html
MAKEFLAGS += --always-make

.DEFAULT_GOAL := help
# Modified from http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -Eh '^[a-zA-Z_-]+:.*?##? .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?##? "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# https://github.com/zephinzer/godev/blob/62012ce006df8a3131ee93a74bcec2066405fb60/Makefile#L220
## blue logs
log.debug:
	-@printf -- "\033[0;36m_ [DEBUG] ${MSG}\033[0m\n"

## green logs
log.info:
	-@printf -- "\033[0;32m> [INFO] ${MSG}\033[0m\n"

## yellow logs
log.warn:
	-@printf -- "\033[0;33m? [WARN] ${MSG}\033[0m\n"

## red logs (die mf)
log.error:
	-@printf -- "\033[0;31m! [ERROR] ${MSG}\033[0m\n"
