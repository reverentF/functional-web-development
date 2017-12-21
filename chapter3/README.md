# Chapter3. Manage State with a State Machine
- Elixirでどうやってstate machineを実装していくのか
    - (ここではまだ)DBに保存せず、Genserverのプロセス上に保持していくよ
## State Machines
- `'state'`という語
    - ElixirではElixirのプロセスに保持されているデータのこと
    - 一般のステートマシンでいうstateではない
    - ただし、この章では後者
- ECサイトをStateMachineで実装する例
    > “Events trigger state transitions.”

## Functional State Machine for Islands
- 前の章で作ったゲームにState Machineを導入するよ
- OTPには`:gen_statem`という素晴らしいステートマシンがあるが**今回は使わない**でスクラッチでかくよ
- 状態遷移の可否をfunctionが決める
    - while list方式で
- `/lib/islands_engine/rules.ex`
    - `check/2`
      - 現在の状態とアクションを渡して状態遷移の可否を決める
    - ゲームの状態とplayerごとの状態を保持

## 知見
- ゲームのロジックと状態の保持は切り分ける
- mixのtestも書きつつやってみた