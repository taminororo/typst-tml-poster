// ======================================================================
// content.typ — ★ここだけ書き換えればポスターが完成します
// 文面の出所（唯一の正）:
//   digress-research/docs/ポスター本文_2026-06-26.md
//   digress-research/docs/ポスター設計_2026-06-26.md
// 用語厳守: 「整合損失」の語は使わず機能で記述（横軸を通信量変化に整合させる補助損失）。
//   η²=0.77 は型分離、Spearman 0.73 は nc 相関（混同しない）。λ は値を断定せず「係数 λ で調整」。
// ======================================================================
#import "template/tml-poster.typ": highlight-box
#import "template/colors.typ": tml-gray, tml-accent, tml-blue, tml-light, tml-text

// ── メタ情報 ──────────────────────────────────────────────────────────

#let poster-title    = [Slack ログから構築したコミュニケーショングラフに対する GraphVAE の潜在表現の解釈]
#let poster-subtitle = [横軸を「通信量の変化」に揃える補助損失で解釈軸を 10 seed にわたり安定化する。あわせて残る縦軸が表す構造と、潜在表現を保ったまま解釈するという課題を述べる。]
#let poster-authors  = [上林 英佑]
#let poster-affil    = [情報・経営システム工学分野 B4 ／ 機械学習理論研究室（TML）／ 指導教員: 雲居 玄道 ／ 学籍番号 23103285]
#let poster-conf     = [機械学習理論研究室（TML）学内ポスター発表]
#let poster-contact  = [上林 英佑（学籍番号 23103285）]
#let poster-funding  = [GraphVAE 組織グラフ ／ 潜在軸の解釈]

// ── 部品 ──────────────────────────────────────────────────────────────

// 各パネル冒頭のテイクアウェイ（遠目で残す1行）
#let lead(body) = block(
  below: 0.5cm,
  text(weight: "bold", fill: tml-blue, size: 23pt, body),
)

// 主結果の3連スタッツ
#let stat-box(value, label) = block(
  width: 100%,
  fill: tml-light,
  inset: (x: 8pt, y: 9pt),
  stroke: (top: (thickness: 3pt, paint: tml-accent)),
  align(center + horizon)[
    #text(size: 26pt, weight: "bold", fill: tml-accent)[#value]
    #v(0.15cm)
    #text(size: 16pt, fill: tml-gray)[#label]
  ],
)

// ── セクション内容 ────────────────────────────────────────────────────

// パネル1: 研究背景と目的
#let sec-background = [
  #highlight-box[
    *潜在軸における「方向」と「意味」の対応は、学習の乱数 seed に対して安定に成り立つか。*
  ]

  - 組織の Slack 通信グラフを GraphVAE により 2 次元の潜在ベクトル $z_g = (z_x, z_y)$ へ符号化し、潜在空間上の移動方向に組織変化の意味を対応づけ、組織が遷移しうる方向を提示することを目指す。
  - 潜在表現を用いるのは、未知の組織でどの特徴量が重要かを事前に定められず、人手設計の陽な表現よりも、データから学習される潜在表現が適するためである。
  - 入力はノードを各メンバー（学年・役割付与）、エッジを 2 者間の通信量とするグラフで、実組織 28 件と理想型 5 件を基本とする。各基本グラフから一部エッジの通信量を一定量ずつ増減させた拡張グラフを学習データに加える（増減操作と量 $N$ は 2 節）。
]

// パネル2: 問題（図なし・数値で述べる）
#let sec-problem = [
  #lead[移動方向の seed 間のばらつきは 60〜99° に達し、方向と意味の対応が成立しない。]

  - UP/DOWN 拡張（通信量を増減したグラフ）の、潜在空間上での移動方向（角度）を測定する。
  - 潜在空間の回転自由度のみであれば相対的な向きは保たれるが、実測では向き自体が seed 間で *60〜99°*（円周標準偏差）ばらついた。
  - $N$ は通信量を一定量ずつ増減させたエッジの本数であり、連続な通信量を離散ステップで操作したものである（UP $= +N$、DOWN $= -N$）。
  - 各 seed・各理想型について UP 拡張の移動方向の角度を求め、その seed 間ばらつき（円周標準偏差）が *60〜99°* に達することを確認した。
]

// パネル3: 提案（全幅・数式）
#let sec-method = [
  #lead[横軸 $z_x$ と符号付き変化量 $N$ の相関を最大化する補助項を損失に導入する。]

  $ cal(L)_"align" = - rho(z_x, t), quad t = plus.minus N $

  - 各グラフに符号付き変化量 $t$（UP $= +N$、DOWN $= -N$、原本 $= 0$）を付与する。
  - 横軸 $z_x$ と $t$ の Pearson 相関を最大化する項を、補助項として損失に加える。
  - 二乗誤差でなく相関を用いるのは、VAE の KL 項が潜在スケールを縮小するため、絶対値でなく順序と向きのみを要求する形が再構成項・KL 項と両立しやすいことによる。拘束は横軸 $z_x$ に限り、係数 $lambda$ で調整する。
]

