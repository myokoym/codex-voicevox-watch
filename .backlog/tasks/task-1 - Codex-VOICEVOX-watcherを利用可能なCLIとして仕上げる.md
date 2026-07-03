---
id: TASK-1
title: Codex VOICEVOX watcherを利用可能なCLIとして仕上げる
status: Done
assignee: []
created_date: '2026-07-03 21:56'
updated_date: '2026-07-03 22:02'
labels:
  - voicevox
  - cli
  - quality
dependencies: []
priority: high
ordinal: 1000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
現在のwatcherは動作するが、README、導入/削除、状態確認、読み上げ調整、Backlog.md運用が不足している。利用者がインストールして状態を把握し、音声パラメータを調整できるCLIとして仕上げる。
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 READMEだけで前提、インストール、クイックスタート、状態確認、設定、アンインストールが分かる
- [x] #2 インストールとアンインストールをスクリプトで再現できる
- [x] #3 statusで稼働状態、VOICEVOX疎通、設定、state/log/configの場所、最終エラーが分かる
- [x] #4 configコマンドで読み上げ速度などのVOICEVOXパラメータを永続設定できる
- [x] #5 検証コマンドが通り、最終状態がgit cleanになる
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
子タスクTASK-1.1〜TASK-1.4を完了。Backlog導入コミット: 55c043b。実装コミット: 23e146a。
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
README、install/uninstall、status/config、読み上げ調整、Backlog管理を追加し、利用可能なCLIとして仕上げた。
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Backlog子タスクの完了状態を更新する
- [x] #2 関連変更をコミットする
<!-- DOD:END -->
