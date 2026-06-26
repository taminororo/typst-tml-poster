# CLAUDE.md — Typst Lab Poster Template（機械学習理論研究室）

## このプロジェクトの目的

長岡技術科学大学 機械学習理論研究室（雲居研）の**学会ポスター発表用Typstテンプレート**を構築する。

- 対象：A0縦（841×1189mm）学会ポスター
- 使用者：研究室の学生（Typst未経験でも使えること）
- 目標：学生がコンテンツだけ書けば、ラボブランドに統一されたポスターが出力される

---

## ゴール定義（Done の条件）

1. `typst compile poster.typ` 一発でA0 PDFが出力される
2. 学生が編集するのは `content.typ` のみ（レイアウト・色・ロゴには触れない）
3. 数式（KaTeX相当）・日本語・英語が混在しても崩れない
4. QRコード（外部画像 or CeTZ代替）が貼れる
5. `README.md` に「5分で使えるクイックスタート」が書かれている

---

## ファイル構成（目標とする構造）

```
typst-tml-poster/
├── CLAUDE.md              ← このファイル
├── README.md              ← 学生向けクイックスタート
├── poster.typ             ← エントリーポイント（触らない）
├── template/
│   ├── tml-poster.typ     ← レイアウト定義（触らない）
│   └── colors.typ         ← カラーパレット定義（触らない）
├── content.typ            ← ★学生が編集するファイル
├── assets/
│   ├── logo-nut.png       ← 長岡技科大ロゴ（差し替え用プレースホルダでOK）
│   └── sample-figure.png  ← サンプル図（プレースホルダでOK）
└── examples/
    └── sample-output.pdf  ← コンパイル済みサンプル（あれば理想）
```

---

## デザイン仕様

### カラーパレット（academic-tml テーマ準拠）

```typst
// template/colors.typ
#let tml-blue     = rgb("#1a3a6b")   // ヘッダー・ボックス枠
#let tml-accent   = rgb("#e8a020")   // アクセント（バー・ハイライト）
#let tml-light    = rgb("#eef2f8")   // ボックス背景（薄い青）
#let tml-text     = rgb("#1a1a2e")   // 本文テキスト
#let tml-white    = white
#let tml-gray     = rgb("#6c757d")   // キャプション・補足
```

### ページ設定

```typst
#set page(
  width: 84.1cm,
  height: 118.9cm,
  margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm),
)
#set text(
  font: ("Noto Sans CJK JP", "New Computer Modern", "Hiragino Kaku Gothic ProN"),
  size: 28pt,
  lang: "ja",
)
```

### レイアウト構成

```
┌──────────────────────────────────────────────────────┐
│  HEADER                                              │  高さ: ~12cm
│  [ロゴ左]  タイトル（大）/ 著者 / 所属  [ロゴ右]    │
├──────────┬──────────────────────────┬────────────────┤
│ 左カラム  │     中央カラム            │  右カラム      │  高さ: ~95cm
│  (1fr)   │       (1.2fr)             │  (1fr)         │
│          │                           │                │
│ 研究背景  │ 提案手法                  │ 実験結果       │
│ 関連研究  │ 理論的枠組               │ 考察           │
│          │                           │ 結論           │
│          │                           │ QRコード       │
├──────────┴──────────────────────────┴────────────────┤
│  FOOTER: 学会名 / 連絡先 / 資金源（科研費等）        │  高さ: ~4cm
└──────────────────────────────────────────────────────┘
```

3カラムが基本。content.typで `num-columns: 2` 指定で2カラムに切り替え可能にする。

---

## content.typ のインターフェース設計（学生が書く部分）

学生が書くファイルはこのような形にする：

```typst
// content.typ — ここだけ書けばポスターが完成する

// ===== メタ情報 =====
#let poster-title    = [吸収マルコフ連鎖によるWebコンバージョン経路の分析]
#let poster-subtitle = [Analyzing Web Conversion Paths via Absorbing Markov Chains]
#let poster-authors  = [山田 太郎¹, 雲居 玄道¹]
#let poster-affil    = [¹長岡技術科学大学 情報・経営システム工学専攻]
#let poster-conf     = [電子情報通信学会 2026年総合大会]
#let poster-funding  = [科学研究費補助金 基盤研究(B) 00000000]

// ===== セクション =====
#let sec-background = [
  == 研究背景

  Webサイトのユーザ行動を確率過程として捉え...
  
  #figure(image("assets/sample-figure.png", width: 90%),
    caption: [提案する状態遷移モデル])
]

#let sec-method = [
  == 提案手法

  吸収マルコフ連鎖 $bold(P)$ を以下のように定義する：

  $ bold(P) = mat(bold(Q), bold(R); bold(0), bold(I)) $

  基本行列 $bold(N) = (bold(I) - bold(Q))^(-1)$ から...
]

// ... 以降同様に sec-results, sec-conclusion など
```

