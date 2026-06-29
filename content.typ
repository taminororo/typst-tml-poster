// ======================================================================
// content.typ — ★ここだけ書き換えればポスターが完成します
// 内容の出所: digress-research/docs/ポスター本文_2026-06-26.md（検証済み数値）
// ======================================================================
#import "template/tml-poster.typ": highlight-box
#import "template/colors.typ": tml-gray, tml-accent, tml-blue, tml-light

// ── メタ情報 ──────────────────────────────────────────────────────────

#let poster-title    = [潜在空間の軸に「意味」を立てる]
#let poster-subtitle = [整合損失で「通信量の変化」を seed 普遍に固定する — GraphVAE 組織グラフの解釈軸を 10 seed で安定化し、潜在のまま読む課題へ]
#let poster-authors  = [上林 英佑]
#let poster-affil    = [情報・経営システム工学分野 B4 ／ 機械学習理論研究室（TML）／ 指導教員: 雲居 玄道 ／ 学籍番号 23103285]
#let poster-conf     = [機械学習理論研究室（TML）学内ポスター発表]
#let poster-contact  = [上林 英佑（学籍番号 23103285）・指導教員: 雲居 玄道]
#let poster-funding  = [整合損失 (align loss) ／ GraphVAE 潜在空間の解釈軸]

// ── 3連スタッツ（keybox）コンポーネント ──────────────────────────────
#let stat-box(value, label) = block(
  width: 100%,
  fill: tml-light,
  inset: (x: 8pt, y: 7pt),
  stroke: (top: (thickness: 3pt, paint: tml-accent)),
  align(center + horizon)[
    #text(size: 24pt, weight: "bold", fill: tml-accent)[#value]
    #v(0.15cm)
    #text(size: 15pt, fill: tml-gray)[#label]
  ],
)

// ── セクション内容 ────────────────────────────────────────────────────

// Card 1: 研究背景と目的
#let sec-background = [
  組織の *Slack 通信グラフ* を GraphVAE で 2 次元の潜在ベクトル $bold(z)_g = (z_x, z_y)$ に圧縮する。
  狙いは潜在空間で *「この方向に進むとこういう組織になる、どっちに行きたいか」* を示すこと
  （若月研究の「理想組織へ向かえ」を、*方向そのものに意味* を持たせる形へ）。それには軸が seed で安定して解釈できる必要がある。

  *なぜ潜在空間のままか:* 新組織ではどの軸（特徴）が効くか事前に分からない。
  だから手で特徴を選ぶ *陽な空間* でなく、データから軸を学ぶ *潜在空間* にしておきたい。

  #text(size: 16pt, fill: tml-gray)[
    *入力:* ノード＝メンバー（学年/役割つき）、エッジ＝2人間の通信量。
    base 33 件（実組織 28 ＋ 理想型 5）＋ 通信量を増減した UP/DOWN 拡張（$N=1\~7$）。
  ]

  #highlight-box[
    *問い:* 潜在軸の「方向＝意味」は、乱数 seed を変えても安定して成り立つか？
  ]
]

// Card 2: 問題提起（seed で軸がバラバラ）
#let sec-problem = [
  *UP / DOWN 拡張*（通信を増減したグラフ）の潜在移動の *向き（角度）* を測る。
  当初は「seed ごとの回転だけ」と思ったが、実際は *ばらつき自体が大きく方向＝意味が成立しない*。

  #figure(
    image("assets/seed_compare.png", width: 70%),
    caption: [*10 seed の潜在空間 $bold(z)_g$*。★=元グラフ、点=拡張（色=元組織）。配置・向きが seed ごとに変わる。],
  )

  baseline の向きの seed 間ばらつき（円周標準偏差）は組織により *60〜99°* で、「方向＝意味」が立たない。
  #text(size: 16pt, fill: tml-gray)[*$N$:* 通信量を増減した本数。UP=$+N$, DOWN=$-N$。]
]

// Card 3: 提案手法（整合損失）
#let sec-method = [
  各グラフに *符号付き変化量* $t$（UP は $+N$, DOWN は $-N$, 元組織は $0$）を与え、
  横軸 $z_x$ と $t$ の *Pearson 相関* $rho_"align"$ を最大化する損失を 1 本足して *学習し直す*。

  $ cal(L)_"align" = - rho_"align"(z_x, t), quad cal(L)_"total" = cal(L)_"rec" + beta cal(L)_"KL" + lambda cal(L)_"align" $

  *MSE でなく相関* なのは、VAE の KL が潜在スケールを縮めるため「順序・向き」だけ要求すれば衝突しにくいから。拘束は横軸 $z_x$ のみ、係数 $lambda$ で調整。

  #text(size: 15pt, fill: tml-gray)[実装: `compute_align_loss()`, `train.py:133–150 @cedb973`]
]

