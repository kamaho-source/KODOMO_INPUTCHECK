---
name: backlog-tickets
description: >-
  Manages Backlog issues (tickets): create, update, list/search, and comment,
  via the Backlog MCP server. Use for /ticket-create, /ticket-update,
  /ticket-list, チケット作成, チケット更新, チケット一覧, 課題管理.
  Works in Cursor, Claude Code, Codex, and any agent that connects the
  `backlog` MCP server.
---

# Backlog チケット管理

## いつ使うか

- チケット（課題）を**作成**する（`/ticket-create`）
- チケットを**更新**する（`/ticket-update`）: ステータス・担当者変更、コメント追記など
- チケットを**検索・一覧**する（`/ticket-list`）

## 認証

`BACKLOG_DOMAIN` / `BACKLOG_API_KEY` は `.env`（`.env.example` 参照）から設定する。
MCP サーバーは `.mcp.json`（Claude Code / Codex）・`.cursor/mcp.json`（Cursor）に
`backlog`（`backlog-mcp-server`, toolset: `project,issue`）として登録済み。
未有効化の場合はエディタ側で MCP サーバーの利用を許可する。

## 使うツール（MCP `backlog`）

- 取得: `get_issue`, `get_issues`, `count_issues`, `get_issue_comments`
- 作成: `add_issue`（事前に `get_project_list` / `get_issue_types` / `get_priorities` で必須項目を確認）
- 更新: `update_issue`, `add_issue_comment`, `update_issue_comment`
- 完了化・削除など不可逆な操作は**必ずユーザー確認後**に実行する

## 呼び出し例

```text
/ticket-create ログイン画面のエラー修正
/ticket-update SHOKUSU-13 ステータスを処理中にする
/ticket-list 自分の未完了チケット
```
