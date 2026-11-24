# formal-first-diabetes-regression-4

メインの claim の検証と、信頼性条件の検証を分けて、実験の前に Lean で宣言する試行。

研究の指示: Efron らの糖尿病データセットに線形回帰モデルを当てはめ，テストデータに対する MSE が 3400 を下回るかを調べる

```
C00: C01 が成り立ち、信頼性条件（R01）を満たす
├─ C01（メインの claim）: 出力された MSE < 3400
│   └─ C02: 宣言した手順で、MSE が値として定まる
│       └─ 宣言（C03〜C10）: データセット、読み込み、分割、当てはめ、予測、MSE、計算環境、リポジトリの版
└─ R01: 信頼性条件
    ├─ 公理（R02〜R04）
    ├─ R05: すべての宣言について、宣言した値は観測した値と一致し、その宣言のほかの検証も成り立つ（R06〜R20）
    ├─ HARKing をしていない（R21）
    └─ チェリーピッキングをしていない（R22）
```

- 宣言（C03〜C10）は、値の定義（`C05.value` など）と、定義をそのまま言う命題
- R05 の行は、宣言ごとに「宣言した値 = GitHub の検証器が観測した値」と、その宣言のほかの検証を並べる。行が欠けると Lean が通らない
- スキーマ: [`formal/claims.json`](formal/claims.json)（claims の形式化、値の取り方。検証の結果もここに書く）
  - claim 1 つが Lean の命題 1 つで、命題の名前が claim の ID
  - `formal/lean/Spec.lean` は、ここから生成する（commit しない）
- 証明に必要なもの: [`formal/lean/Proofs.lean`](formal/lean/Proofs.lean)（claims の形式化とは別に置く）
- 実験コード: [`src/run_experiment.py`](src/run_experiment.py)

## 結果

本番は 1 回だけ実行した（[実験の run](https://github.com/auto-res2/formal-first-diabetes-regression-4/actions/runs/45454383148)、[検証の run](https://github.com/auto-res2/formal-first-diabetes-regression-4/actions/runs/45454456501)）。

- テストデータに対する MSE は 3424.26。C01（出力された MSE < 3400）は偽
- R01（信頼性条件）は真。公理 R02〜R04 に依存する。R05（すべての宣言について、宣言した値は観測した値と一致する）、R21、R22 も真
- C00 は偽（C01 が偽のため）
- 検証された値は [`formal/lean/Values.lean`](formal/lean/Values.lean)、各 claim の判定の定理は [`formal/lean/Theorems.lean`](formal/lean/Theorems.lean)。どちらも検証の run が生成したもの
- 論文: [`report/report.pdf`](report/report.pdf)（各文に、元になった claims の ID を付けた）

## 流れ

1. 実行に関するもの（実験コード、依存の固定、実行のコマンド）を commit する
2. その commit の番号を、宣言（C10）に書いて commit する
3. 実験と検証を、GitHub Actions で実行する。実験は、宣言が指定する commit を取り出して、その中身だけで実行する

```bash
python3 formal/cli.py lean                        # claims.json から Spec.lean を書き出す（手元で Lean を通すとき）
gh workflow run run_experiment.yml -f mode=full   # 実験（GitHub Actions）
gh workflow run verify_claims.yml -f mode=full    # 検証（GitHub Actions）。結果は artifact の claims.json
```
