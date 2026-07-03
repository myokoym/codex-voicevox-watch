# Codex会話VOICEVOX自動読み上げツール実装計画

## 要約

- 本丸は、通常のCodex操作を変えずに、Codexの新着assistantメッセージをVOICEVOXで自動読み上げする常駐CLIを作ることです。
- 方式は `~/.codex/sessions/**/*.jsonl` の新着監視、対象は起動後の新着のみ、読み上げは要点のみです。
- VOICEVOX Engine はWindows側 `127.0.0.1:50021` に起動済みの前提で、WSLからは `powershell.exe` 経由で呼びます。
- 配置先は `~/bin/codex-voicevox-watch`、管理は `start / stop / status` 方式にします。

## 完了条件

- `codex-voicevox-watch start` で背景常駐し、`status` と `stop` で管理できること。
- 既存の過去ログを読まず、起動後に追加されたassistantメッセージだけ読むこと。
- tool出力、diff、reasoning、token_count、長いコードブロックを読み上げ対象から除外すること。
- VOICEVOXで短いテスト文と実Codex応答を再生できること。
- `python3 -m py_compile`、内蔵self-test、start/status/stop確認が通ること。

## 主要マイルストーン

- M1: 実装計画を `.codex/plans/YYYYMMDDHHMMSS-codex-voicevox-watch.md` に保存する。
- M2: VOICEVOX呼び出し関数と `say` サブコマンドを作る。
- M3: Codex session JSONL監視、オフセット管理、要点抽出を作る。
- M4: `start / stop / status / self-test` を実装し、常駐運用を成立させる。
- M2/M3だけでは完了ではなく、M4の常駐管理と実読み上げ確認までを今回の完了条件にします。

## CLI仕様

- `codex-voicevox-watch start`: 既存sessionファイルは末尾から開始し、新着のみ監視します。
- `codex-voicevox-watch stop`: pidファイルのプロセスへ終了要求を送ります。
- `codex-voicevox-watch status`: pid、生存状態、最終読み上げ時刻、VOICEVOX疎通状態を表示します。
- `codex-voicevox-watch say "テキスト"`: VOICEVOX再生単体テスト用です。
- `codex-voicevox-watch self-test`: 抽出・除外・dry-run読み上げを検証します。

## 実装方針

- Python 3.12標準ライブラリのみで単一ファイル実装にします。
- 状態は `~/.local/state/codex-voicevox-watch/` 配下に `watch.pid`、`state.json`、`watch.log` として保存します。
- JSONLでは `response_item` の `payload.type == "message"` かつ `role == "assistant"` の `output_text` だけを基本対象にします。
- `function_call`、`function_call_output`、`reasoning`、`token_count`、`session_meta`、user入力は既定で読みません。
- Markdownのコードブロック、長い箇条書き、ファイル一覧、diff風テキストは除去し、長文は句点単位で短く切ります。
- VOICEVOX呼び出しは、本文をUTF-8 base64でPowerShellへ渡し、`/audio_query`、`/synthesis`、`Media.SoundPlayer.PlaySync()` の順で再生します。

## テスト計画

- `python3 -m py_compile ~/bin/codex-voicevox-watch`
- `~/bin/codex-voicevox-watch say "Codex読み上げテストです。"`
- `~/bin/codex-voicevox-watch self-test`
- `~/bin/codex-voicevox-watch start`、`status`、`stop` の往復確認
- 実Codexセッションで短いassistant応答を発生させ、新着のみが読み上げられ、過去ログが読まれないことを確認します。

## 前提

- Windows側VOICEVOX GUIまたはEngineが起動済みで、PowerShellから `http://127.0.0.1:50021/version` に接続できる前提です。
- 今回はsystemd user serviceやシェル起動時自動登録までは入れず、`start` を一度実行すれば以後のCodex操作で意識せず読み上げられる範囲にします。
- この作業ディレクトリはGitリポジトリではないため、コミットは行いません。
