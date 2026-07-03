---
id: TASK-1.2
title: statusとconfigを強化する
status: To Do
assignee: []
created_date: '2026-07-03 21:56'
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
- [ ] #1 config show/set/path が使える
- [ ] #2 speed_scaleなどのVOICEVOX audio_query項目がsynthesis前に反映される
- [ ] #3 statusで設定値と管理ファイルの場所が分かる
<!-- AC:END -->
