VOICEVOXなら、具体的には **ローカルでVOICEVOX Engineを起動 → HTTP APIでwav生成 → 再生** です。VOICEVOX EngineはHTTPサーバーなので、`/audio_query`と`/synthesis`にリクエストすればCLIから音声生成できます。公式READMEにもこのcurl例があります。([GitHub][1])

## 1. VOICEVOX Engineを起動する

GUI版VOICEVOXを起動していれば、多くの場合 `127.0.0.1:50021` でAPIが使えます。Dockerで起動するならCPU版はこれです。Docker Hub / GitHub READMEにも同等の起動例があります。([Docker Hub][2]) ([GitHub][1])

```bash
docker run --rm -p '127.0.0.1:50021:50021' voicevox/voicevox_engine:cpu-latest
```

起動確認：

```bash
curl -s http://127.0.0.1:50021/speakers | python3 -m json.tool | head
```

`speaker`に指定する値は、`/speakers`で返る各話者スタイルの`id`です。公式READMEでも、`speaker`は`/speakers`で得られるスタイル情報の`id`だと説明されています。([GitHub][1])

例として、よく使われる `ずんだもん ノーマル` は環境にもよりますが `speaker=3` のことが多いです。固定で決め打ちせず、まず `/speakers` で確認するのが安全です。

## 2. 最小のcurl例

```bash
echo -n "Codexの作業が完了しました。" > /tmp/text.txt

curl -s \
  -X POST \
  "http://127.0.0.1:50021/audio_query?speaker=3" \
  --get --data-urlencode text@/tmp/text.txt \
  > /tmp/query.json

curl -s \
  -H "Content-Type: application/json" \
  -X POST \
  -d @/tmp/query.json \
  "http://127.0.0.1:50021/synthesis?speaker=3" \
  > /tmp/voicevox.wav
```

WSL2からWindowsで再生するなら：

```bash
powershell.exe -NoProfile -Command \
  "(New-Object Media.SoundPlayer '$(wslpath -w /tmp/voicevox.wav)').PlaySync()"
```

Linux側で再生するなら：

```bash
paplay /tmp/voicevox.wav
# または
aplay /tmp/voicevox.wav
```

## 3. 汎用ラッパー `vv-say.sh`

まずこれを作ると使い回せます。

```bash
mkdir -p ~/bin
nano ~/bin/vv-say.sh
```

中身：

```bash
#!/usr/bin/env bash
set -euo pipefail

ENGINE="${VOICEVOX_ENGINE:-http://127.0.0.1:50021}"
SPEAKER="${VOICEVOX_SPEAKER:-3}"

TEXT="${1:-}"
if [ -z "$TEXT" ]; then
  TEXT="$(cat)"
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

printf '%s' "$TEXT" > "$TMPDIR/text.txt"

curl -sS \
  -X POST \
  "$ENGINE/audio_query?speaker=$SPEAKER" \
  --get --data-urlencode text@"$TMPDIR/text.txt" \
  > "$TMPDIR/query.json"

curl -sS \
  -H "Content-Type: application/json" \
  -X POST \
  -d @"$TMPDIR/query.json" \
  "$ENGINE/synthesis?speaker=$SPEAKER" \
  > "$TMPDIR/out.wav"

if command -v powershell.exe >/dev/null 2>&1; then
  WIN_WAV="$(wslpath -w "$TMPDIR/out.wav")"
  powershell.exe -NoProfile -Command \
    "(New-Object Media.SoundPlayer '$WIN_WAV').PlaySync()" >/dev/null
elif command -v paplay >/dev/null 2>&1; then
  paplay "$TMPDIR/out.wav"
elif command -v aplay >/dev/null 2>&1; then
  aplay "$TMPDIR/out.wav"
else
  cp "$TMPDIR/out.wav" ./voicevox_out.wav
  echo "再生コマンドが見つからないため ./voicevox_out.wav に保存しました"
fi
```

権限付与：

```bash
chmod +x ~/bin/vv-say.sh
```

利用例：

