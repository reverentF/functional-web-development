# Generate a New Web Interface with Phoenix

- Phoenixはいいぞ(はやいかるいわかりやすい)
- Webフレームワークは一般的になったね
    - 共通部分(ルーティングとか)の再開発が不要になった
    - アプリのコア部分に注力できるようになった
    - slippery slope(それをきっかけに物事がどんどん悪い方向に進む危険性を秘めている) コンポーネントがぐちゃぐちゃになってアプリもぐちゃぐちゃに
- Elixirの解答
    - PhoenixもApplication
    - 前の章までで作ったゲームのコアロジックもApplication
    - →　Webインタフェースを完全に分離

## Frameworks
- Frameworkのcomponent
    - 全てのwebアプリに共通の部分
    - ルーティング、リクエストの対応、cookie etc
- business logic
    - 各アプリケーションのコアロジック
    - 共通のフレームワークには切り出せない部分
    - "hidden-in-plain-sight problem" がある
        - 慣れすぎていて気づかない問題?

### Coupling
- bussinessロジックをframework上で作るときの方法は悪化している
    - ルーティング, MVCを追加して
    - それぞれに少しづつロジックを足して ...
    - →　bussinessのドメインとフレームワークのドメインが密結合になってしまっている！
        - 移行の問題
        - テストの問題
- Phoenixは疎結合なのでそのへんいい感じになる
    - freamworkのアップグレードも割と楽

### Phoenix Is Not Your Application
- 「Railsのアプリを作っているよ」とかEmber, Phoenix, Elmのアプリを作っているっていうのは、ちょっと違うよね
- chatやbanking, gameのアプリを、Phoenix, Ember, Elmのインタフェースで作っているっていうのが正しい

- ORMはbussiness logicとframework componentsのcouplingを引き起こす
    - RailsのActiveRecordの例
    - bussiness logicのクラスが、DBへの接続などのframework側の情報も持ってしまう

### Decoupling

- Phoenixの場合はbussiness logicと別Applicationになる
- だから疎結合で嬉しいねと言う話

## Applications

- ElixirのApplicationのはなし
    - moduleよりもひと回り大きい,再利用可能な単位
    - 他のエコシステムでいうところのライブラリに似ている
    - ライブラリよりもより高機能
- Applicationをブロックのように積み重ねて全体を構成する

- `:application`
    - OTPのBehaviour
    - callbackを実装する
    - Elixirがwrapper moduleを用意してくれている

- Application Behaviorのしごと
    - Applicationの名前と定義
    - Application間の依存を管理しやすくする
    - BEAM内での個々のApplicationの起動/停止を容易に

- 具体的には
    - 依存するApplicationを先に起動したり
    - Applicationがspawnしたプロセスの経過を追ったり
    - Application終了時にそれらを止めたり

## Understanding Applications
- これまでに作ったIslandEnginもApplication
    - Mixが自動生成してくれてる
- これを使って依存の管理やアプリの起動/停止をやってみよう

- `mix.exs` : Applicationの設定(名前, バージョン, 依存)
- `lib/app_name/application.ex` : Behaviour callback

- コンパイルするとmixはErlangで書かれたリソースファイルを作る
- これを見てBEAMはApplicationを動かす


### Managing Dependencies

- `mix.exs`の説明
    - `deps/0` : ビルド時の依存関係
    - `application/0` : 実行時の依存関係

### Starting and Stopping Applications

- Applicationの起動/停止時の設定
    - `lib/app_name/application.ex` でBehaviorとして
    - `use Application`てなってる
- supervisorの設定もここでしたね

- リソースファイルの説明
    - `/_build/dev/lib/<app_name>/ebin/<app_name>.app`
- `iex -S mix`
    - `mix.exs`が実行
    - ApplicationのBehaviourの`start/2`が実行
    - Applicationが起動する

- `:application​.which_applications/0`
    - 起動中のApplicationの情報

## Generate a New Phoenix Application

- ついにPhoenixを導入する！
    - Ectoは使わない

`[info] Sent 200 in 197µs`
> Yes, with Phoenix, we can measure the page load times in microseconds.

## Adding a New Dependency

- ゲームのロジック(islands_engine)をphoenix側のcompile-time dependencyに追加
- iexでengineが動いてるのを確認

## Call the Logic from the Interface

- Phoenixのインタフェースからゲームのロジックを呼んでみる
- デフォルトのスタートページを弄って実験
