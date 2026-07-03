# Codex VOICEVOX Watch

Codex VOICEVOX Watchは、Codex CLIのセッションログを監視し、新しいassistant応答をVOICEVOXで読み上げるローカルCLIです。通常のCodex操作は変えず、バックグラウンドで起動しておく使い方を想定しています。

## できること

- Codexの新着assistant応答だけを読み上げる
- 過去ログ、tool出力、reasoning、diff、コードブロックを既定で読まない
- `start` / `stop` / `status` で常駐状態を管理する
- VOICEVOXの話者、速度、音量、抑揚などを永続設定する
- インストールとアンインストールをスクリプトで再現する

## 前提環境

- WSL上のPython 3
- Windows側で起動しているVOICEVOX GUIまたはVOICEVOX Engine
- PowerShellから `http://127.0.0.1:50021/version` に接続できること
- Codex CLIが `~/.codex/sessions/` にセッションJSONLを保存していること

疎通確認:

```bash
powershell.exe -NoProfile -Command 'Invoke-RestMethod -Uri "http://127.0.0.1:50021/version"'
```

## インストール

既定では `~/.local/bin/codex-voicevox-watch` にコマンド入口を作ります。

```bash
scripts/install.sh
```

`~/.local/bin` にPATHが通っていない場合は、シェル設定に追加してください。

```bash
export PATH="$HOME/.local/bin:$PATH"
```

任意のprefixへ入れる場合:

```bash
scripts/install.sh --prefix "$HOME/.local"
```

## クイックスタート

VOICEVOXで単発再生します。

```bash
codex-voicevox-watch say "Codex読み上げテストです。"
```

バックグラウンド監視を開始します。

```bash
codex-voicevox-watch start
```

状態を確認します。

```bash
codex-voicevox-watch status
```

停止します。

```bash
codex-voicevox-watch stop
```

## 基本コマンド

```bash
codex-voicevox-watch start
codex-voicevox-watch stop
codex-voicevox-watch status
codex-voicevox-watch say "読み上げるテキスト"
codex-voicevox-watch self-test
```

`start` は起動時点の既存セッションを末尾から監視するため、過去ログを読み上げません。

## 設定

設定ファイルの場所:

```bash
codex-voicevox-watch config path
```

現在の有効設定:

```bash
codex-voicevox-watch config show
```

読み上げ速度を変更:

```bash
codex-voicevox-watch config set speed_scale 1.2
```

話者IDを変更:

```bash
codex-voicevox-watch config set speaker 3
```

主な設定キー:

| key | 既定値 | 内容 |
| --- | --- | --- |
| `engine` | `http://127.0.0.1:50021` | VOICEVOX Engine URL |
| `speaker` | `3` | VOICEVOX話者スタイルID |
| `max_chars` | `180` | 1回の最大読み上げ文字数 |
| `speed_scale` | `1.0` | 読み上げ速度 |
| `pitch_scale` | `0.0` | 音高 |
| `intonation_scale` | `1.0` | 抑揚 |
| `volume_scale` | `1.0` | 音量 |
| `pre_phoneme_length` | `0.1` | 読み上げ前の無音長 |
| `post_phoneme_length` | `0.1` | 読み上げ後の無音長 |
| `pause_length_scale` | `1.0` | ポーズ長の倍率 |
| `poll_seconds` | `1.0` | セッション監視間隔 |

## 状態ファイル

`status` で、設定、状態、ログ、Codexセッションディレクトリの場所を確認できます。

既定の保存先:

```text
~/.config/codex-voicevox-watch/config.json
~/.local/state/codex-voicevox-watch/state.json
~/.local/state/codex-voicevox-watch/watch.log
```

## アンインストール

```bash
codex-voicevox-watch stop
scripts/uninstall.sh
```

任意prefixから削除する場合:

```bash
scripts/uninstall.sh --prefix "$HOME/.local"
```

設定や状態ファイルは自動削除しません。不要なら手動で削除してください。

```bash
rm -rf ~/.config/codex-voicevox-watch
rm -rf ~/.local/state/codex-voicevox-watch
```

## トラブルシュート

`voicevox=error` になる場合は、Windows側でVOICEVOXが起動しているか確認してください。

```bash
codex-voicevox-watch status
```

音が出ない場合は、単発再生で切り分けます。

```bash
codex-voicevox-watch say "音声テストです。"
```

過去ログが読まれる場合は、一度停止してから再起動してください。`start` は起動時点の既存ログを読み飛ばします。

```bash
codex-voicevox-watch stop
codex-voicevox-watch start
```
