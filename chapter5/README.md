# Process Supervision for Recovery

- どんなに善処してもシステムは例外を吐きサーバは死ぬ
- "fault tolerance"でこの不可避の問題に立ち向かう
- ということでSupervisorのはなし

## Fault Tolerance
- ErlangとElixirはすっげーfault toleranceを持ってるって噂があるが、それは本当だ
  - エラーを防ぐのではなく、どんな実行時エラーが発生しても回復させる
- ほとんどの言語には例外処理がある
    - 事前にリスキーなコードを特定しブロックに入れ例外発生時の処理を書かなければならない
- EricssonのOTPチーム曰く
    > extreme fault tolerance wasn't a "nice to have".
    - 事前に全ての障害を潰すのは辛いから、障害からの回復にフォーカスしよう
    - ということでSupervisor Behaviourができた。
        - 例外処理とビジネスロジックを分離できる
- Supervisor Behaviourの基本的な考え
    1. ほとんどの実行時エラーは一時的なもので、bad stateによって起こる
    2. bad stateの改善の最良の方法はプロセスをクラッシュさせ、good stateで再起動することだ
    3. 再起動はBEAMのような小さく、独立したプロセスでうまく働く

## Linking Processes
- Supervisorの2つのメカニズム
    1. linking processes
    2. trapping exits
- supervisionするためには対象のプロセスとリンクして、死んだことを検知する必要がある
- 中身はプログラミングElixirでやったので飛ばす

## Introducing the Supervisor Behaviour
- 木構造とれるよとか
- `:max_restarts` : 1フレームあたりの最大再起動プロセス数
- `:max_seconds` : 1フレームに最大何秒割り当てるか(？)

## Supervision Strategies
- 死んだプロセスを再起動するだけでいいのか、他のプロセスも再起動すべきならどのプロセスか決定しないといけない
- その戦略例
### One For One
- 死んだプロセスを再起動する
- 子プロセスが独立のときに
### One For All
- 1つプロセスが死んだら皆再起動
- プロセスが互いに依存している時に
### Rest For One
- あるプロセスが死んだ時、それ以降に生成されたプロセスを再起動
- 以前のプロセスに依存している場合に
### Simple One for One
- Supervisorがそれぞれ1つのプロセスしか監視しない？
- 1つ死んだらそれだけ再起動
- 動的に追加される子プロセスに最適、らしい
- IslandsEngineではこれをつかうよ
- *Elixir1.6でdeprecatedになった*
    - 代わりはDynamicSupervisorモジュール
## The Child Specification
- GenServerはSupervisorの子プロセスとしての設定をデフォルトで用意している
- `child_spec/1`で確認可能
    - 例
        ```elixir
        %{  id: IslandsEngine.Game,​
            restart: :permanent,
            shutdown: 5000,
            start: {IslandsEngine.Game, :start_link, ["Kusama"]},
            type: :worker}
        ```
    - `id` : Supervisorが子プロセスの識別に使う
    - `:restart` : Supervisorが子プロセスを再起動するかどうか
        - `:permanent` : 常に再起動
        - `:temporary` : 再起動しない(一時的なプロセス)
        - `:transient` : 例外で死んだ時は再起動(正常終了なら再起動しない)
    - `:shutdown` : Supervisorが子プロセスをkillするときの待ち秒数(？)
    - `:start` : プロセス再起動のためのモジュール名・関数・引数
    - `:type` : worker or supervisor

## A Supervisor for the Game
- 1Gameに1プロセス
- `:simple_one_for_one`

## Starting the Supervision Tree
- [IslandsEngineSupervisor] -> [GameSupervisor] -> some [Game]
    - :simple_one_for_one なのにGameプロセス複数(?)

## Starting and Stopping Child processes
- GameSupervisorにゲーム起動/終了関数追加
- タイムアウト時の処理とか
- ExUnitでのテスト時に別テストのプロセスが残っていて失敗したりしたので後で調べる

## Putting the Pieces Together
- これまでのコードをiexで確認

## Recovering State After a Crash
- 状態を保存するように変更を加える
- ETS(Erlang Term Storage)をつかう
    - メモリ上にタプルを保存するためのkey-valueストア
    - 作成 : `:ets.new(:table_name, [:set, :public, :named_table])`
    - 挿入ほか : `:ets.insert(:table_name, {:key, "value"})`
- テーブル
    - `:set` : 普通のkey-valueストア
    - `:ordered_set` : orderつき
    - `:bag` : 1つのkeyに複数value保存可
    - `:duplicate_bag` : key-valueが同じでも重複して入れられるbag
- プロセスごとの権限設定も可能(`:private, :protected, :public`)
- `init/1`でETSを読みに行くと、プロセス再起動時にETSの読み込み待ちでSupervisorがブロッキングされる可能性
    - → `init/1`では自身にメッセージを投げるだけにし、ETSの確認は別関数で行う
    - 初期化用のメッセージより先に他のメッセージがした場合に変な挙動をしないように気をつけよう

## Data Durability
- BEAMを再起動する際に状態を復元するには永続層が要るね
- ファイルとか別プロセスに
- DETS : disk-basd version of ETS
- Mnesia : database management system

## まとめ
- プログラミングElixirでもやったしだいたいわかった
- 正しいテストのやり方がわからないから調べる必要あり