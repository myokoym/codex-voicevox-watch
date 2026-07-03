---
id: TASK-1.3
title: インストールとアンインストールを整備する
status: Done
assignee: []
created_date: '2026-07-03 21:56'
updated_date: '2026-07-03 22:01'
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
- [x] #1 install.sh --prefix で任意prefixへインストールできる
- [x] #2 uninstall.sh --prefix でインストール済み入口を削除できる
- [x] #3 既存の別ファイルを誤って上書き・削除しない
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
scripts/install.sh と scripts/uninstall.sh を追加し、prefix/bin 配下へrepo内CLIを呼ぶ入口を安全に作成・削除する。
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
一時prefixでinstall/uninstallを検証し、未管理ファイルの上書き拒否も確認。
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
install.sh と uninstall.sh を追加し、安全な導入と削除を可能にした。
<!-- SECTION:FINAL_SUMMARY:END -->
