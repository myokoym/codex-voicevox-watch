---
id: TASK-1
title: Codex VOICEVOX watcherを利用可能なCLIとして仕上げる
status: In Progress
assignee: []
created_date: '2026-07-03 21:56'
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
- [ ] #1 READMEだけで前提、インストール、クイックスタート、状態確認、設定、アンインストールが分かる
- [ ] #2 インストールとアンインストールをスクリプトで再現できる
- [ ] #3 statusで稼働状態、VOICEVOX疎通、設定、state/log/configの場所、最終エラーが分かる
- [ ] #4 configコマンドで読み上げ速度などのVOICEVOXパラメータを永続設定できる
- [ ] #5 検証コマンドが通り、最終状態がgit cleanになる
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backlog子タスクの完了状態を更新する
- [ ] #2 関連変更をコミットする
<!-- DOD:END -->
