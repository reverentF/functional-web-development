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