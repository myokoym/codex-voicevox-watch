---
id: TASK-1.2
title: statusとconfigを強化する
status: Done
assignee: []
created_date: '2026-07-03 21:56'
updated_date: '2026-07-03 22:01'
labels:
  - cli
  - config
  - voicevox
dependencies: []
modified_files:
  - bin/codex-voicevox-watch
parent_task_id: TASK-1
priority: high
ordinal: 3000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
watcherの状態確認を利用者向けに拡張し、VOICEVOXの速度・音量・話者などを永続設定できるconfigコマンドを追加する。
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 config show/set/path が使える
- [x] #2 speed_scaleなどのVOICEVOX audio_query項目がsynthesis前に反映される
- [x] #3 statusで設定値と管理ファイルの場所が分かる
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
config show/set/path を追加し、VOICEVOX audio_queryへ速度・音量・話者などの設定を反映する。statusは設定値と管理ファイルの場所を表示する。
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
config show/set/path、VOICEVOX audio_queryへの設定反映、statusの設定表示を実装。
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
statusとconfigを追加し、読み上げ速度などを永続設定できるようにした。
<!-- SECTION:FINAL_SUMMARY:END -->
