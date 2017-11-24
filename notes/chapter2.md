# Chapter2. ModelData and Behavior
- frameworkを使わずに(使うのを延期して)アプリを作る利点
    - bussiness logicがframeworkに引っ張られずに済む
    - コアアプリの一部分としてframeworkを使う(インタフェースとして？)
- DBを使わずに(延期して)アプリを作る利点
    - DBの構造に頭を使わずに済むね
    - ORM使ってもORMの表現とDBの表現で辛いね
    - Elixirにはスゲーのがあるぜ -> Supervisorで云々
        - 永続化しない？
- ゲームの要件まとめ
    - モデルの作成
        - Coordinate
            1. tuple `{1,1}` bad -> JSON
            2. map `%{row:1, col:1}` 
            3. struct good -> key check(on compile), type check(on runtime)

## 知見
- 未だオブジェクト思考脳だったので`Island.guess()`で結果 + 状態を変更されたIslandを返すのが新鮮だった
    - ユーザの要求に対して `{ 結果 + 変更された状態 }` を返すのは意識していこう

## メモ
- ファイルのパスの表記が`lib/islands_engine/...`と`model_data/lib/islands_engine/...`の2つあるが...?
    - Forumを見にいったら”Elixir1.5.xからの仕様だよ”とあった
    - Elixir(mix)アプデしても`model_data`以下のファイルは読まれず、謎