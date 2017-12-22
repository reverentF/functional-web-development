# Wrapping Up In a GenServer

- GenServerでやるぞ

## A Look at Micro-Services
- GenServerの前にmicro servicesのはなし
    - アプリケーションが成長すると巨大かつ複雑になりメンテは地獄
    - 細かく分割したいよね
    - micro-services流行る前はSOA(service oriented architecture)とか言われてたよ(へー)
- 巨大なアプリを分割することは、大きな関数を小さなものに分割する作業、そのスケールアップ版だ
    - 細かい関数に分け、またそれらを組み合わせ元の関数を構成する
    - 再構成の鍵は`communication`だ
    - サービス間だったらHTTPで会話するね
- 細分することによるAdvantage
    - Unixのパイプでわかるね
- Disadvantage
    - テストやデプロイ(個々のサービスのバージョン管理など)が大変になる
    - 各サービスの死活監視
        - Circuit breakers
    - 一番辛いとこ : どこでモノリス(巨大になったサービスのこと？)を破壊するか決めること
        - 指標がない
        - オブジェクト指向のように言語レベルの構造がない(クラスとか)
        - ElixirではOTPがうまいことやってくれるんすよ

## OTP Solutions
- OTPのはなし
    > OTP’s toolset is extensive.

    > It includes an in-memory key-value store (ETS), a relational database (Mnesia), monitoring and debugging tools (Observer, Debugger), a release management tool (Reltool), a static analysis tool (Dialyzer).

- Behaviorのはなし
- ElixirにおけるAplicationのはなし
    - Phoenixを使う際に、Webインタフェースとゲームロジックを分離することにも役立つ

## Getting Started With GenServer
- GenServerの使い方から
    - プログラミングElixirの復習