// ======================================================================
// content.typ — ★ここだけ書き換えればポスターが完成します
// 内容の出所: digress-research/docs/papers/posters/23103285_上林英佑_v2/poster.html
// ======================================================================
#import "template/tml-poster.typ": highlight-box
#import "template/colors.typ": tml-gray, tml-accent, tml-blue, tml-light

// ── メタ情報 ──────────────────────────────────────────────────────────

#let poster-title    = [潜在空間の軸に「通信量の変化」を刻む整合損失]
#let poster-subtitle = [GraphVAE の解釈軸を seed 普遍に立てる — 「右に進む＝通信が増える」を 10 seed で安定化]
#let poster-authors  = [上林 英佑]
#let poster-affil    = [情報・経営システム工学分野 B4 ／ 機械学習理論研究室（TML）／ 指導教員: 雲居 玄道 ／ 学籍番号 23103285]
#let poster-conf     = [機械学習理論研究室（TML）学内ポスター発表]
#let poster-contact  = [上林 英佑（学籍番号 23103285）・指導教員: 雲居 玄道]
#let poster-funding  = [整合損失 (align loss) ／ GraphVAE 潜在空間の解釈軸]

// ── 3連スタッツ（keybox）コンポーネント ──────────────────────────────
#let stat-box(value, label) = block(
  width: 100%,
  fill: tml-light,
  inset: (x: 8pt, y: 12pt),
  stroke: (top: (thickness: 3pt, paint: tml-accent)),
  align(center + horizon)[
    #text(size: 30pt, weight: "bold", fill: tml-accent)[#value]
    #v(0.15cm)
    #text(size: 16pt, fill: tml-gray)[#label]
  ],
)

// ── セクション内容 ────────────────────────────────────────────────────

// Card 1: 研究背景と目的
#let sec-background = [
  組織の *Slack 通信グラフ* を、心理・意欲を扱う因果分析の *説明変数* にしたい
  （最終目標は「人と人の最適な組み合わせ」を見つけること）。
  そこで GraphVAE でグラフを 2 次元の潜在ベクトル $bold(z)_g$ に圧縮する。

  鍵は潜在空間の *軸に意味を与える* こと——「右に進むほど通信が増える」のように
  *座標の方向そのものを解釈可能* にすれば、潜在ベクトルがそのまま
  因果分析の定量的な説明変数として使える。

  #highlight-box[
    *問い:* 潜在軸の「方向＝意味」は、乱数 seed を変えても安定して成り立つか？
  ]
]

// Card 2: 問題提起（seed で軸がバラバラ）
#let sec-problem = [
  エッジを増減して「通信を増やした／減らした」グラフ（*UP / DOWN 拡張*）を作り、
  潜在空間での移動の *向き（角度）* を測ると、同じ構造でも
  *seed ごとに向きが大きく食い違う*。

  #figure(
    image("assets/seed_compare.png", width: 88%),
    caption: [*10 seed の潜在空間 $bold(z)_g$*。★=元グラフ、点=拡張（色=元組織）。
      クラスタの配置・向きが seed ごとに変わる。],
  )

  baseline では UP 方向の角度の seed 間ばらつき（円周標準偏差）は組織により
  *60〜99°*。この状態では「方向＝意味」が成立しない。
]

// Card 3: 提案手法（整合損失）
#let sec-method = [
  各グラフに *符号付き変化量* $t$（UP は $+N$, DOWN は $-N$, 元組織は $0$）を与え、
  横軸座標 $z_x$ と $t$ の *Pearson 相関* $rho$ を最大化する損失を 1 本足す。

  $ cal(L)_"align" = - rho(z_x, t), quad t = plus.minus N $

  *MSE でなく相関* にした理由：VAE の KL が潜在スケールを縮めるため、
  絶対値でなく「順序・向き」だけを要求すれば再構成・KL と衝突しにくい。
  拘束は横軸 $z_x$ のみ、係数 $lambda$ で釣り合わせる。

  #v(0.2cm)
  #text(size: 16pt, fill: tml-gray)[
    実装: `return -(num / den)  # maximize Pearson ρ`
    — `compute_align_loss()`, `scripts/train.py:133–150 @cedb973`
  ]
]

// Card 4: 主結果（本丸）
#let sec-results = [
  疎な 4 組織 × 10 seed。$rho_x$ ＝ 横軸 $z_x$ と符号付き $N$ の相関（10 seed 平均）。

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

  #v(0.3cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.4cm,
    stat-box([10/10], [全 seed で $rho_x > 0$・符号統一]),
    stat-box([2〜6×], [角度 std 縮小（4 組織の実測比）]),
    stat-box([+1.65], [分離度改善（hub・単 seed PoC）]),
  )
]

// Card 5: 補助検証（単調性・汎化）
#let sec-aux = [
  向きとは別に *移動量（潜在距離）は $N$ に単調*。実データ 26 組織平均で
  Spearman $rho$ ＝ *0.58 / 0.51*（UP/DOWN とも正の相関）。

  #figure(
    image("assets/distance_vs_N.png", width: 72%),
    caption: [*潜在距離 vs $N$（ある組織）*。$N$ とともに単調増加。],
  )

  #highlight-box[
    *汎化:* 訓練／未知の拡張でも UP/DOWN 角度差は中央値 *6.07°*（26 組織・seed-3）。
    暗記でなく多様体を学習していると読める。
  ]
]

// Card 6: 限界・今後／まとめ
#let sec-conclusion = [
  - *K_10（完全グラフ）は失敗*——align $rho_x = -0.09 plus.minus 0.58$。
    訓練が全て疎で *分布外（OOD）* のため軸が立たない（完全だから、でなく分布外だから）。
  - *縦軸 $z_y$ は未拘束*——意味づけは横軸 $z_x$ のみ。$z_y$ の解釈は今後の課題。

  #highlight-box[
    *一言で:* 指標を「見つけた」のではなく、損失で *軸に意味を与えた*。
    疎な実組織では $z_x$ が「通信量変化 $plus.minus N$」の seed 普遍な代理になる。
  ]
]