---

## 実装タスク（優先順）

### Phase 1: 最小動作確認（ここから始める）

- [ ] `typst` のインストール確認（`brew install typst` または `cargo install typst-cli`）
- [ ] `typst init` で空プロジェクト作成
- [ ] `template/colors.typ` を作成し、カラー変数を定義
- [ ] A0ページサイズ・フォント設定が正しく動くか確認
- [ ] 日本語テキストが文字化けしないか確認

### Phase 2: レイアウト構築

- [ ] `template/tml-poster.typ` にヘッダー関数を実装
  - ロゴ（左）、タイトル・著者・所属（中）、ロゴ（右）の3分割
  - 背景色: `tml-blue`、テキスト色: `tml-white`
- [ ] 3カラムグリッドを実装
  - `#grid(columns: (1fr, 1.2fr, 1fr), gutter: 1.5cm)` をベースに
  - カラム内部でセクションが縦に積まれる構造
- [ ] フッターを実装（学会名・連絡先・資金源）

### Phase 3: コンポーネント

- [ ] セクションボックス: ヘッダーバー（`tml-blue`）+ 本文エリア（`tml-light` 背景）
- [ ] ハイライトボックス（key finding用）: `tml-accent` のボーダー
- [ ] figure + caption のスタイル調整（中央揃え、キャプション小文字）
- [ ] 数式レンダリングの確認（インライン `$...$` とブロック `$ ... $` の両方）

### Phase 4: content.typ インターフェース確立

- [ ] `poster.typ` で `content.typ` をimportして値を参照するパターンを確立
- [ ] サンプルコンテンツ（ECOC or マルコフ連鎖の内容）で実際にコンパイル
- [ ] 2カラムオプションのサポート追加

### Phase 5: ドキュメント整備

- [ ] `README.md` にクイックスタート（インストール→コンパイルまで）
- [ ] `content.typ` にコメントで各フィールドの説明を記載
- [ ] GitHubリポジトリへのプッシュ（`moiku/typst-tml-poster` を想定）

---

## 技術的注意点

### フォント
Noto Sans CJK JP が利用可能な環境前提。ない場合のフォールバックとして以下の順で試す：
```typst
font: ("Noto Sans CJK JP", "Hiragino Kaku Gothic ProN", "Yu Gothic", "New Computer Modern")
```

### パッケージの使い方
Typst Universeのパッケージは `#import "@preview/パッケージ名:バージョン": *` で導入。
オフライン環境（tml1等）では事前に `typst init` でキャッシュしておく必要がある。

### 参考にするTypst Universeパッケージ
| パッケージ | 用途 | 備考 |
|---|---|---|
| `simple-research-poster` | ベース実装の参考 | 構造の参考にするだけでも可 |
| `cetz` | 図・ダイアグラムのネイティブ描画 | 状態遷移図に使える |
| `qr-code` | QRコード生成 | 必要なら |

### 既存Marpテーマとの関係
academic-tml CSSの色定義（`#1a3a6b`, `#e8a020`）を流用。
フォント・色の変数は将来的に `lab-theme.typ` として両方から参照できる形にする（将来課題）。

---

## 環境情報

| 項目 | 値 |
|---|---|
| Mac Studio ユーザー名 | `gendo` |
| Mac Studio ホスト | `mac-studio.local` |
| 主要作業ディレクトリ | `~/projects/typst-tml-poster/` |
| GitHubユーザー | `moiku` |
| noreply email | `3541841+moiku@users.noreply.github.com` |
| Typst インストール方法 | `brew install typst` |

---

## 完成後のスキル化

このプロジェクトが完成したら、以下を作成する：

```
/mnt/skills/organization/typst-tml-poster/SKILL.md
```

SKILL.mdの`description`（Claude Code発火条件）：
> 研究室のポスター発表資料を作りたい、Typstでポスターを作りたい、学会ポスターのテンプレートが必要、などのキーワードでトリガー。

---

## よくある詰まりポイントと対処法

| 症状 | 原因 | 対処 |
|---|---|---|
| 日本語が豆腐（□□□）になる | フォント未インストール | `brew install font-noto-sans-cjk-jp` |
| A0でコンパイルが遅い | 初回キャッシュ生成 | 2回目以降は速い、待つ |
| 数式が崩れる | フォントの欠け | `#set math.equation(font: "New Computer Modern Math")` を試す |
| カラムが崩れる | コンテンツが長すぎる | `block(height: auto)` ではなく固定高さに調整 |
| パッケージが見つからない | オフライン | `~/.cache/typst/` のキャッシュを確認 |
