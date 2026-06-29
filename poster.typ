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
// 純2カラム構成。左カラム＝1,2,3（背景→問題→提案）、右カラム＝4,5,6（主結果→y軸→限界）。
// 左を読み下げ、次に右を読み下げる標準的な学会ポスターの読み順。
// hero（提案3・主結果4）はアクセント色で強調。
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5cm,
  align: top,
  // ── 左カラム ──
  stack(
    spacing: 1.5cm,
    section([1. 研究背景と目的], sec-background).content,
    section([2. 問題：軸の向きが seed に対して不安定である], sec-problem).content,
    section([3. 提案：横軸を通信量変化に整合させる補助損失], sec-method, accent: true).content,
  ),
  // ── 右カラム ──
  stack(
    spacing: 1.5cm,
    section([4. 主結果：横軸が通信量変化と整合し、seed に対して安定化する], sec-results, accent: true).content,
    section([5. y軸の解釈：固定後の縦軸が表す構造], sec-zy).content,
    section([6. 限界と今後の課題：陽な表現と潜在表現], sec-conclusion).content,
  ),
)
