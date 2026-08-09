# KODOMO_INPUTCHECK

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