```bash
~/bin/vv-say.sh "テストです。Codexの結果を読み上げます。"
```

話者を変える場合：

```bash
VOICEVOX_SPEAKER=47 ~/bin/vv-say.sh "ナースロボタイプTで読み上げます。"
```

## 4. Codex CLIの最終結果だけ読み上げる

実用上はこれが一番よいです。

```bash
codex exec -o /tmp/codex_last.txt \
  "このリポジトリのテスト失敗原因を確認し、最後に読み上げ用の要約を120字以内で出力してください。"

~/bin/vv-say.sh "$(cat /tmp/codex_last.txt)"
```

ただしCodexの出力が長いと読み上げがだるくなります。最初からCodexにこう指示するのがよいです。

```bash
codex exec -o /tmp/codex_speech.txt \
  "作業してください。最後の出力は、読み上げ用に120字以内で、完了/失敗/次に必要な操作だけを書いてください。"

~/bin/vv-say.sh "$(cat /tmp/codex_speech.txt)"
```

## 5. テスト失敗時だけ読み上げる例

```bash
if pnpm test; then
  ~/bin/vv-say.sh "テストは成功しました。"
else
  ~/bin/vv-say.sh "テストに失敗しました。ログを確認してください。"
fi
```

Codexと合わせるなら：

```bash
codex exec -o /tmp/codex_last.txt \
  "pnpm testを実行し、失敗した場合は原因を調査してください。最後に読み上げ用要約だけを出してください。"

~/bin/vv-say.sh "$(tail -n 5 /tmp/codex_last.txt)"
```

## 6. 長文を雑に分割して読む例

VOICEVOX自体はVOICEPEAKのような「140文字制限」ではないですが、CLI通知用途では短く分割したほうが聞きやすいです。

```bash
cat /tmp/codex_last.txt | fold -s -w 120 | while read -r line; do
  [ -z "$line" ] && continue
  ~/bin/vv-say.sh "$line"
done
```

ただし、これは改行・コード・diffをそのまま読むので、実運用ではおすすめしません。Codexに「読み上げ用要約」を作らせるほうが安定します。

## 7. WSL2でVOICEVOXがWindows側にある場合

Windows側のVOICEVOX GUIを起動していて、WSLから `127.0.0.1:50021` に繋がらない場合があります。その場合はWindowsホスト側IPを使います。

```bash
export WINDOWS_HOST=$(awk '/nameserver/ { print $2; exit }' /etc/resolv.conf)
export VOICEVOX_ENGINE="http://${WINDOWS_HOST}:50021"

curl -s "$VOICEVOX_ENGINE/speakers" | python3 -m json.tool | head
```

その状態で：

```bash
VOICEVOX_ENGINE="$VOICEVOX_ENGINE" ~/bin/vv-say.sh "WSLからWindows側のVOICEVOXを呼び出しています。"
```

## 実用構成

Codex CLI連携なら、私はこの運用にします。

```text
読む:
- 作業完了
- approval待ち
- テスト失敗
- エラー要約
- 次に人間が判断すべきこと

読まない:
- diff全文
- npm installログ
- stack trace全文
- ファイル一覧
- Codexの長い説明
```

VOICEVOXは商用・非商用問わず無料と案内されていますが、各キャラクターの利用規約確認とクレジット表記が必要です。公式サイトにも「各キャラクターの利用規約参照」とあり、Docker Hub側にも「作成音声は各音声ライブラリの規約に従う」「クレジット表記が必要」と記載されています。([voicevox.hiroshiba.jp][3]) ([Docker Hub][2])

[1]: https://github.com/VOICEVOX/voicevox_engine "GitHub - VOICEVOX/voicevox_engine: 無料で使える中品質なテキスト読み上げソフトウェア、VOICEVOXの音声合成エンジン · GitHub"
[2]: https://hub.docker.com/r/voicevox/voicevox_engine "voicevox/voicevox_engine - Docker Image"
[3]: https://voicevox.hiroshiba.jp/ "VOICEVOX | 無料のテキスト読み上げ・歌声合成ソフトウェア"
