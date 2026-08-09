# Backlog に新規チケット（課題）を作成する

チャット入力の **このコマンド名の後ろに付けた引数** を最優先で使う。

## 引数

| 位置 | 例 | 意味 |
|------|-----|------|
| 1 | `ログイン画面のエラー修正` | チケットの件名（必須。無ければユーザーに確認） |
| 2 | `本文` | 詳細説明（任意） |

例: `/ticket-create ログイン画面のエラー修正`

## 必ず行うこと

1. Skill / 手順の正本に従う: `skills/backlog-tickets/SKILL.md`
2. プロジェクト（`BACKLOG_PROJECT_KEY` または引数指定）が未確定なら `get_project_list` で確認する
3. 課題種別・優先度が未指定なら `get_issue_types` / `get_priorities` から候補を出し、ユーザーに確認する
4. MCP `add_issue` で作成する（projectId, summary, issueTypeId, priorityId は必須）
5. 作成した課題キー・URL を報告する

## 禁止

- 必須項目（種別・優先度など）を推測だけで決めて確認なしに作成すること
- API キーを出力・コミットすること
