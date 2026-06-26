// poster.typ — エントリーポイント（学生は触らないでください）
#import "template/tml-poster.typ": *
#import "content.typ": *

#show: tml-poster.with(
  title:    poster-title,
  subtitle: poster-subtitle,
  authors:  poster-authors,
  affil:    poster-affil,
  conf:     poster-conf,
  contact:  poster-contact,
  funding:  poster-funding,
)

// ── ポスターレイアウト ────────────────────────────────────────────────
// section(タイトル, 内容)               → 1カラム（デフォルト）
// section(タイトル, 内容, span: 2)     → 全幅（2カラム幅）
// section(タイトル, 内容, accent: true) → アクセントカラーのバー
// 上から左→右の順でセルが埋まります。
// ────────────────────────────────────────────────────────────────────
// フローモード（左右カラムが独立した高さ）。左=背景→問題→提案、右=主結果→補助→まとめ。
#poster-body(
  flow: true,
  // 左カラム                          // 右カラム
  section([1. 研究背景と目的], sec-background),
  section([4. 主結果：seed 普遍な解釈軸 ★], sec-results, accent: true),
  section([2. 問題：軸の向きが seed でバラつく], sec-problem),
  section([5. 補助検証：量の単調性と汎化], sec-aux),
  section([3. 提案：整合損失（align loss）★], sec-method, accent: true),
  section([6. 限界と今後／まとめ ★], sec-conclusion, accent: true),
)
