# TML Lab Poster Template

長岡技術科学大学 機械学習理論研究室（TML Lab）の学会ポスター発表用 Typst テンプレートです。  
`content.typ` を書き換えるだけで，ラボブランドに統一された A0 縦ポスターが完成します。

---

## サンプル出力

→ [`examples/poster-sample.pdf`](examples/poster-sample.pdf)

---

## クイックスタート（5分）

### 1. リポジトリを clone

```bash
git clone https://github.com/TMLlaboratory/typst-tml-poster.git
cd typst-tml-poster
```

### 2. Typst をインストール

**macOS (Homebrew)**
```bash
brew install typst
```

**Windows (winget)**
```powershell
winget install Typst.Typst
```

**Windows (Scoop)**
```powershell
scoop install typst
```

### 3. コンパイル

```bash
typst compile poster.typ
```

カレントディレクトリに `poster.pdf` が生成されます。

---

## VSCode での編集（推奨）

1. VSCode に拡張機能 **[Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist)** をインストール
2. `poster.typ` を開く
3. コマンドパレット（Cmd/Ctrl+Shift+P）→ **"Typst: Show preview"** でライブプレビュー表示
4. ファイル保存のたびに自動で再コンパイルされます

### ライブコンパイル（ターミナル）

```bash
typst watch poster.typ
```

---

## ポスターの編集方法

**編集するファイルは `content.typ` だけです。**  
その他のファイル（`poster.typ`, `template/` 以下）は触らないでください。

### メタ情報

```typst
#let poster-title    = [あなたの研究タイトル]
#let poster-subtitle = [English subtitle]
#let poster-authors  = [著者名¹, 共著者名¹]
#let poster-affil    = [¹所属大学・専攻]
#let poster-conf     = [学会名・大会名]
#let poster-contact  = [your\@email.example.com]  // @ は \@ と書く
#let poster-funding  = [科研費 基盤研究(B) 番号]
```

> **注意**: メールアドレスの `@` は Typst では `\@` と書きます。

### セクション内容

各セクション（`sec-background`, `sec-method`, `sec-results`, `sec-conclusion`）を  
Typst マークアップで記述します。

```typst
#let sec-background = [
  ここに研究背景を書きます。*太字* や _イタリック_ も使えます。

  // キー Finding ボックス
  #highlight-box[
    *Key Finding:* 重要な発見をここに書く
  ]

  // 数式（インライン）
  モデル $bold(P) = mat(bold(Q), bold(R); bold(0), bold(I))$ を...

  // 数式（ブロック）
  $ bold(N) = (bold(I) - bold(Q))^(-1) $

  // 図の挿入
  #figure(
    image("assets/your-figure.png", width: 90%),
    caption: [図のキャプション],
  )
]
```

### レイアウト変更（`poster.typ` の末尾）

`poster.typ` の `#poster-body(...)` 部分でセクションの配置を調整します。

#### グリッドモード（デフォルト）— 同じ行のボックスは高さが揃う

```typst
#poster-body(
  // span: 1（デフォルト）= 片側カラム。左→右・上→下の順に自動配置
  section[研究背景][#sec-background],
  section[提案手法][#sec-method],

  // span: 2 = 全幅。先頭・中間・末尾の任意の位置に置ける
  section([中間まとめ], sec-mid, span: 2),

  section[実験設定][#sec-experiment],
  section[実験結果][#sec-results],

  // accent: true = タイトルバーをオレンジにする
  section([まとめ], sec-conclusion, span: 2, accent: true),
)
```

同じ行の左右ボックスは最大の高さに揃います。

#### フローモード — 左右カラムが独立した高さになる

```typst
#poster-body(
  flow: true,                              // ← これだけ追加
  section([前書き], sec-intro, span: 2),  // 全幅は任意の位置に置ける
  section[研究背景][#sec-background],     // 左カラム（高さ独立）
  section[提案手法][#sec-method],         // 右カラム（高さ独立）
  section[実験設定][#sec-experiment],
  section[実験結果][#sec-results],
  section([まとめ], sec-conclusion, span: 2, accent: true),
)
```

各ボックスがコンテンツ量に応じた自然な高さになります。  
左右の高さが揃わないため、対応関係を示したい場合はグリッドモードが適しています。

---

## カラーパレット

`template/colors.typ` で定義（変更は上級者向け）

| 変数 | カラー | 用途 |
|------|--------|------|
| `tml-blue` | `#1a3a6b` | ヘッダー，セクションバー |
| `tml-accent` | `#e8a020` | アクセントバー，強調 |
| `tml-light` | `#eef2f8` | セクション本文背景 |
| `tml-text` | `#1a1a2e` | 本文テキスト |
| `tml-gray` | `#6c757d` | キャプション，補足 |

---

## フォント

| 環境 | フォント |
|------|---------|
| macOS | Hiragino Sans（標準搭載，追加不要） |
| Windows | Yu Gothic（標準搭載）または Noto Sans CJK JP |
| Linux | Noto Sans CJK JP（要インストール）|

### Noto Sans CJK JP のインストール

```bash
# macOS
brew install --cask font-noto-sans-cjk-jp

# Ubuntu / Debian
sudo apt install fonts-noto-cjk
```

---

## トラブルシュート

| 症状 | 原因 | 対処 |
|------|------|------|
| 日本語が □□□ になる | フォント未インストール | 上記「フォント」節を参照 |
| `@` の後が赤エラー | `@` がラベル参照として解釈 | `\@` と書く |
| 数式が崩れる | 数式フォント欠け | `typst fonts` で確認，New Computer Modern がなければ `typst fonts --variants` |
| コンテンツが 2 ページになる | 内容が多すぎる | 各セクションを短くするか，図のサイズを縮小 |
| パッケージが見つからない | オフライン環境 | 事前に `typst compile` 実行済みの PC のキャッシュ（`~/.cache/typst/`）をコピー |
| コンパイルが遅い | 初回キャッシュ生成 | 2 回目以降は速い，そのまま待つ |

---

## ファイル構成

```
typst-tml-poster/
├── poster.typ          ← エントリーポイント（触らない）
├── content.typ         ← ★ここだけ書き換える
├── template/
│   ├── tml-poster.typ  ← レイアウト定義（触らない）
│   └── colors.typ      ← カラーパレット（触らない）
├── assets/
│   ├── logo-tml.png    ← TML Lab ロゴ
│   ├── logo-nut.jpg    ← 長岡技科大ロゴ
│   └── sample-figure.png ← サンプル図（差し替えてください）
└── examples/
    └── poster-sample.pdf ← コンパイル済みサンプル
```

---

## 自分のポスターの管理

このリポジトリを直接編集するのではなく，**fork して自分のリポジトリで管理**することを推奨します。

```bash
# このリポジトリを fork → clone
git clone https://github.com/<your-account>/typst-tml-poster.git
cd typst-tml-poster

# content.typ を編集してコンパイル
typst compile poster.typ
```

---

## ライセンス

TML Lab（雲居研究室）内部利用。外部公開時は指導教員に確認してください。
