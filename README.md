# KODOMO_INPUTCHECK

こども向けの日本語・英語学習支援システムのリポジトリです。

## 開発環境の起動

`docker compose up -d` だけで **`.env` 作成・Maven ライブラリ取得・イメージビルド・PostgreSQL・Spring Boot** をまとめて起動します（`--build` 不要）。
`Makefile` は同じ `docker compose` コマンドへの薄いラッパーです（`make` == `docker compose up -d`）。

ビルド時に `pom.xml` の依存（Spring Boot / java-diff-utils / PDFBox 等）がコンテナ内に入ります。

アプリケーションの機能（画面・API・ドメイン等）は各担当者が実装してください。
**今は開発環境の用意のみです。サンプルの画面・クラス・テストは置きません。**

```bash
docker compose up -d
# または
make
```

起動確認:

```bash
curl http://localhost:8080/actuator/health
# または
make health
```

| 操作 | docker compose | make |
|------|----------------|------|
| 起動（ビルド込み） | `docker compose up -d` | `make` / `make up` |
| テスト実行 | `docker compose --profile test run --rm test` | `make test` |
| 停止 | `docker compose down` | `make down` |
| ログ | `docker compose logs -f` | `make logs` |
| ボリュームごと削除 | `docker compose down -v` | `make clean` |

### テスト実行（Docker）

ホストに Java / Maven は不要です。コンテナ内で `mvn test` を実行します（DB も起動します）。

```bash
make test
# または
docker compose up -d db
docker compose --profile test run --rm test
```

テストコードは `backend/src/test/java/` に追加してください（現状はスケルトンのみでサンプルテストはありません）。

8080 が使用中の場合は `.env` で `APP_PORT=8081` などに変更してください。

### 接続情報（デフォルト）

| 項目 | 値 |
|------|-----|
| Spring Boot | http://localhost:8080 |
| Health check | http://localhost:8080/actuator/health |
| DB Host | `localhost`（コンテナ外から） / `db`（コンテナ内から） |
| DB Port | `5432` |
| Database | `kodomo` |
| User | `kodomo` |
| Password | `kodomo` |
| JDBC URL | `jdbc:postgresql://localhost:5432/kodomo` |

### 停止・削除

```bash
docker compose down      # または make down
docker compose down -v   # または make clean（DBデータも削除）
```

## 技術スタック（依存ライブラリ）

`docker compose up -d` のビルドで以下が自動取得・JAR に同梱されます（`backend/pom.xml`）。

- Java 26 / Spring Boot 4（Web, Thymeleaf, JPA, Actuator）
- PostgreSQL ドライバ
- java-diff-utils（入力文字の差分判定）
- Apache PDFBox（PDFからテキスト抽出）

実装コード・テンプレート・テストは担当者が追加してください。`make test` でコンテナ内 `mvn test` を実行できます。

## CI（GitHub Actions）

`.github/workflows/ci.yml` で push / PR 時に Java 26 + PostgreSQL 上で `mvn test` を実行します。
テストは `backend/src/test/java/` に置けば CI で自動実行されます。

## Backlog連携（チケット管理）

1. `.env.example` を `.env` にコピーし、`BACKLOG_DOMAIN` / `BACKLOG_API_KEY` を設定する
2. Claude Code / Cursor で `backlog` MCP サーバー（`.mcp.json` / `.cursor/mcp.json`）を許可する
3. `/ticket-create` `/ticket-update` `/ticket-list` でチケットを作成・更新・検索できる（手順: `.claude/skills/backlog-tickets/SKILL.md`）

### GitHub Actions 同期（GitHub Issue/PR ⇔ Backlog課題）

shokusuu1 から移植（リポジトリ固有の一時スクリプトは除外）。リポジトリの Settings → Secrets and variables → Actions に以下を設定する:

| Secret | 値 |
|---|---|
| `BACKLOG_API_KEY` | Backlog APIキー |
| `BACKLOG_SPACE_ID` | ``（`*.backlog.com` のスペースID部分） |
| `BACKLOG_PROJECT_KEY` | `` |
| `BACKLOG_DOMAIN` | 未設定なら `backlog.com` がデフォルト |

- `github-issue-to-backlog.yml`: GitHub Issue作成/編集/close/reopen → Backlog課題に反映
- `backlog-to-github-issue.yml`: Backlog課題の更新を15分ごとにGitHub Issueへ反映
- `github-issue-comment-to-backlog.yml`: GitHub Issueコメント → Backlogコメント
- `github-pr-to-backlog.yml`: 関連PRの状態 → Backlogコメント
- `backlog-branch-status.yml`: develop/release/main への反映でBacklogステータス自動更新（対象ブランチが無ければ発火しない）
- `bulk-sync-github-to-backlog.yml`: 既存GitHub Issueの一括同期（手動実行、dry run可）
