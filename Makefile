init:
	docker network create tunnels-traefik || true
	docker network create traefik-containers || true

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f --tail 100 --since 1h