// Card 4: 主結果（本丸）
#let sec-results = [
  整合損失で 10 seed 再学習すると *2 つが同時に起きる*：
  (1) 横軸 $z_x$ と符号付き $N$ の相関 $rho_x$ が上がる＝*横軸が解釈可能に*、
  (2) seed 毎の向きの標準偏差が下がる＝*方向＝意味が安定に近づく*。疎な 4 組織 × 10 seed。

  #table(
    columns: (1.5fr, 1fr, 1fr, 1.4fr),
    inset: (x: 8pt, y: 7pt),
    align: (left, center, center, center),
    stroke: (paint: tml-blue, thickness: 0.6pt),
    fill: (col, row) =>
      if row == 0 { tml-blue }
      else if calc.odd(row) { tml-light }
      else { white },
    table.header(
      text(fill: white, weight: "bold", size: 18pt)[組織構造],
      text(fill: white, weight: "bold", size: 18pt)[baseline $rho_x$],
      text(fill: white, weight: "bold", size: 18pt)[align $rho_x$],
      text(fill: white, weight: "bold", size: 18pt)[角度 std\ base→align],
    ),
    [modular],      [+0.34], text(fill: tml-accent, weight: "bold")[+0.95], [60°→25°],
    [hub],          [+0.40], text(fill: tml-accent, weight: "bold")[+0.94], [73°→19°],
    [hierarchical], [−0.02], text(fill: tml-accent, weight: "bold")[+0.88], [84°→14°],
    [mentorship],   [+0.08], text(fill: tml-accent, weight: "bold")[+0.91], [99°→17°],
  )

  #v(0.2cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.4cm,
    stat-box([10/10], [全 seed で $rho_x > 0$・符号統一]),
    stat-box([0.88–0.95], [align $rho_x$（理想型4種）]),
    stat-box([60–99°→14–25°], [向きの seed ばらつき縮小]),
  )
]

// Card 5: y軸の解釈（固定後の縦軸は何か）
#let sec-zy = [
  x軸固定後、残る y軸 $z_y$ を *理想組織グラフ* で構造指標と相関させると、
  *コミュニティ数（サブチームの数）* と最もよく相関（Spearman 0.73、hub 除外 0.63、x軸対照 0.19 ≪ 0.73）。5 理想型を分離（型分離 $eta^2 = 0.77$）。

  #figure(
    image("assets/zy_by_type.png", width: 64%),
    caption: [符号を揃えた型別 $z_y$。統合的（hub・完全グラフ, nc=1）が一方の端、分断的（modular/階層/mentorship, nc=2–3）が反対端。],
  )

  #text(size: 16pt, fill: tml-gray)[
    ※ コミュニティ数＝modularity $Q$ 最大化分割のグループ数（$Q approx 0$ 塊なし／$Q > 0.3$ サブチームあり）。
  ]

  #highlight-box[
    *y軸の解釈:* 上下は *組織のサブチームの個数（統合↔分断）* を示しているのではないか。
    5 つの理想構造に注目すると、$z_y$ の値で 3 カテゴリに分けられる。
  ]
]

// Card 6: 限界・本丸の課題（陽 vs 潜在）
#let sec-conclusion = [
  *y軸解釈の限界:* 理想型限定。実組織は閾値1集計で *完全グラフ* に見え（密度 0.999, nc=1）転移しない（実データの $z_y$ は主にサイズ）。sym≥20 では密度 *0.700* で再解釈の余地。

  *本丸の課題:* 1軸の固定は「特徴量を抽出してプロット」と同じで *潜在空間でなく陽な空間* になる。目指すのは *潜在のまま方向に解釈性を持たせる* こと。手段は (a) *補助変数* で潜在を一意に、(b) *後付け* で解釈軸を別途。

  #highlight-box[
    *一言で:* 指標を「見つけた」のではなく、損失で *軸に意味を与えた*。
    x軸＝通信量変化（陽・連続・seed 安定）／ y軸＝統合↔分断（自由・カテゴリ）。
    だが固定は陽化でもある——*潜在のまま方向を読む* のが次の本丸。
  ]
]
