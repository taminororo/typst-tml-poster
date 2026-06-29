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
// 3バンド構成: [1,2,3]を左右に → 主結果4を全幅バナー → [5,6]を左右に。
// 重い2節（4の表・5の図）を別バンドに分け、右カラム集中の溢れを解消。
#poster-body(
  flow: true,
  section([1. 研究背景と目的], sec-background),
  section([2. 問題：軸の向きが seed でバラつく], sec-problem),
  section([3. 提案：整合損失（align loss）★], sec-method, span: 2, accent: true),
  section([4. 主結果：seed 普遍な解釈軸 ★], sec-results, span: 2, accent: true),
  section([5. y軸の解釈：固定後の縦軸は何か], sec-zy),
  section([6. 限界と本丸の課題：陽 vs 潜在 ★], sec-conclusion, accent: true),
)
