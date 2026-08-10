# docker compose と連動（中身は docker compose の薄いラッパー）
#   make / make up  ==  docker compose up -d
#   make test       ==  docker compose --profile test run --rm test
#   make down       ==  docker compose down
.DEFAULT_GOAL := up

.PHONY: help setup up down rebuild logs ps health clean test

COMPOSE := docker compose
APP_URL ?= http://localhost:$(shell grep -E '^APP_PORT=' .env 2>/dev/null | cut -d= -f2 || echo 8080)

help:
	@echo "docker compose と連動しています。"
	@echo ""
	@echo "  make / make up   ==  docker compose up -d"
	@echo "  make test        ==  コンテナ内で mvn test（ホストに Java 不要）"
	@echo "  make down        ==  docker compose down"
	@echo "  make clean       ==  docker compose down -v"
	@echo "  make rebuild     ==  docker compose up -d --force-recreate"
	@echo "  make logs        ==  docker compose logs -f"
	@echo "  make ps          ==  docker compose ps"
	@echo "  make health      ヘルスチェック"
	@echo ""
	@echo ".env は docker compose up -d の init サービスでも自動作成されます。"

setup:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env を作成しました"; \
	else \
		echo ".env は既に存在します"; \
	fi

up:
	$(COMPOSE) up -d

# DB を起動してからテスト実行（Java/Maven はコンテナ内）
test:
	$(COMPOSE) up -d db
	$(COMPOSE) --profile test run --rm test

rebuild:
	$(COMPOSE) up -d --force-recreate

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

health:
	@curl -sf $(APP_URL)/actuator/health && echo || (echo "未起動またはポートが違います (APP_URL=$(APP_URL))" && exit 1)

clean:
	$(COMPOSE) down -v
	@echo "コンテナとボリュームを削除しました"
