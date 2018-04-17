# Create Persistent Connections with Phoenix Channels
- Phoenixのすげー機能Channelを使うぞ
    - statefulなサーバとクライアントをpersistent connectionで繋ぐ
- 2ブラウザで対戦できるところまで持っていく

## The Beauty of channnels
- 200万の同時接続; 数秒でブロードキャスト可能な
- Channnel
    - soft-real-time communication
    - 双方向
- クライアント = front-end web client
    - backend, 他のサーバーにメッセージを遅れる
- Web sockertよりも高機能
    - 別(独自)プロトコルでもデータ送信可能
    - うまくfailureを扱える 再接続とか - WebSocketだと自分でやらないといけない部分
    - 伝統的なMVCよりもコード量が少ない
- gameのロジックはchannnelの中には全く実装しないo

## The Pieces That Make a Channel
- 実はChannelにはいくつかのレイヤがある

### The Channel Module
- Phoenixで定義されたcustom Behaviour
- 定義するcallback
    - `join/3` : clientがtopicに接続するとき
    - `handle_in/3` : 受信メッセージの扱い？

#### Socket
- `Phoenix.Socket` : Phoenix application で定義されたBehaviour
- 接続の開始・維持
- 接続の状態も持つ

#### Transport
- WebSocketsとlong-pollingがつかえる
- `Socket.Transport` : API for building transports

#### Phoenix PubSub
- PubSub : publish and subscribe
- メッセージの送受信制御とか

#### Presence
- CRDTというデータタイプを扱う
    - Conflict-free Replicated Data Type
    - コンフリクトしない複製可能なデータ
    - 違う変更操作の履歴をもつレプリカが、あとから難なくマージできる
    - https://qiita.com/everpeace/items/bb73ec64d3e682279d26
- これを使ってchannelの接続を維持したりする？

#### Client Code
- フロント側のいろんな言語でChannel使えるパッケージがあるよ

## Let's Build It
- gameのinterfaceをつくるよ
- 1つのchannelが複数のtopicにメッセージを送信可能
    - -> Player2人に1つのchannel

- `endpoint.ex` : ルーティング
- `user_socket.ex` : どのメッセージをどのchannelで扱うかの設定
    - `connect/2` : authenticateとかsocketに情報付加したりとかここでやると良いらしい

## Join a Channel
- `game_channel.ex`
    - `join/3` : topicへの接続

## Establish a Cient Connection
- フロントのjsからconnectionをつなぐ
    - phoenix.js
- joinできることを確かめる

## Converse Over a Channel
- もうちょっとリッチなインタフェースがあるよ
- サーバー -> クライアント
    - `:reply` タプルを返す
- イベントの通知
    - `push/3`: イベントを通知
    - `broadcast/3`: ブロードキャストもできる
- `push`や`broadcast`で渡されるイベントに対してのcallbackを`handle_in`で実装していく

## Connect the Channel to the Game

