---
id: TASK-1.3
title: インストールとアンインストールを整備する
status: To Do
assignee: []
created_date: '2026-07-03 21:56'
labels:
  - install
  - cli
dependencies: []
modified_files:
  - scripts/install.sh
  - scripts/uninstall.sh
parent_task_id: TASK-1
priority: high
ordinal: 4000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
既定でユーザー用binディレクトリにCLI入口を作成し、同じ単位で削除できるスクリプトを追加する。
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 install.sh --prefix で任意prefixへインストールできる
- [ ] #2 uninstall.sh --prefix でインストール済み入口を削除できる
- [ ] #3 既存の別ファイルを誤って上書き・削除しない
<!-- AC:END -->
