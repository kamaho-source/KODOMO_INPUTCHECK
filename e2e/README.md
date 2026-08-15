# E2E (Playwright)

対象は `backend` が配信する Thymeleaf 画面。ローカルは `docker compose up -d` で起動したアプリに対して実行する。

```bash
npm install
npx playwright install --with-deps chromium
npm run test:no-db   # tests/no-db/ 配下
npm run test:db      # tests/db/ 配下
```

## ディレクトリの分け方

- `tests/no-db/`: DBの永続データに依存しないシナリオ（画面表示・クライアント側バリデーション等）を置く
- `tests/db/`: DBに保存されたデータへの依存があるシナリオ（登録・更新・一覧表示等のCRUDフロー）を置く

アプリ自体は起動に PostgreSQL 接続が必須なため、どちらのスイートも DB コンテナは起動した状態で実行する。分けているのは「テストが前提とするデータ」の違いであり、CI ではジョブを分離してそれぞれ独立に実行・失敗判定できるようにしている（`.github/workflows/e2e.yml`）。

画面・コントローラが未実装の現時点では、`/actuator/health` を叩く最小スモークテストのみを置いている（`no-db`: 起動確認、`db`: `components.db.status` の確認）。画面実装が進んだら、各シナリオに応じたspecをここに追加していく。