// パネル4: 主結果（全幅・表＋3スタッツ）
#let sec-results = [
  #lead[全 10 seed で $rho_x$ は約 0 から 0.9 へ向上し、移動方向のばらつきは 60〜99° から 14〜25° へ縮小する。]

  - $rho_x$（横軸 $z_x$ と符号付き $N$ の相関）は、x 軸が通信量変化に連動する度合いを表す。
  - baseline の 0.0〜0.4 から補助損失により *0.88〜0.95* へ向上し、全 10 seed で符号が一致する。再構成性能の劣化は認められない。

  #v(0.2cm)
  // ── ρ_x 表（半幅・全カラム幅）──
  #table(
    columns: (auto, 1fr, 1fr, 1.1fr),
    inset: (x: 8pt, y: 7pt),
    align: (left, center, center, center),
    stroke: (paint: tml-blue, thickness: 0.6pt),
    fill: (col, row) =>
      if row == 0 { tml-blue }
      else if calc.odd(row) { tml-light }
      else { white },
    table.header(
      text(fill: white, weight: "bold", size: 17pt)[組織構造],
      text(fill: white, weight: "bold", size: 17pt)[baseline $rho_x$],
      text(fill: white, weight: "bold", size: 17pt)[align $rho_x$],
      text(fill: white, weight: "bold", size: 17pt)[角度 std\ base→align],
    ),
    [modular],      [+0.34], text(fill: tml-accent, weight: "bold")[+0.95], [60°→25°],
    [hub],          [+0.40], text(fill: tml-accent, weight: "bold")[+0.94], [73°→19°],
    [hierarchical], [−0.02], text(fill: tml-accent, weight: "bold")[+0.88], [84°→14°],
    [mentorship],   [+0.08], text(fill: tml-accent, weight: "bold")[+0.91], [99°→17°],
  )

  #v(0.3cm)
  // ── 3スタッツ（表の下に横並び）──
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.4cm,
    stat-box([10/10], [全 seed で $rho_x > 0$・符号一致]),
    stat-box([0.88–0.95], [align の $rho_x$（理想型 4 種）]),
    stat-box([60–99° → 14–25°], [向きの seed 間ばらつき縮小]),
  )

  #v(0.2cm)
  - 完全グラフ K_10 では整合が達成されない。学習データが疎な実組織に限られ、K_10 が分布外（OOD）となるためと考えられる。
]

// パネル5: y軸の解釈（図 zy_by_type）
#let sec-zy = [
  #lead[縦軸はサブチームの個数（統合と分断）に対応すると考えられる。]

  - 横軸を固定した後、縦軸 $z_y$ を理想組織グラフについて各種構造指標と相関させると、コミュニティ数（サブチーム数）との相関が最も高い（Spearman 0.73、hub 除外時 0.63、x 軸との対照 0.19）。
  - 型分離の相関比は $eta^2 = 0.77$ であり、5 つの理想型が統合的な型（hub・完全グラフ）と分断的な型（modular・階層・mentorship）の 3 群に分かれる（実データへの一般化には限界がある。6 節）。

  #figure(
    image("assets/zy_by_type.png", width: 60%),
    caption: [符号を揃えた型別の $z_y$。統合的な型（hub・完全グラフ, nc=1）が一方の端、分断的な型（modular・階層・mentorship, nc=2–3）が他方の端に分かれる。],
  )
]

// パネル6: 限界と今後の課題（陽 vs 潜在）
#let sec-conclusion = [
  #lead[1 軸の固定は陽な表現化に相当する。潜在表現を保ったまま方向へ解釈性を与えることが今後の課題である。]

  - y 軸の解釈は理想型に限定される。実組織は閾値 1 の集計では完全グラフに近く（密度 0.999、コミュニティ数 1）、解釈が一般化しない（実データの $z_y$ は主に組織規模に連動する）。辺の閾値を sym ≥ 20 とすると密度は 0.700 まで低下し、再解釈の余地が生じる。
  - 1 軸を固定することは、グラフから特徴量を抽出して座標に配置することと等価であり、潜在表現ではなく陽な表現となる。目標は潜在表現を保ったまま方向へ解釈性を与えることである。
  - 今後の方向として、(a) 補助変数により潜在を一意に定める手法、(b) 学習後に解釈軸を別途構成する手法が挙げられる。

  #highlight-box[
    本研究は解釈に適した指標を発見したのではなく、損失設計により潜在軸へ意味を付与した点に特徴がある。
    x 軸は通信量変化（陽・連続・seed 安定）に、y 軸は統合と分断（自由・カテゴリ的）に対応する。
  ]
]
